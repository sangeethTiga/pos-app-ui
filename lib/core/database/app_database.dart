import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// Local replica of every replicated entity (catalogue from the server, operations written here).
/// Rows are JSON documents keyed by (entity, id), mirroring the backend's generic sync engine;
/// typed views live in the features (e.g. ProductView).
@TableIndex(name: 'records_entity', columns: {#entity})
class Records extends Table {
  TextColumn get entity => text()();
  TextColumn get id => text()();
  TextColumn get data => text()(); // JSON object
  TextColumn get fieldHlc => text().withDefault(const Constant('{}'))(); // field -> HLC
  TextColumn get hlc => text()();
  TextColumn get origin => text()();
  TextColumn get deletedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {entity, id};
}

/// Changes written on this terminal, in commit order. Sequences per origin are contiguous and never reused.
@TableIndex(name: 'change_log_status', columns: {#status})
class ChangeLog extends Table {
  TextColumn get origin => text()();
  IntColumn get seq => integer()();
  TextColumn get changeId => text().unique()();
  TextColumn get txId => text()();
  TextColumn get entity => text()();
  TextColumn get entityId => text()();
  TextColumn get op => text()();
  TextColumn get fields => text()(); // JSON
  TextColumn get hlc => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get createdAt => text()();

  /// PENDING until the server's `accepted` vector covers it, then ACKED; REJECTED when refused.
  TextColumn get status => text().withDefault(const Constant('PENDING'))();
  TextColumn get rejectCode => text().nullable()();

  @override
  Set<Column> get primaryKey => {origin, seq};
}

/// Small persistent state: next sequence, last HLC, pull cursor, acked vector, gateway epoch ...
class KeyValues extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [Records, ChangeLog, KeyValues])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
