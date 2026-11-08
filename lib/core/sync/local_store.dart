import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import 'hlc.dart';
import 'sync_change.dart';

/// One row change requested by a feature, before it gets a sequence and HLC.
class LocalChange {
  const LocalChange(this.entity, this.entityId, this.op, this.fields);

  /// INSERT of a new row with a fresh UUIDv7 id.
  factory LocalChange.insert(String entity, Map<String, dynamic> fields, {String? id}) =>
      LocalChange(entity, id ?? const Uuid().v7(), 'INSERT', fields);

  factory LocalChange.update(String entity, String id, Map<String, dynamic> fields) =>
      LocalChange(entity, id, 'UPDATE', fields);

  final String entity;
  final String entityId;
  final String op;
  final Map<String, dynamic> fields;
}

/// A record as stored locally.
class LocalRecord {
  const LocalRecord(this.entity, this.id, this.data, this.deleted);
  final String entity;
  final String id;
  final Map<String, dynamic> data;
  final bool deleted;

  T? get<T>(String field) => data[field] as T?;
}

/// The terminal's local replica and change log (SRS 4.3–4.6, same rules as the backend merger).
///
/// * Local writes: one call = one atomic transaction = one sync transaction with contiguous seqs.
/// * Incoming changes (server or peers): field-level last-writer-wins by HLC, append-only rows inserted
///   once, order status never moves backwards (VOIDED > SETTLED > BILLED > OPEN), delete wins.
class LocalStore {
  LocalStore(this.db, [this._wallMs]);

  final AppDatabase db;
  final int Function()? _wallMs;
  HlcClock? _clock;
  String? _origin;

  static const appendOnly = {
    'cash_movement', 'day_close', 'order_line_modifier', 'order_discount', 'order_event', 'kot', 'payment', //
    'refund', 'refund_line', 'customer_credit_transaction', 'stock_movement', 'supplier_payment',
    'customer_receipt', 'ledger_entry', 'audit_log',
  };
  static const _statusRank = {'OPEN': 0, 'BILLED': 1, 'SETTLED': 2, 'VOIDED': 3};

  /// Must be called once the terminal is paired (origin = device code, e.g. P1).
  Future<void> open(String origin) async {
    _origin = origin;
    final last = await getValue('last_hlc');
    _clock = HlcClock(origin, last: last == null ? null : Hlc.parse(last), wallMs: _wallMs);
  }

  String get origin => _origin ?? (throw StateError('LocalStore.open() was not called'));

  // ---- key/value -----------------------------------------------------------------------

  Future<String?> getValue(String key) async =>
      (await (db.select(db.keyValues)..where((t) => t.key.equals(key))).getSingleOrNull())?.value;

  Future<void> setValue(String key, String value) =>
      db.into(db.keyValues).insertOnConflictUpdate(KeyValuesCompanion.insert(key: key, value: value));

  Future<Map<String, dynamic>> getJson(String key) async {
    final v = await getValue(key);
    return v == null ? <String, dynamic>{} : Map<String, dynamic>.from(jsonDecode(v) as Map);
  }

  Future<void> setJson(String key, Map<String, dynamic> value) => setValue(key, jsonEncode(value));

  // ---- local writes ----------------------------------------------------------------------

  /// Writes [changes] atomically and appends them to the change log. Returns the tx id.
  Future<String> commit(List<LocalChange> changes, {String? userId}) async {
    if (changes.isEmpty) throw ArgumentError('empty transaction');
    final clock = _clock ?? (throw StateError('LocalStore.open() was not called'));
    final txId = const Uuid().v7();
    await db.transaction(() async {
      var seq = int.parse(await getValue('next_seq') ?? '1');
      final now = DateTime.now().toUtc().toIso8601String();
      for (final c in changes) {
        final hlc = clock.now().toString();
        final change = SyncChange(
          changeId: const Uuid().v7(),
          origin: origin,
          seq: seq++,
          txId: txId,
          hlc: hlc,
          entity: c.entity,
          entityId: c.entityId,
          op: c.op,
          fields: c.fields,
          userId: userId,
          createdAt: now,
        );
        await _apply(change);
        await db
            .into(db.changeLog)
            .insert(
              ChangeLogCompanion.insert(
                origin: origin,
                seq: change.seq,
                changeId: change.changeId,
                txId: txId,
                entity: c.entity,
                entityId: c.entityId,
                op: c.op,
                fields: jsonEncode(c.fields),
                hlc: hlc,
                userId: Value(userId),
                createdAt: now,
              ),
            );
      }
      await setValue('next_seq', '$seq');
      await setValue('last_hlc', clock.last.toString());
    });
    return txId;
  }

  // ---- incoming --------------------------------------------------------------------------

  /// Applies changes from the server (or a peer) in one transaction.
  Future<void> applyIncoming(List<SyncChange> changes) async {
    if (changes.isEmpty) return;
    final clock = _clock;
    await db.transaction(() async {
      for (final c in changes) {
        clock?.receive(Hlc.parse(c.hlc));
        await _apply(c);
      }
      if (clock != null) await setValue('last_hlc', clock.last.toString());
    });
  }

  Future<void> _apply(SyncChange c) async {
    final existing = await (db.select(
      db.records,
    )..where((t) => t.entity.equals(c.entity) & t.id.equals(c.entityId))).getSingleOrNull();

    if (existing == null) {
      await db
          .into(db.records)
          .insert(
            RecordsCompanion.insert(
              entity: c.entity,
              id: c.entityId,
              data: jsonEncode(c.fields),
              fieldHlc: Value(jsonEncode({for (final k in c.fields.keys) k: c.hlc})),
              hlc: c.hlc,
              origin: c.origin,
              deletedAt: Value(c.op == 'DELETE' ? (c.fields['deleted_at'] as String? ?? c.createdAt) : null),
            ),
          );
      return;
    }
    if (appendOnly.contains(c.entity)) return; // inserted once, never changed

    final data = Map<String, dynamic>.from(jsonDecode(existing.data) as Map);
    final fieldHlc = Map<String, dynamic>.from(jsonDecode(existing.fieldHlc) as Map);
    var deletedAt = existing.deletedAt;

    if (c.op == 'DELETE') {
      deletedAt ??= c.fields['deleted_at'] as String? ?? c.createdAt; // delete wins
    } else {
      for (final e in c.fields.entries) {
        if (c.entity == 'orders' && e.key == 'status') {
          final cur = _statusRank[data['status']] ?? -1;
          if ((_statusRank[e.value] ?? -1) > cur) {
            data['status'] = e.value;
            fieldHlc['status'] = c.hlc;
          }
          continue;
        }
        if (Hlc.compareStrings(c.hlc, fieldHlc[e.key] as String?) > 0) {
          data[e.key] = e.value;
          fieldHlc[e.key] = c.hlc;
        }
      }
    }
    final rowHlc = Hlc.compareStrings(c.hlc, existing.hlc) > 0 ? c.hlc : existing.hlc;
    await (db.update(db.records)..where((t) => t.entity.equals(c.entity) & t.id.equals(c.entityId))).write(
      RecordsCompanion(
        data: Value(jsonEncode(data)),
        fieldHlc: Value(jsonEncode(fieldHlc)),
        hlc: Value(rowHlc),
        deletedAt: Value(deletedAt),
      ),
    );
  }

  // ---- reads ---------------------------------------------------------------------------------

  LocalRecord _toRecord(Record r) =>
      LocalRecord(r.entity, r.id, Map<String, dynamic>.from(jsonDecode(r.data) as Map), r.deletedAt != null);

  Future<List<LocalRecord>> all(String entity, {bool includeDeleted = false}) async {
    final q = db.select(db.records)..where((t) => t.entity.equals(entity));
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return (await q.get()).map(_toRecord).toList();
  }

  Future<LocalRecord?> find(String entity, String id) async {
    final r = await (db.select(db.records)..where((t) => t.entity.equals(entity) & t.id.equals(id))).getSingleOrNull();
    return r == null ? null : _toRecord(r);
  }

  Stream<List<LocalRecord>> watch(String entity) => (db.select(
    db.records,
  )..where((t) => t.entity.equals(entity) & t.deletedAt.isNull())).watch().map((rows) => rows.map(_toRecord).toList());

  // ---- change log ------------------------------------------------------------------------------

  /// Whole pending transactions in seq order, at most ~[maxChanges] changes.
  Future<List<List<SyncChange>>> pendingTransactions({int maxChanges = 500}) async {
    final rows =
        await (db.select(db.changeLog)
              ..where((t) => t.status.equals('PENDING'))
              ..orderBy([(t) => OrderingTerm(expression: t.origin), (t) => OrderingTerm(expression: t.seq)]))
            .get();
    final txs = <List<SyncChange>>[];
    var count = 0;
    String? currentTx;
    for (final r in rows) {
      if (r.txId != currentTx) {
        if (count >= maxChanges) break;
        txs.add([]);
        currentTx = r.txId;
      }
      txs.last.add(
        SyncChange(
          changeId: r.changeId,
          origin: r.origin,
          seq: r.seq,
          txId: r.txId,
          hlc: r.hlc,
          entity: r.entity,
          entityId: r.entityId,
          op: r.op,
          fields: Map<String, dynamic>.from(jsonDecode(r.fields) as Map),
          userId: r.userId,
          createdAt: r.createdAt,
        ),
      );
      count++;
    }
    return txs;
  }

  Future<int> pendingCount() async {
    final c = db.changeLog.seq.count();
    final q = db.selectOnly(db.changeLog)
      ..addColumns([c])
      ..where(db.changeLog.status.equals('PENDING'));
    return (await q.getSingle()).read(c) ?? 0;
  }

  /// The server's `accepted` vector is the only acknowledgment.
  Future<void> acknowledge(Map<String, dynamic> accepted) async {
    for (final e in accepted.entries) {
      if (e.key == 'SERVER') continue;
      await (db.update(db.changeLog)..where(
            (t) => t.origin.equals(e.key) & t.seq.isSmallerOrEqualValue(e.value as int) & t.status.equals('PENDING'),
          ))
          .write(const ChangeLogCompanion(status: Value('ACKED')));
    }
    final acked = await getJson('acked_vector')
      ..addAll(accepted);
    await setJson('acked_vector', acked);
  }

  Future<void> markRejected(String txId, String code) => (db.update(db.changeLog)..where((t) => t.txId.equals(txId)))
      .write(ChangeLogCompanion(status: const Value('REJECTED'), rejectCode: Value(code)));

  /// Highest contiguous seq per origin held locally (own changes).
  Future<Map<String, int>> heldVector() async {
    final next = int.parse(await getValue('next_seq') ?? '1');
    return {origin: next - 1};
  }
}
