// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RecordsTable extends Records with TableInfo<$RecordsTable, Record> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldHlcMeta = const VerificationMeta('fieldHlc');
  @override
  late final GeneratedColumn<String> fieldHlc = GeneratedColumn<String>(
    'field_hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [entity, id, data, fieldHlc, hlc, origin, deletedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'records';
  @override
  VerificationContext validateIntegrity(Insertable<Record> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity')) {
      context.handle(_entityMeta, entity.isAcceptableOrUnknown(data['entity']!, _entityMeta));
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('data')) {
      context.handle(_dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('field_hlc')) {
      context.handle(_fieldHlcMeta, fieldHlc.isAcceptableOrUnknown(data['field_hlc']!, _fieldHlcMeta));
    }
    if (data.containsKey('hlc')) {
      context.handle(_hlcMeta, hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta));
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('origin')) {
      context.handle(_originMeta, origin.isAcceptableOrUnknown(data['origin']!, _originMeta));
    } else if (isInserting) {
      context.missing(_originMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta, deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entity, id};
  @override
  Record map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Record(
      entity: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}entity'])!,
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      data: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      fieldHlc: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}field_hlc'])!,
      hlc: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}hlc'])!,
      origin: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}origin'])!,
      deletedAt: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $RecordsTable createAlias(String alias) {
    return $RecordsTable(attachedDatabase, alias);
  }
}

class Record extends DataClass implements Insertable<Record> {
  final String entity;
  final String id;
  final String data;
  final String fieldHlc;
  final String hlc;
  final String origin;
  final String? deletedAt;
  const Record({
    required this.entity,
    required this.id,
    required this.data,
    required this.fieldHlc,
    required this.hlc,
    required this.origin,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity'] = Variable<String>(entity);
    map['id'] = Variable<String>(id);
    map['data'] = Variable<String>(data);
    map['field_hlc'] = Variable<String>(fieldHlc);
    map['hlc'] = Variable<String>(hlc);
    map['origin'] = Variable<String>(origin);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  RecordsCompanion toCompanion(bool nullToAbsent) {
    return RecordsCompanion(
      entity: Value(entity),
      id: Value(id),
      data: Value(data),
      fieldHlc: Value(fieldHlc),
      hlc: Value(hlc),
      origin: Value(origin),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
    );
  }

  factory Record.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Record(
      entity: serializer.fromJson<String>(json['entity']),
      id: serializer.fromJson<String>(json['id']),
      data: serializer.fromJson<String>(json['data']),
      fieldHlc: serializer.fromJson<String>(json['fieldHlc']),
      hlc: serializer.fromJson<String>(json['hlc']),
      origin: serializer.fromJson<String>(json['origin']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entity': serializer.toJson<String>(entity),
      'id': serializer.toJson<String>(id),
      'data': serializer.toJson<String>(data),
      'fieldHlc': serializer.toJson<String>(fieldHlc),
      'hlc': serializer.toJson<String>(hlc),
      'origin': serializer.toJson<String>(origin),
      'deletedAt': serializer.toJson<String?>(deletedAt),
    };
  }

  Record copyWith({
    String? entity,
    String? id,
    String? data,
    String? fieldHlc,
    String? hlc,
    String? origin,
    Value<String?> deletedAt = const Value.absent(),
  }) => Record(
    entity: entity ?? this.entity,
    id: id ?? this.id,
    data: data ?? this.data,
    fieldHlc: fieldHlc ?? this.fieldHlc,
    hlc: hlc ?? this.hlc,
    origin: origin ?? this.origin,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Record copyWithCompanion(RecordsCompanion data) {
    return Record(
      entity: data.entity.present ? data.entity.value : this.entity,
      id: data.id.present ? data.id.value : this.id,
      data: data.data.present ? data.data.value : this.data,
      fieldHlc: data.fieldHlc.present ? data.fieldHlc.value : this.fieldHlc,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      origin: data.origin.present ? data.origin.value : this.origin,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Record(')
          ..write('entity: $entity, ')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('fieldHlc: $fieldHlc, ')
          ..write('hlc: $hlc, ')
          ..write('origin: $origin, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entity, id, data, fieldHlc, hlc, origin, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Record &&
          other.entity == this.entity &&
          other.id == this.id &&
          other.data == this.data &&
          other.fieldHlc == this.fieldHlc &&
          other.hlc == this.hlc &&
          other.origin == this.origin &&
          other.deletedAt == this.deletedAt);
}

class RecordsCompanion extends UpdateCompanion<Record> {
  final Value<String> entity;
  final Value<String> id;
  final Value<String> data;
  final Value<String> fieldHlc;
  final Value<String> hlc;
  final Value<String> origin;
  final Value<String?> deletedAt;
  final Value<int> rowid;
  const RecordsCompanion({
    this.entity = const Value.absent(),
    this.id = const Value.absent(),
    this.data = const Value.absent(),
    this.fieldHlc = const Value.absent(),
    this.hlc = const Value.absent(),
    this.origin = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecordsCompanion.insert({
    required String entity,
    required String id,
    required String data,
    this.fieldHlc = const Value.absent(),
    required String hlc,
    required String origin,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : entity = Value(entity),
       id = Value(id),
       data = Value(data),
       hlc = Value(hlc),
       origin = Value(origin);
  static Insertable<Record> custom({
    Expression<String>? entity,
    Expression<String>? id,
    Expression<String>? data,
    Expression<String>? fieldHlc,
    Expression<String>? hlc,
    Expression<String>? origin,
    Expression<String>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entity != null) 'entity': entity,
      if (id != null) 'id': id,
      if (data != null) 'data': data,
      if (fieldHlc != null) 'field_hlc': fieldHlc,
      if (hlc != null) 'hlc': hlc,
      if (origin != null) 'origin': origin,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecordsCompanion copyWith({
    Value<String>? entity,
    Value<String>? id,
    Value<String>? data,
    Value<String>? fieldHlc,
    Value<String>? hlc,
    Value<String>? origin,
    Value<String?>? deletedAt,
    Value<int>? rowid,
  }) {
    return RecordsCompanion(
      entity: entity ?? this.entity,
      id: id ?? this.id,
      data: data ?? this.data,
      fieldHlc: fieldHlc ?? this.fieldHlc,
      hlc: hlc ?? this.hlc,
      origin: origin ?? this.origin,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (fieldHlc.present) {
      map['field_hlc'] = Variable<String>(fieldHlc.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordsCompanion(')
          ..write('entity: $entity, ')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('fieldHlc: $fieldHlc, ')
          ..write('hlc: $hlc, ')
          ..write('origin: $origin, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChangeLogTable extends ChangeLog with TableInfo<$ChangeLogTable, ChangeLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChangeLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changeIdMeta = const VerificationMeta('changeId');
  @override
  late final GeneratedColumn<String> changeId = GeneratedColumn<String>(
    'change_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _txIdMeta = const VerificationMeta('txId');
  @override
  late final GeneratedColumn<String> txId = GeneratedColumn<String>(
    'tx_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldsMeta = const VerificationMeta('fields');
  @override
  late final GeneratedColumn<String> fields = GeneratedColumn<String>(
    'fields',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING'),
  );
  static const VerificationMeta _rejectCodeMeta = const VerificationMeta('rejectCode');
  @override
  late final GeneratedColumn<String> rejectCode = GeneratedColumn<String>(
    'reject_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    origin,
    seq,
    changeId,
    txId,
    entity,
    entityId,
    op,
    fields,
    hlc,
    userId,
    createdAt,
    status,
    rejectCode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'change_log';
  @override
  VerificationContext validateIntegrity(Insertable<ChangeLogData> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('origin')) {
      context.handle(_originMeta, origin.isAcceptableOrUnknown(data['origin']!, _originMeta));
    } else if (isInserting) {
      context.missing(_originMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(_seqMeta, seq.isAcceptableOrUnknown(data['seq']!, _seqMeta));
    } else if (isInserting) {
      context.missing(_seqMeta);
    }
    if (data.containsKey('change_id')) {
      context.handle(_changeIdMeta, changeId.isAcceptableOrUnknown(data['change_id']!, _changeIdMeta));
    } else if (isInserting) {
      context.missing(_changeIdMeta);
    }
    if (data.containsKey('tx_id')) {
      context.handle(_txIdMeta, txId.isAcceptableOrUnknown(data['tx_id']!, _txIdMeta));
    } else if (isInserting) {
      context.missing(_txIdMeta);
    }
    if (data.containsKey('entity')) {
      context.handle(_entityMeta, entity.isAcceptableOrUnknown(data['entity']!, _entityMeta));
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta, entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('fields')) {
      context.handle(_fieldsMeta, fields.isAcceptableOrUnknown(data['fields']!, _fieldsMeta));
    } else if (isInserting) {
      context.missing(_fieldsMeta);
    }
    if (data.containsKey('hlc')) {
      context.handle(_hlcMeta, hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta));
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta, userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta, status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('reject_code')) {
      context.handle(_rejectCodeMeta, rejectCode.isAcceptableOrUnknown(data['reject_code']!, _rejectCodeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {origin, seq};
  @override
  ChangeLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChangeLogData(
      origin: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}origin'])!,
      seq: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}seq'])!,
      changeId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}change_id'])!,
      txId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}tx_id'])!,
      entity: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}entity'])!,
      entityId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      op: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}op'])!,
      fields: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}fields'])!,
      hlc: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}hlc'])!,
      userId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      status: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      rejectCode: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}reject_code']),
    );
  }

  @override
  $ChangeLogTable createAlias(String alias) {
    return $ChangeLogTable(attachedDatabase, alias);
  }
}

class ChangeLogData extends DataClass implements Insertable<ChangeLogData> {
  final String origin;
  final int seq;
  final String changeId;
  final String txId;
  final String entity;
  final String entityId;
  final String op;
  final String fields;
  final String hlc;
  final String? userId;
  final String createdAt;

  /// PENDING until the server's `accepted` vector covers it, then ACKED; REJECTED when refused.
  final String status;
  final String? rejectCode;
  const ChangeLogData({
    required this.origin,
    required this.seq,
    required this.changeId,
    required this.txId,
    required this.entity,
    required this.entityId,
    required this.op,
    required this.fields,
    required this.hlc,
    this.userId,
    required this.createdAt,
    required this.status,
    this.rejectCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['origin'] = Variable<String>(origin);
    map['seq'] = Variable<int>(seq);
    map['change_id'] = Variable<String>(changeId);
    map['tx_id'] = Variable<String>(txId);
    map['entity'] = Variable<String>(entity);
    map['entity_id'] = Variable<String>(entityId);
    map['op'] = Variable<String>(op);
    map['fields'] = Variable<String>(fields);
    map['hlc'] = Variable<String>(hlc);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || rejectCode != null) {
      map['reject_code'] = Variable<String>(rejectCode);
    }
    return map;
  }

  ChangeLogCompanion toCompanion(bool nullToAbsent) {
    return ChangeLogCompanion(
      origin: Value(origin),
      seq: Value(seq),
      changeId: Value(changeId),
      txId: Value(txId),
      entity: Value(entity),
      entityId: Value(entityId),
      op: Value(op),
      fields: Value(fields),
      hlc: Value(hlc),
      userId: userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      createdAt: Value(createdAt),
      status: Value(status),
      rejectCode: rejectCode == null && nullToAbsent ? const Value.absent() : Value(rejectCode),
    );
  }

  factory ChangeLogData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChangeLogData(
      origin: serializer.fromJson<String>(json['origin']),
      seq: serializer.fromJson<int>(json['seq']),
      changeId: serializer.fromJson<String>(json['changeId']),
      txId: serializer.fromJson<String>(json['txId']),
      entity: serializer.fromJson<String>(json['entity']),
      entityId: serializer.fromJson<String>(json['entityId']),
      op: serializer.fromJson<String>(json['op']),
      fields: serializer.fromJson<String>(json['fields']),
      hlc: serializer.fromJson<String>(json['hlc']),
      userId: serializer.fromJson<String?>(json['userId']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      rejectCode: serializer.fromJson<String?>(json['rejectCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'origin': serializer.toJson<String>(origin),
      'seq': serializer.toJson<int>(seq),
      'changeId': serializer.toJson<String>(changeId),
      'txId': serializer.toJson<String>(txId),
      'entity': serializer.toJson<String>(entity),
      'entityId': serializer.toJson<String>(entityId),
      'op': serializer.toJson<String>(op),
      'fields': serializer.toJson<String>(fields),
      'hlc': serializer.toJson<String>(hlc),
      'userId': serializer.toJson<String?>(userId),
      'createdAt': serializer.toJson<String>(createdAt),
      'status': serializer.toJson<String>(status),
      'rejectCode': serializer.toJson<String?>(rejectCode),
    };
  }

  ChangeLogData copyWith({
    String? origin,
    int? seq,
    String? changeId,
    String? txId,
    String? entity,
    String? entityId,
    String? op,
    String? fields,
    String? hlc,
    Value<String?> userId = const Value.absent(),
    String? createdAt,
    String? status,
    Value<String?> rejectCode = const Value.absent(),
  }) => ChangeLogData(
    origin: origin ?? this.origin,
    seq: seq ?? this.seq,
    changeId: changeId ?? this.changeId,
    txId: txId ?? this.txId,
    entity: entity ?? this.entity,
    entityId: entityId ?? this.entityId,
    op: op ?? this.op,
    fields: fields ?? this.fields,
    hlc: hlc ?? this.hlc,
    userId: userId.present ? userId.value : this.userId,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    rejectCode: rejectCode.present ? rejectCode.value : this.rejectCode,
  );
  ChangeLogData copyWithCompanion(ChangeLogCompanion data) {
    return ChangeLogData(
      origin: data.origin.present ? data.origin.value : this.origin,
      seq: data.seq.present ? data.seq.value : this.seq,
      changeId: data.changeId.present ? data.changeId.value : this.changeId,
      txId: data.txId.present ? data.txId.value : this.txId,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      op: data.op.present ? data.op.value : this.op,
      fields: data.fields.present ? data.fields.value : this.fields,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      rejectCode: data.rejectCode.present ? data.rejectCode.value : this.rejectCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChangeLogData(')
          ..write('origin: $origin, ')
          ..write('seq: $seq, ')
          ..write('changeId: $changeId, ')
          ..write('txId: $txId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('fields: $fields, ')
          ..write('hlc: $hlc, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('rejectCode: $rejectCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    origin,
    seq,
    changeId,
    txId,
    entity,
    entityId,
    op,
    fields,
    hlc,
    userId,
    createdAt,
    status,
    rejectCode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChangeLogData &&
          other.origin == this.origin &&
          other.seq == this.seq &&
          other.changeId == this.changeId &&
          other.txId == this.txId &&
          other.entity == this.entity &&
          other.entityId == this.entityId &&
          other.op == this.op &&
          other.fields == this.fields &&
          other.hlc == this.hlc &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.rejectCode == this.rejectCode);
}

class ChangeLogCompanion extends UpdateCompanion<ChangeLogData> {
  final Value<String> origin;
  final Value<int> seq;
  final Value<String> changeId;
  final Value<String> txId;
  final Value<String> entity;
  final Value<String> entityId;
  final Value<String> op;
  final Value<String> fields;
  final Value<String> hlc;
  final Value<String?> userId;
  final Value<String> createdAt;
  final Value<String> status;
  final Value<String?> rejectCode;
  final Value<int> rowid;
  const ChangeLogCompanion({
    this.origin = const Value.absent(),
    this.seq = const Value.absent(),
    this.changeId = const Value.absent(),
    this.txId = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.op = const Value.absent(),
    this.fields = const Value.absent(),
    this.hlc = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.rejectCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChangeLogCompanion.insert({
    required String origin,
    required int seq,
    required String changeId,
    required String txId,
    required String entity,
    required String entityId,
    required String op,
    required String fields,
    required String hlc,
    this.userId = const Value.absent(),
    required String createdAt,
    this.status = const Value.absent(),
    this.rejectCode = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : origin = Value(origin),
       seq = Value(seq),
       changeId = Value(changeId),
       txId = Value(txId),
       entity = Value(entity),
       entityId = Value(entityId),
       op = Value(op),
       fields = Value(fields),
       hlc = Value(hlc),
       createdAt = Value(createdAt);
  static Insertable<ChangeLogData> custom({
    Expression<String>? origin,
    Expression<int>? seq,
    Expression<String>? changeId,
    Expression<String>? txId,
    Expression<String>? entity,
    Expression<String>? entityId,
    Expression<String>? op,
    Expression<String>? fields,
    Expression<String>? hlc,
    Expression<String>? userId,
    Expression<String>? createdAt,
    Expression<String>? status,
    Expression<String>? rejectCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (origin != null) 'origin': origin,
      if (seq != null) 'seq': seq,
      if (changeId != null) 'change_id': changeId,
      if (txId != null) 'tx_id': txId,
      if (entity != null) 'entity': entity,
      if (entityId != null) 'entity_id': entityId,
      if (op != null) 'op': op,
      if (fields != null) 'fields': fields,
      if (hlc != null) 'hlc': hlc,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (rejectCode != null) 'reject_code': rejectCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChangeLogCompanion copyWith({
    Value<String>? origin,
    Value<int>? seq,
    Value<String>? changeId,
    Value<String>? txId,
    Value<String>? entity,
    Value<String>? entityId,
    Value<String>? op,
    Value<String>? fields,
    Value<String>? hlc,
    Value<String?>? userId,
    Value<String>? createdAt,
    Value<String>? status,
    Value<String?>? rejectCode,
    Value<int>? rowid,
  }) {
    return ChangeLogCompanion(
      origin: origin ?? this.origin,
      seq: seq ?? this.seq,
      changeId: changeId ?? this.changeId,
      txId: txId ?? this.txId,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      op: op ?? this.op,
      fields: fields ?? this.fields,
      hlc: hlc ?? this.hlc,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      rejectCode: rejectCode ?? this.rejectCode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (changeId.present) {
      map['change_id'] = Variable<String>(changeId.value);
    }
    if (txId.present) {
      map['tx_id'] = Variable<String>(txId.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (fields.present) {
      map['fields'] = Variable<String>(fields.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rejectCode.present) {
      map['reject_code'] = Variable<String>(rejectCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChangeLogCompanion(')
          ..write('origin: $origin, ')
          ..write('seq: $seq, ')
          ..write('changeId: $changeId, ')
          ..write('txId: $txId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('fields: $fields, ')
          ..write('hlc: $hlc, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('rejectCode: $rejectCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KeyValuesTable extends KeyValues with TableInfo<$KeyValuesTable, KeyValue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KeyValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'key_values';
  @override
  VerificationContext validateIntegrity(Insertable<KeyValue> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(_keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(_valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  KeyValue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KeyValue(
      key: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $KeyValuesTable createAlias(String alias) {
    return $KeyValuesTable(attachedDatabase, alias);
  }
}

class KeyValue extends DataClass implements Insertable<KeyValue> {
  final String key;
  final String value;
  const KeyValue({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  KeyValuesCompanion toCompanion(bool nullToAbsent) {
    return KeyValuesCompanion(key: Value(key), value: Value(value));
  }

  factory KeyValue.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KeyValue(key: serializer.fromJson<String>(json['key']), value: serializer.fromJson<String>(json['value']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'key': serializer.toJson<String>(key), 'value': serializer.toJson<String>(value)};
  }

  KeyValue copyWith({String? key, String? value}) => KeyValue(key: key ?? this.key, value: value ?? this.value);
  KeyValue copyWithCompanion(KeyValuesCompanion data) {
    return KeyValue(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KeyValue(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is KeyValue && other.key == this.key && other.value == this.value);
}

class KeyValuesCompanion extends UpdateCompanion<KeyValue> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const KeyValuesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KeyValuesCompanion.insert({required String key, required String value, this.rowid = const Value.absent()})
    : key = Value(key),
      value = Value(value);
  static Insertable<KeyValue> custom({Expression<String>? key, Expression<String>? value, Expression<int>? rowid}) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KeyValuesCompanion copyWith({Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return KeyValuesCompanion(key: key ?? this.key, value: value ?? this.value, rowid: rowid ?? this.rowid);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KeyValuesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RecordsTable records = $RecordsTable(this);
  late final $ChangeLogTable changeLog = $ChangeLogTable(this);
  late final $KeyValuesTable keyValues = $KeyValuesTable(this);
  late final Index recordsEntity = Index('records_entity', 'CREATE INDEX records_entity ON records (entity)');
  late final Index changeLogStatus = Index(
    'change_log_status',
    'CREATE INDEX change_log_status ON change_log (status)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [records, changeLog, keyValues, recordsEntity, changeLogStatus];
}

typedef $$RecordsTableCreateCompanionBuilder = RecordsCompanion Function({
  required String entity,
  required String id,
  required String data,
  Value<String> fieldHlc,
  required String hlc,
  required String origin,
  Value<String?> deletedAt,
  Value<int> rowid,
});
typedef $$RecordsTableUpdateCompanionBuilder = RecordsCompanion Function({
  Value<String> entity,
  Value<String> id,
  Value<String> data,
  Value<String> fieldHlc,
  Value<String> hlc,
  Value<String> origin,
  Value<String?> deletedAt,
  Value<int> rowid,
});

class $$RecordsTableFilterComposer extends Composer<_$AppDatabase, $RecordsTable> {
  $$RecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data => $composableBuilder(column: $table.data, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fieldHlc =>
      $composableBuilder(column: $table.fieldHlc, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hlc => $composableBuilder(column: $table.hlc, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$RecordsTableOrderingComposer extends Composer<_$AppDatabase, $RecordsTable> {
  $$RecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fieldHlc =>
      $composableBuilder(column: $table.fieldHlc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$RecordsTableAnnotationComposer extends Composer<_$AppDatabase, $RecordsTable> {
  $$RecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entity => $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get data => $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<String> get fieldHlc => $composableBuilder(column: $table.fieldHlc, builder: (column) => column);

  GeneratedColumn<String> get hlc => $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get origin => $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get deletedAt => $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$RecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecordsTable,
          Record,
          $$RecordsTableFilterComposer,
          $$RecordsTableOrderingComposer,
          $$RecordsTableAnnotationComposer,
          $$RecordsTableCreateCompanionBuilder,
          $$RecordsTableUpdateCompanionBuilder,
          (Record, BaseReferences<_$AppDatabase, $RecordsTable, Record>),
          Record,
          PrefetchHooks Function()
        > {
  $$RecordsTableTableManager(_$AppDatabase db, $RecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$RecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$RecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$RecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entity = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> data = const Value.absent(),
                Value<String> fieldHlc = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> origin = const Value.absent(),
                Value<String?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordsCompanion(
                entity: entity,
                id: id,
                data: data,
                fieldHlc: fieldHlc,
                hlc: hlc,
                origin: origin,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entity,
                required String id,
                required String data,
                Value<String> fieldHlc = const Value.absent(),
                required String hlc,
                required String origin,
                Value<String?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordsCompanion.insert(
                entity: entity,
                id: id,
                data: data,
                fieldHlc: fieldHlc,
                hlc: hlc,
                origin: origin,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecordsTable, Record>(table),
                  BaseReferences<_$AppDatabase, $RecordsTable, Record>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecordsTable,
      Record,
      $$RecordsTableFilterComposer,
      $$RecordsTableOrderingComposer,
      $$RecordsTableAnnotationComposer,
      $$RecordsTableCreateCompanionBuilder,
      $$RecordsTableUpdateCompanionBuilder,
      (Record, BaseReferences<_$AppDatabase, $RecordsTable, Record>),
      Record,
      PrefetchHooks Function()
    >;
typedef $$ChangeLogTableCreateCompanionBuilder = ChangeLogCompanion Function({
  required String origin,
  required int seq,
  required String changeId,
  required String txId,
  required String entity,
  required String entityId,
  required String op,
  required String fields,
  required String hlc,
  Value<String?> userId,
  required String createdAt,
  Value<String> status,
  Value<String?> rejectCode,
  Value<int> rowid,
});
typedef $$ChangeLogTableUpdateCompanionBuilder = ChangeLogCompanion Function({
  Value<String> origin,
  Value<int> seq,
  Value<String> changeId,
  Value<String> txId,
  Value<String> entity,
  Value<String> entityId,
  Value<String> op,
  Value<String> fields,
  Value<String> hlc,
  Value<String?> userId,
  Value<String> createdAt,
  Value<String> status,
  Value<String?> rejectCode,
  Value<int> rowid,
});

class $$ChangeLogTableFilterComposer extends Composer<_$AppDatabase, $ChangeLogTable> {
  $$ChangeLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get seq => $composableBuilder(column: $table.seq, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get changeId =>
      $composableBuilder(column: $table.changeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get txId => $composableBuilder(column: $table.txId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get op => $composableBuilder(column: $table.op, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fields =>
      $composableBuilder(column: $table.fields, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hlc => $composableBuilder(column: $table.hlc, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rejectCode =>
      $composableBuilder(column: $table.rejectCode, builder: (column) => ColumnFilters(column));
}

class $$ChangeLogTableOrderingComposer extends Composer<_$AppDatabase, $ChangeLogTable> {
  $$ChangeLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get seq => $composableBuilder(column: $table.seq, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get changeId =>
      $composableBuilder(column: $table.changeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get txId =>
      $composableBuilder(column: $table.txId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get op => $composableBuilder(column: $table.op, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fields =>
      $composableBuilder(column: $table.fields, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rejectCode =>
      $composableBuilder(column: $table.rejectCode, builder: (column) => ColumnOrderings(column));
}

class $$ChangeLogTableAnnotationComposer extends Composer<_$AppDatabase, $ChangeLogTable> {
  $$ChangeLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get origin => $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<int> get seq => $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<String> get changeId => $composableBuilder(column: $table.changeId, builder: (column) => column);

  GeneratedColumn<String> get txId => $composableBuilder(column: $table.txId, builder: (column) => column);

  GeneratedColumn<String> get entity => $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get entityId => $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get op => $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<String> get fields => $composableBuilder(column: $table.fields, builder: (column) => column);

  GeneratedColumn<String> get hlc => $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get userId => $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status => $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get rejectCode => $composableBuilder(column: $table.rejectCode, builder: (column) => column);
}

class $$ChangeLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChangeLogTable,
          ChangeLogData,
          $$ChangeLogTableFilterComposer,
          $$ChangeLogTableOrderingComposer,
          $$ChangeLogTableAnnotationComposer,
          $$ChangeLogTableCreateCompanionBuilder,
          $$ChangeLogTableUpdateCompanionBuilder,
          (ChangeLogData, BaseReferences<_$AppDatabase, $ChangeLogTable, ChangeLogData>),
          ChangeLogData,
          PrefetchHooks Function()
        > {
  $$ChangeLogTableTableManager(_$AppDatabase db, $ChangeLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ChangeLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ChangeLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$ChangeLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> origin = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<String> changeId = const Value.absent(),
                Value<String> txId = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<String> fields = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> rejectCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChangeLogCompanion(
                origin: origin,
                seq: seq,
                changeId: changeId,
                txId: txId,
                entity: entity,
                entityId: entityId,
                op: op,
                fields: fields,
                hlc: hlc,
                userId: userId,
                createdAt: createdAt,
                status: status,
                rejectCode: rejectCode,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String origin,
                required int seq,
                required String changeId,
                required String txId,
                required String entity,
                required String entityId,
                required String op,
                required String fields,
                required String hlc,
                Value<String?> userId = const Value.absent(),
                required String createdAt,
                Value<String> status = const Value.absent(),
                Value<String?> rejectCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChangeLogCompanion.insert(
                origin: origin,
                seq: seq,
                changeId: changeId,
                txId: txId,
                entity: entity,
                entityId: entityId,
                op: op,
                fields: fields,
                hlc: hlc,
                userId: userId,
                createdAt: createdAt,
                status: status,
                rejectCode: rejectCode,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChangeLogTable, ChangeLogData>(table),
                  BaseReferences<_$AppDatabase, $ChangeLogTable, ChangeLogData>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChangeLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChangeLogTable,
      ChangeLogData,
      $$ChangeLogTableFilterComposer,
      $$ChangeLogTableOrderingComposer,
      $$ChangeLogTableAnnotationComposer,
      $$ChangeLogTableCreateCompanionBuilder,
      $$ChangeLogTableUpdateCompanionBuilder,
      (ChangeLogData, BaseReferences<_$AppDatabase, $ChangeLogTable, ChangeLogData>),
      ChangeLogData,
      PrefetchHooks Function()
    >;
typedef $$KeyValuesTableCreateCompanionBuilder = KeyValuesCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$KeyValuesTableUpdateCompanionBuilder = KeyValuesCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$KeyValuesTableFilterComposer extends Composer<_$AppDatabase, $KeyValuesTable> {
  $$KeyValuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$KeyValuesTableOrderingComposer extends Composer<_$AppDatabase, $KeyValuesTable> {
  $$KeyValuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$KeyValuesTableAnnotationComposer extends Composer<_$AppDatabase, $KeyValuesTable> {
  $$KeyValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key => $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value => $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$KeyValuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KeyValuesTable,
          KeyValue,
          $$KeyValuesTableFilterComposer,
          $$KeyValuesTableOrderingComposer,
          $$KeyValuesTableAnnotationComposer,
          $$KeyValuesTableCreateCompanionBuilder,
          $$KeyValuesTableUpdateCompanionBuilder,
          (KeyValue, BaseReferences<_$AppDatabase, $KeyValuesTable, KeyValue>),
          KeyValue,
          PrefetchHooks Function()
        > {
  $$KeyValuesTableTableManager(_$AppDatabase db, $KeyValuesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$KeyValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$KeyValuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$KeyValuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => KeyValuesCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => KeyValuesCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$KeyValuesTable, KeyValue>(table),
                  BaseReferences<_$AppDatabase, $KeyValuesTable, KeyValue>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KeyValuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KeyValuesTable,
      KeyValue,
      $$KeyValuesTableFilterComposer,
      $$KeyValuesTableOrderingComposer,
      $$KeyValuesTableAnnotationComposer,
      $$KeyValuesTableCreateCompanionBuilder,
      $$KeyValuesTableUpdateCompanionBuilder,
      (KeyValue, BaseReferences<_$AppDatabase, $KeyValuesTable, KeyValue>),
      KeyValue,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RecordsTableTableManager get records => $$RecordsTableTableManager(_db, _db.records);
  $$ChangeLogTableTableManager get changeLog => $$ChangeLogTableTableManager(_db, _db.changeLog);
  $$KeyValuesTableTableManager get keyValues => $$KeyValuesTableTableManager(_db, _db.keyValues);
}
