/// One replicated change on the wire. Reads both spellings the backend uses
/// (`op`/`operation`, `fields`/`payload`, `tx_id`/`txn_id`).
class SyncChange {
  const SyncChange({
    required this.changeId,
    required this.origin,
    required this.seq,
    required this.txId,
    required this.hlc,
    required this.entity,
    required this.entityId,
    required this.op,
    required this.fields,
    this.userId,
    required this.createdAt,
  });

  factory SyncChange.fromJson(Map<String, dynamic> j) => SyncChange(
    changeId: j['change_id'] as String,
    origin: j['origin'] as String,
    seq: (j['seq'] ?? j['origin_seq']) as int,
    txId: (j['txn_id'] ?? j['tx_id']) as String,
    hlc: j['hlc'] as String,
    entity: j['entity'] as String,
    entityId: j['entity_id'] as String,
    op: (j['operation'] ?? j['op']) as String,
    fields: Map<String, dynamic>.from((j['payload'] ?? j['fields'] ?? const {}) as Map),
    userId: j['user_id'] as String?,
    createdAt: j['created_at'] as String,
  );

  final String changeId;
  final String origin;
  final int seq;
  final String txId;
  final String hlc;
  final String entity;
  final String entityId;

  /// INSERT, UPDATE or DELETE.
  final String op;
  final Map<String, dynamic> fields;
  final String? userId;
  final String createdAt;

  /// Push format (backend 9.3 spelling).
  Map<String, dynamic> toPushJson() => {
    'change_id': changeId,
    'seq': seq,
    'hlc': hlc,
    'entity': entity,
    'entity_id': entityId,
    'op': op,
    'fields': fields,
    'user_id': userId,
    'created_at': createdAt,
  };
}
