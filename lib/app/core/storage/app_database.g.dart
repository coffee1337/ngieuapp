// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ScheduleEntriesTable extends ScheduleEntries
    with TableInfo<$ScheduleEntriesTable, ScheduleEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduleEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actorIdMeta = const VerificationMeta(
    'actorId',
  );
  @override
  late final GeneratedColumn<String> actorId = GeneratedColumn<String>(
    'actor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pairNumberMeta = const VerificationMeta(
    'pairNumber',
  );
  @override
  late final GeneratedColumn<int> pairNumber = GeneratedColumn<int>(
    'pair_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _classroomMeta = const VerificationMeta(
    'classroom',
  );
  @override
  late final GeneratedColumn<String> classroom = GeneratedColumn<String>(
    'classroom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _buildingMeta = const VerificationMeta(
    'building',
  );
  @override
  late final GeneratedColumn<String> building = GeneratedColumn<String>(
    'building',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _teacherIdsMeta = const VerificationMeta(
    'teacherIds',
  );
  @override
  late final GeneratedColumn<String> teacherIds = GeneratedColumn<String>(
    'teacher_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teacherNamesMeta = const VerificationMeta(
    'teacherNames',
  );
  @override
  late final GeneratedColumn<String> teacherNames = GeneratedColumn<String>(
    'teacher_names',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdsMeta = const VerificationMeta(
    'groupIds',
  );
  @override
  late final GeneratedColumn<String> groupIds = GeneratedColumn<String>(
    'group_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupNamesMeta = const VerificationMeta(
    'groupNames',
  );
  @override
  late final GeneratedColumn<String> groupNames = GeneratedColumn<String>(
    'group_names',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isChangeMeta = const VerificationMeta(
    'isChange',
  );
  @override
  late final GeneratedColumn<bool> isChange = GeneratedColumn<bool>(
    'is_change',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_change" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isEventMeta = const VerificationMeta(
    'isEvent',
  );
  @override
  late final GeneratedColumn<bool> isEvent = GeneratedColumn<bool>(
    'is_event',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_event" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _parityMeta = const VerificationMeta('parity');
  @override
  late final GeneratedColumn<String> parity = GeneratedColumn<String>(
    'parity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('any'),
  );
  static const VerificationMeta _subgroupMeta = const VerificationMeta(
    'subgroup',
  );
  @override
  late final GeneratedColumn<String> subgroup = GeneratedColumn<String>(
    'subgroup',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    actorId,
    date,
    startTime,
    endTime,
    pairNumber,
    subject,
    type,
    classroom,
    building,
    teacherIds,
    teacherNames,
    groupIds,
    groupNames,
    isChange,
    isEvent,
    parity,
    subgroup,
    note,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedule_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduleEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('actor_id')) {
      context.handle(
        _actorIdMeta,
        actorId.isAcceptableOrUnknown(data['actor_id']!, _actorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_actorIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('pair_number')) {
      context.handle(
        _pairNumberMeta,
        pairNumber.isAcceptableOrUnknown(data['pair_number']!, _pairNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_pairNumberMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('classroom')) {
      context.handle(
        _classroomMeta,
        classroom.isAcceptableOrUnknown(data['classroom']!, _classroomMeta),
      );
    } else if (isInserting) {
      context.missing(_classroomMeta);
    }
    if (data.containsKey('building')) {
      context.handle(
        _buildingMeta,
        building.isAcceptableOrUnknown(data['building']!, _buildingMeta),
      );
    }
    if (data.containsKey('teacher_ids')) {
      context.handle(
        _teacherIdsMeta,
        teacherIds.isAcceptableOrUnknown(data['teacher_ids']!, _teacherIdsMeta),
      );
    } else if (isInserting) {
      context.missing(_teacherIdsMeta);
    }
    if (data.containsKey('teacher_names')) {
      context.handle(
        _teacherNamesMeta,
        teacherNames.isAcceptableOrUnknown(
          data['teacher_names']!,
          _teacherNamesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_teacherNamesMeta);
    }
    if (data.containsKey('group_ids')) {
      context.handle(
        _groupIdsMeta,
        groupIds.isAcceptableOrUnknown(data['group_ids']!, _groupIdsMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdsMeta);
    }
    if (data.containsKey('group_names')) {
      context.handle(
        _groupNamesMeta,
        groupNames.isAcceptableOrUnknown(data['group_names']!, _groupNamesMeta),
      );
    } else if (isInserting) {
      context.missing(_groupNamesMeta);
    }
    if (data.containsKey('is_change')) {
      context.handle(
        _isChangeMeta,
        isChange.isAcceptableOrUnknown(data['is_change']!, _isChangeMeta),
      );
    }
    if (data.containsKey('is_event')) {
      context.handle(
        _isEventMeta,
        isEvent.isAcceptableOrUnknown(data['is_event']!, _isEventMeta),
      );
    }
    if (data.containsKey('parity')) {
      context.handle(
        _parityMeta,
        parity.isAcceptableOrUnknown(data['parity']!, _parityMeta),
      );
    }
    if (data.containsKey('subgroup')) {
      context.handle(
        _subgroupMeta,
        subgroup.isAcceptableOrUnknown(data['subgroup']!, _subgroupMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      actorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      )!,
      pairNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pair_number'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      classroom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classroom'],
      )!,
      building: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}building'],
      )!,
      teacherIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}teacher_ids'],
      )!,
      teacherNames: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}teacher_names'],
      )!,
      groupIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_ids'],
      )!,
      groupNames: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_names'],
      )!,
      isChange: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_change'],
      )!,
      isEvent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_event'],
      )!,
      parity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parity'],
      )!,
      subgroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subgroup'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $ScheduleEntriesTable createAlias(String alias) {
    return $ScheduleEntriesTable(attachedDatabase, alias);
  }
}

class ScheduleEntry extends DataClass implements Insertable<ScheduleEntry> {
  final String id;
  final String actorId;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final int pairNumber;
  final String subject;
  final String type;
  final String classroom;
  final String building;
  final String teacherIds;
  final String teacherNames;
  final String groupIds;
  final String groupNames;
  final bool isChange;
  final bool isEvent;
  final String parity;
  final String? subgroup;
  final String? note;
  final DateTime cachedAt;
  const ScheduleEntry({
    required this.id,
    required this.actorId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.pairNumber,
    required this.subject,
    required this.type,
    required this.classroom,
    required this.building,
    required this.teacherIds,
    required this.teacherNames,
    required this.groupIds,
    required this.groupNames,
    required this.isChange,
    required this.isEvent,
    required this.parity,
    this.subgroup,
    this.note,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['actor_id'] = Variable<String>(actorId);
    map['date'] = Variable<DateTime>(date);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['pair_number'] = Variable<int>(pairNumber);
    map['subject'] = Variable<String>(subject);
    map['type'] = Variable<String>(type);
    map['classroom'] = Variable<String>(classroom);
    map['building'] = Variable<String>(building);
    map['teacher_ids'] = Variable<String>(teacherIds);
    map['teacher_names'] = Variable<String>(teacherNames);
    map['group_ids'] = Variable<String>(groupIds);
    map['group_names'] = Variable<String>(groupNames);
    map['is_change'] = Variable<bool>(isChange);
    map['is_event'] = Variable<bool>(isEvent);
    map['parity'] = Variable<String>(parity);
    if (!nullToAbsent || subgroup != null) {
      map['subgroup'] = Variable<String>(subgroup);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  ScheduleEntriesCompanion toCompanion(bool nullToAbsent) {
    return ScheduleEntriesCompanion(
      id: Value(id),
      actorId: Value(actorId),
      date: Value(date),
      startTime: Value(startTime),
      endTime: Value(endTime),
      pairNumber: Value(pairNumber),
      subject: Value(subject),
      type: Value(type),
      classroom: Value(classroom),
      building: Value(building),
      teacherIds: Value(teacherIds),
      teacherNames: Value(teacherNames),
      groupIds: Value(groupIds),
      groupNames: Value(groupNames),
      isChange: Value(isChange),
      isEvent: Value(isEvent),
      parity: Value(parity),
      subgroup: subgroup == null && nullToAbsent
          ? const Value.absent()
          : Value(subgroup),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      cachedAt: Value(cachedAt),
    );
  }

  factory ScheduleEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleEntry(
      id: serializer.fromJson<String>(json['id']),
      actorId: serializer.fromJson<String>(json['actorId']),
      date: serializer.fromJson<DateTime>(json['date']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      pairNumber: serializer.fromJson<int>(json['pairNumber']),
      subject: serializer.fromJson<String>(json['subject']),
      type: serializer.fromJson<String>(json['type']),
      classroom: serializer.fromJson<String>(json['classroom']),
      building: serializer.fromJson<String>(json['building']),
      teacherIds: serializer.fromJson<String>(json['teacherIds']),
      teacherNames: serializer.fromJson<String>(json['teacherNames']),
      groupIds: serializer.fromJson<String>(json['groupIds']),
      groupNames: serializer.fromJson<String>(json['groupNames']),
      isChange: serializer.fromJson<bool>(json['isChange']),
      isEvent: serializer.fromJson<bool>(json['isEvent']),
      parity: serializer.fromJson<String>(json['parity']),
      subgroup: serializer.fromJson<String?>(json['subgroup']),
      note: serializer.fromJson<String?>(json['note']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'actorId': serializer.toJson<String>(actorId),
      'date': serializer.toJson<DateTime>(date),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'pairNumber': serializer.toJson<int>(pairNumber),
      'subject': serializer.toJson<String>(subject),
      'type': serializer.toJson<String>(type),
      'classroom': serializer.toJson<String>(classroom),
      'building': serializer.toJson<String>(building),
      'teacherIds': serializer.toJson<String>(teacherIds),
      'teacherNames': serializer.toJson<String>(teacherNames),
      'groupIds': serializer.toJson<String>(groupIds),
      'groupNames': serializer.toJson<String>(groupNames),
      'isChange': serializer.toJson<bool>(isChange),
      'isEvent': serializer.toJson<bool>(isEvent),
      'parity': serializer.toJson<String>(parity),
      'subgroup': serializer.toJson<String?>(subgroup),
      'note': serializer.toJson<String?>(note),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  ScheduleEntry copyWith({
    String? id,
    String? actorId,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    int? pairNumber,
    String? subject,
    String? type,
    String? classroom,
    String? building,
    String? teacherIds,
    String? teacherNames,
    String? groupIds,
    String? groupNames,
    bool? isChange,
    bool? isEvent,
    String? parity,
    Value<String?> subgroup = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? cachedAt,
  }) => ScheduleEntry(
    id: id ?? this.id,
    actorId: actorId ?? this.actorId,
    date: date ?? this.date,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    pairNumber: pairNumber ?? this.pairNumber,
    subject: subject ?? this.subject,
    type: type ?? this.type,
    classroom: classroom ?? this.classroom,
    building: building ?? this.building,
    teacherIds: teacherIds ?? this.teacherIds,
    teacherNames: teacherNames ?? this.teacherNames,
    groupIds: groupIds ?? this.groupIds,
    groupNames: groupNames ?? this.groupNames,
    isChange: isChange ?? this.isChange,
    isEvent: isEvent ?? this.isEvent,
    parity: parity ?? this.parity,
    subgroup: subgroup.present ? subgroup.value : this.subgroup,
    note: note.present ? note.value : this.note,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  ScheduleEntry copyWithCompanion(ScheduleEntriesCompanion data) {
    return ScheduleEntry(
      id: data.id.present ? data.id.value : this.id,
      actorId: data.actorId.present ? data.actorId.value : this.actorId,
      date: data.date.present ? data.date.value : this.date,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      pairNumber: data.pairNumber.present
          ? data.pairNumber.value
          : this.pairNumber,
      subject: data.subject.present ? data.subject.value : this.subject,
      type: data.type.present ? data.type.value : this.type,
      classroom: data.classroom.present ? data.classroom.value : this.classroom,
      building: data.building.present ? data.building.value : this.building,
      teacherIds: data.teacherIds.present
          ? data.teacherIds.value
          : this.teacherIds,
      teacherNames: data.teacherNames.present
          ? data.teacherNames.value
          : this.teacherNames,
      groupIds: data.groupIds.present ? data.groupIds.value : this.groupIds,
      groupNames: data.groupNames.present
          ? data.groupNames.value
          : this.groupNames,
      isChange: data.isChange.present ? data.isChange.value : this.isChange,
      isEvent: data.isEvent.present ? data.isEvent.value : this.isEvent,
      parity: data.parity.present ? data.parity.value : this.parity,
      subgroup: data.subgroup.present ? data.subgroup.value : this.subgroup,
      note: data.note.present ? data.note.value : this.note,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleEntry(')
          ..write('id: $id, ')
          ..write('actorId: $actorId, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('pairNumber: $pairNumber, ')
          ..write('subject: $subject, ')
          ..write('type: $type, ')
          ..write('classroom: $classroom, ')
          ..write('building: $building, ')
          ..write('teacherIds: $teacherIds, ')
          ..write('teacherNames: $teacherNames, ')
          ..write('groupIds: $groupIds, ')
          ..write('groupNames: $groupNames, ')
          ..write('isChange: $isChange, ')
          ..write('isEvent: $isEvent, ')
          ..write('parity: $parity, ')
          ..write('subgroup: $subgroup, ')
          ..write('note: $note, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    actorId,
    date,
    startTime,
    endTime,
    pairNumber,
    subject,
    type,
    classroom,
    building,
    teacherIds,
    teacherNames,
    groupIds,
    groupNames,
    isChange,
    isEvent,
    parity,
    subgroup,
    note,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleEntry &&
          other.id == this.id &&
          other.actorId == this.actorId &&
          other.date == this.date &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.pairNumber == this.pairNumber &&
          other.subject == this.subject &&
          other.type == this.type &&
          other.classroom == this.classroom &&
          other.building == this.building &&
          other.teacherIds == this.teacherIds &&
          other.teacherNames == this.teacherNames &&
          other.groupIds == this.groupIds &&
          other.groupNames == this.groupNames &&
          other.isChange == this.isChange &&
          other.isEvent == this.isEvent &&
          other.parity == this.parity &&
          other.subgroup == this.subgroup &&
          other.note == this.note &&
          other.cachedAt == this.cachedAt);
}

class ScheduleEntriesCompanion extends UpdateCompanion<ScheduleEntry> {
  final Value<String> id;
  final Value<String> actorId;
  final Value<DateTime> date;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<int> pairNumber;
  final Value<String> subject;
  final Value<String> type;
  final Value<String> classroom;
  final Value<String> building;
  final Value<String> teacherIds;
  final Value<String> teacherNames;
  final Value<String> groupIds;
  final Value<String> groupNames;
  final Value<bool> isChange;
  final Value<bool> isEvent;
  final Value<String> parity;
  final Value<String?> subgroup;
  final Value<String?> note;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const ScheduleEntriesCompanion({
    this.id = const Value.absent(),
    this.actorId = const Value.absent(),
    this.date = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.pairNumber = const Value.absent(),
    this.subject = const Value.absent(),
    this.type = const Value.absent(),
    this.classroom = const Value.absent(),
    this.building = const Value.absent(),
    this.teacherIds = const Value.absent(),
    this.teacherNames = const Value.absent(),
    this.groupIds = const Value.absent(),
    this.groupNames = const Value.absent(),
    this.isChange = const Value.absent(),
    this.isEvent = const Value.absent(),
    this.parity = const Value.absent(),
    this.subgroup = const Value.absent(),
    this.note = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduleEntriesCompanion.insert({
    required String id,
    required String actorId,
    required DateTime date,
    required DateTime startTime,
    required DateTime endTime,
    required int pairNumber,
    required String subject,
    required String type,
    required String classroom,
    this.building = const Value.absent(),
    required String teacherIds,
    required String teacherNames,
    required String groupIds,
    required String groupNames,
    this.isChange = const Value.absent(),
    this.isEvent = const Value.absent(),
    this.parity = const Value.absent(),
    this.subgroup = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       actorId = Value(actorId),
       date = Value(date),
       startTime = Value(startTime),
       endTime = Value(endTime),
       pairNumber = Value(pairNumber),
       subject = Value(subject),
       type = Value(type),
       classroom = Value(classroom),
       teacherIds = Value(teacherIds),
       teacherNames = Value(teacherNames),
       groupIds = Value(groupIds),
       groupNames = Value(groupNames),
       cachedAt = Value(cachedAt);
  static Insertable<ScheduleEntry> custom({
    Expression<String>? id,
    Expression<String>? actorId,
    Expression<DateTime>? date,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? pairNumber,
    Expression<String>? subject,
    Expression<String>? type,
    Expression<String>? classroom,
    Expression<String>? building,
    Expression<String>? teacherIds,
    Expression<String>? teacherNames,
    Expression<String>? groupIds,
    Expression<String>? groupNames,
    Expression<bool>? isChange,
    Expression<bool>? isEvent,
    Expression<String>? parity,
    Expression<String>? subgroup,
    Expression<String>? note,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actorId != null) 'actor_id': actorId,
      if (date != null) 'date': date,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (pairNumber != null) 'pair_number': pairNumber,
      if (subject != null) 'subject': subject,
      if (type != null) 'type': type,
      if (classroom != null) 'classroom': classroom,
      if (building != null) 'building': building,
      if (teacherIds != null) 'teacher_ids': teacherIds,
      if (teacherNames != null) 'teacher_names': teacherNames,
      if (groupIds != null) 'group_ids': groupIds,
      if (groupNames != null) 'group_names': groupNames,
      if (isChange != null) 'is_change': isChange,
      if (isEvent != null) 'is_event': isEvent,
      if (parity != null) 'parity': parity,
      if (subgroup != null) 'subgroup': subgroup,
      if (note != null) 'note': note,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScheduleEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? actorId,
    Value<DateTime>? date,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<int>? pairNumber,
    Value<String>? subject,
    Value<String>? type,
    Value<String>? classroom,
    Value<String>? building,
    Value<String>? teacherIds,
    Value<String>? teacherNames,
    Value<String>? groupIds,
    Value<String>? groupNames,
    Value<bool>? isChange,
    Value<bool>? isEvent,
    Value<String>? parity,
    Value<String?>? subgroup,
    Value<String?>? note,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return ScheduleEntriesCompanion(
      id: id ?? this.id,
      actorId: actorId ?? this.actorId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      pairNumber: pairNumber ?? this.pairNumber,
      subject: subject ?? this.subject,
      type: type ?? this.type,
      classroom: classroom ?? this.classroom,
      building: building ?? this.building,
      teacherIds: teacherIds ?? this.teacherIds,
      teacherNames: teacherNames ?? this.teacherNames,
      groupIds: groupIds ?? this.groupIds,
      groupNames: groupNames ?? this.groupNames,
      isChange: isChange ?? this.isChange,
      isEvent: isEvent ?? this.isEvent,
      parity: parity ?? this.parity,
      subgroup: subgroup ?? this.subgroup,
      note: note ?? this.note,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (actorId.present) {
      map['actor_id'] = Variable<String>(actorId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (pairNumber.present) {
      map['pair_number'] = Variable<int>(pairNumber.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (classroom.present) {
      map['classroom'] = Variable<String>(classroom.value);
    }
    if (building.present) {
      map['building'] = Variable<String>(building.value);
    }
    if (teacherIds.present) {
      map['teacher_ids'] = Variable<String>(teacherIds.value);
    }
    if (teacherNames.present) {
      map['teacher_names'] = Variable<String>(teacherNames.value);
    }
    if (groupIds.present) {
      map['group_ids'] = Variable<String>(groupIds.value);
    }
    if (groupNames.present) {
      map['group_names'] = Variable<String>(groupNames.value);
    }
    if (isChange.present) {
      map['is_change'] = Variable<bool>(isChange.value);
    }
    if (isEvent.present) {
      map['is_event'] = Variable<bool>(isEvent.value);
    }
    if (parity.present) {
      map['parity'] = Variable<String>(parity.value);
    }
    if (subgroup.present) {
      map['subgroup'] = Variable<String>(subgroup.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleEntriesCompanion(')
          ..write('id: $id, ')
          ..write('actorId: $actorId, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('pairNumber: $pairNumber, ')
          ..write('subject: $subject, ')
          ..write('type: $type, ')
          ..write('classroom: $classroom, ')
          ..write('building: $building, ')
          ..write('teacherIds: $teacherIds, ')
          ..write('teacherNames: $teacherNames, ')
          ..write('groupIds: $groupIds, ')
          ..write('groupNames: $groupNames, ')
          ..write('isChange: $isChange, ')
          ..write('isEvent: $isEvent, ')
          ..write('parity: $parity, ')
          ..write('subgroup: $subgroup, ')
          ..write('note: $note, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClassroomsTable extends Classrooms
    with TableInfo<$ClassroomsTable, Classroom> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassroomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _buildingMeta = const VerificationMeta(
    'building',
  );
  @override
  late final GeneratedColumn<String> building = GeneratedColumn<String>(
    'building',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _capacityMeta = const VerificationMeta(
    'capacity',
  );
  @override
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
    'capacity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [code, building, capacity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'classrooms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Classroom> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('building')) {
      context.handle(
        _buildingMeta,
        building.isAcceptableOrUnknown(data['building']!, _buildingMeta),
      );
    }
    if (data.containsKey('capacity')) {
      context.handle(
        _capacityMeta,
        capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code, building};
  @override
  Classroom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Classroom(
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      building: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}building'],
      )!,
      capacity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}capacity'],
      ),
    );
  }

  @override
  $ClassroomsTable createAlias(String alias) {
    return $ClassroomsTable(attachedDatabase, alias);
  }
}

class Classroom extends DataClass implements Insertable<Classroom> {
  final String code;
  final String building;
  final int? capacity;
  const Classroom({required this.code, required this.building, this.capacity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['building'] = Variable<String>(building);
    if (!nullToAbsent || capacity != null) {
      map['capacity'] = Variable<int>(capacity);
    }
    return map;
  }

  ClassroomsCompanion toCompanion(bool nullToAbsent) {
    return ClassroomsCompanion(
      code: Value(code),
      building: Value(building),
      capacity: capacity == null && nullToAbsent
          ? const Value.absent()
          : Value(capacity),
    );
  }

  factory Classroom.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Classroom(
      code: serializer.fromJson<String>(json['code']),
      building: serializer.fromJson<String>(json['building']),
      capacity: serializer.fromJson<int?>(json['capacity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'building': serializer.toJson<String>(building),
      'capacity': serializer.toJson<int?>(capacity),
    };
  }

  Classroom copyWith({
    String? code,
    String? building,
    Value<int?> capacity = const Value.absent(),
  }) => Classroom(
    code: code ?? this.code,
    building: building ?? this.building,
    capacity: capacity.present ? capacity.value : this.capacity,
  );
  Classroom copyWithCompanion(ClassroomsCompanion data) {
    return Classroom(
      code: data.code.present ? data.code.value : this.code,
      building: data.building.present ? data.building.value : this.building,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Classroom(')
          ..write('code: $code, ')
          ..write('building: $building, ')
          ..write('capacity: $capacity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, building, capacity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Classroom &&
          other.code == this.code &&
          other.building == this.building &&
          other.capacity == this.capacity);
}

class ClassroomsCompanion extends UpdateCompanion<Classroom> {
  final Value<String> code;
  final Value<String> building;
  final Value<int?> capacity;
  final Value<int> rowid;
  const ClassroomsCompanion({
    this.code = const Value.absent(),
    this.building = const Value.absent(),
    this.capacity = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClassroomsCompanion.insert({
    required String code,
    this.building = const Value.absent(),
    this.capacity = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : code = Value(code);
  static Insertable<Classroom> custom({
    Expression<String>? code,
    Expression<String>? building,
    Expression<int>? capacity,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (building != null) 'building': building,
      if (capacity != null) 'capacity': capacity,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClassroomsCompanion copyWith({
    Value<String>? code,
    Value<String>? building,
    Value<int?>? capacity,
    Value<int>? rowid,
  }) {
    return ClassroomsCompanion(
      code: code ?? this.code,
      building: building ?? this.building,
      capacity: capacity ?? this.capacity,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (building.present) {
      map['building'] = Variable<String>(building.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassroomsCompanion(')
          ..write('code: $code, ')
          ..write('building: $building, ')
          ..write('capacity: $capacity, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ScheduleEntriesTable scheduleEntries = $ScheduleEntriesTable(
    this,
  );
  late final $ClassroomsTable classrooms = $ClassroomsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    scheduleEntries,
    classrooms,
  ];
}

typedef $$ScheduleEntriesTableCreateCompanionBuilder =
    ScheduleEntriesCompanion Function({
      required String id,
      required String actorId,
      required DateTime date,
      required DateTime startTime,
      required DateTime endTime,
      required int pairNumber,
      required String subject,
      required String type,
      required String classroom,
      Value<String> building,
      required String teacherIds,
      required String teacherNames,
      required String groupIds,
      required String groupNames,
      Value<bool> isChange,
      Value<bool> isEvent,
      Value<String> parity,
      Value<String?> subgroup,
      Value<String?> note,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$ScheduleEntriesTableUpdateCompanionBuilder =
    ScheduleEntriesCompanion Function({
      Value<String> id,
      Value<String> actorId,
      Value<DateTime> date,
      Value<DateTime> startTime,
      Value<DateTime> endTime,
      Value<int> pairNumber,
      Value<String> subject,
      Value<String> type,
      Value<String> classroom,
      Value<String> building,
      Value<String> teacherIds,
      Value<String> teacherNames,
      Value<String> groupIds,
      Value<String> groupNames,
      Value<bool> isChange,
      Value<bool> isEvent,
      Value<String> parity,
      Value<String?> subgroup,
      Value<String?> note,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$ScheduleEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduleEntriesTable> {
  $$ScheduleEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actorId => $composableBuilder(
    column: $table.actorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pairNumber => $composableBuilder(
    column: $table.pairNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classroom => $composableBuilder(
    column: $table.classroom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get building => $composableBuilder(
    column: $table.building,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teacherIds => $composableBuilder(
    column: $table.teacherIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teacherNames => $composableBuilder(
    column: $table.teacherNames,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupIds => $composableBuilder(
    column: $table.groupIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupNames => $composableBuilder(
    column: $table.groupNames,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isChange => $composableBuilder(
    column: $table.isChange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEvent => $composableBuilder(
    column: $table.isEvent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parity => $composableBuilder(
    column: $table.parity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subgroup => $composableBuilder(
    column: $table.subgroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScheduleEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduleEntriesTable> {
  $$ScheduleEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actorId => $composableBuilder(
    column: $table.actorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pairNumber => $composableBuilder(
    column: $table.pairNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classroom => $composableBuilder(
    column: $table.classroom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get building => $composableBuilder(
    column: $table.building,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teacherIds => $composableBuilder(
    column: $table.teacherIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teacherNames => $composableBuilder(
    column: $table.teacherNames,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupIds => $composableBuilder(
    column: $table.groupIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupNames => $composableBuilder(
    column: $table.groupNames,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isChange => $composableBuilder(
    column: $table.isChange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEvent => $composableBuilder(
    column: $table.isEvent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parity => $composableBuilder(
    column: $table.parity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subgroup => $composableBuilder(
    column: $table.subgroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScheduleEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduleEntriesTable> {
  $$ScheduleEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get actorId =>
      $composableBuilder(column: $table.actorId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get pairNumber => $composableBuilder(
    column: $table.pairNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get classroom =>
      $composableBuilder(column: $table.classroom, builder: (column) => column);

  GeneratedColumn<String> get building =>
      $composableBuilder(column: $table.building, builder: (column) => column);

  GeneratedColumn<String> get teacherIds => $composableBuilder(
    column: $table.teacherIds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get teacherNames => $composableBuilder(
    column: $table.teacherNames,
    builder: (column) => column,
  );

  GeneratedColumn<String> get groupIds =>
      $composableBuilder(column: $table.groupIds, builder: (column) => column);

  GeneratedColumn<String> get groupNames => $composableBuilder(
    column: $table.groupNames,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isChange =>
      $composableBuilder(column: $table.isChange, builder: (column) => column);

  GeneratedColumn<bool> get isEvent =>
      $composableBuilder(column: $table.isEvent, builder: (column) => column);

  GeneratedColumn<String> get parity =>
      $composableBuilder(column: $table.parity, builder: (column) => column);

  GeneratedColumn<String> get subgroup =>
      $composableBuilder(column: $table.subgroup, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$ScheduleEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScheduleEntriesTable,
          ScheduleEntry,
          $$ScheduleEntriesTableFilterComposer,
          $$ScheduleEntriesTableOrderingComposer,
          $$ScheduleEntriesTableAnnotationComposer,
          $$ScheduleEntriesTableCreateCompanionBuilder,
          $$ScheduleEntriesTableUpdateCompanionBuilder,
          (
            ScheduleEntry,
            BaseReferences<_$AppDatabase, $ScheduleEntriesTable, ScheduleEntry>,
          ),
          ScheduleEntry,
          PrefetchHooks Function()
        > {
  $$ScheduleEntriesTableTableManager(
    _$AppDatabase db,
    $ScheduleEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduleEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduleEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduleEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> actorId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> endTime = const Value.absent(),
                Value<int> pairNumber = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> classroom = const Value.absent(),
                Value<String> building = const Value.absent(),
                Value<String> teacherIds = const Value.absent(),
                Value<String> teacherNames = const Value.absent(),
                Value<String> groupIds = const Value.absent(),
                Value<String> groupNames = const Value.absent(),
                Value<bool> isChange = const Value.absent(),
                Value<bool> isEvent = const Value.absent(),
                Value<String> parity = const Value.absent(),
                Value<String?> subgroup = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduleEntriesCompanion(
                id: id,
                actorId: actorId,
                date: date,
                startTime: startTime,
                endTime: endTime,
                pairNumber: pairNumber,
                subject: subject,
                type: type,
                classroom: classroom,
                building: building,
                teacherIds: teacherIds,
                teacherNames: teacherNames,
                groupIds: groupIds,
                groupNames: groupNames,
                isChange: isChange,
                isEvent: isEvent,
                parity: parity,
                subgroup: subgroup,
                note: note,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String actorId,
                required DateTime date,
                required DateTime startTime,
                required DateTime endTime,
                required int pairNumber,
                required String subject,
                required String type,
                required String classroom,
                Value<String> building = const Value.absent(),
                required String teacherIds,
                required String teacherNames,
                required String groupIds,
                required String groupNames,
                Value<bool> isChange = const Value.absent(),
                Value<bool> isEvent = const Value.absent(),
                Value<String> parity = const Value.absent(),
                Value<String?> subgroup = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => ScheduleEntriesCompanion.insert(
                id: id,
                actorId: actorId,
                date: date,
                startTime: startTime,
                endTime: endTime,
                pairNumber: pairNumber,
                subject: subject,
                type: type,
                classroom: classroom,
                building: building,
                teacherIds: teacherIds,
                teacherNames: teacherNames,
                groupIds: groupIds,
                groupNames: groupNames,
                isChange: isChange,
                isEvent: isEvent,
                parity: parity,
                subgroup: subgroup,
                note: note,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScheduleEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScheduleEntriesTable,
      ScheduleEntry,
      $$ScheduleEntriesTableFilterComposer,
      $$ScheduleEntriesTableOrderingComposer,
      $$ScheduleEntriesTableAnnotationComposer,
      $$ScheduleEntriesTableCreateCompanionBuilder,
      $$ScheduleEntriesTableUpdateCompanionBuilder,
      (
        ScheduleEntry,
        BaseReferences<_$AppDatabase, $ScheduleEntriesTable, ScheduleEntry>,
      ),
      ScheduleEntry,
      PrefetchHooks Function()
    >;
typedef $$ClassroomsTableCreateCompanionBuilder =
    ClassroomsCompanion Function({
      required String code,
      Value<String> building,
      Value<int?> capacity,
      Value<int> rowid,
    });
typedef $$ClassroomsTableUpdateCompanionBuilder =
    ClassroomsCompanion Function({
      Value<String> code,
      Value<String> building,
      Value<int?> capacity,
      Value<int> rowid,
    });

class $$ClassroomsTableFilterComposer
    extends Composer<_$AppDatabase, $ClassroomsTable> {
  $$ClassroomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get building => $composableBuilder(
    column: $table.building,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClassroomsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClassroomsTable> {
  $$ClassroomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get building => $composableBuilder(
    column: $table.building,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClassroomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClassroomsTable> {
  $$ClassroomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get building =>
      $composableBuilder(column: $table.building, builder: (column) => column);

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);
}

class $$ClassroomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClassroomsTable,
          Classroom,
          $$ClassroomsTableFilterComposer,
          $$ClassroomsTableOrderingComposer,
          $$ClassroomsTableAnnotationComposer,
          $$ClassroomsTableCreateCompanionBuilder,
          $$ClassroomsTableUpdateCompanionBuilder,
          (
            Classroom,
            BaseReferences<_$AppDatabase, $ClassroomsTable, Classroom>,
          ),
          Classroom,
          PrefetchHooks Function()
        > {
  $$ClassroomsTableTableManager(_$AppDatabase db, $ClassroomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClassroomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClassroomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClassroomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> code = const Value.absent(),
                Value<String> building = const Value.absent(),
                Value<int?> capacity = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClassroomsCompanion(
                code: code,
                building: building,
                capacity: capacity,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String code,
                Value<String> building = const Value.absent(),
                Value<int?> capacity = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClassroomsCompanion.insert(
                code: code,
                building: building,
                capacity: capacity,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClassroomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClassroomsTable,
      Classroom,
      $$ClassroomsTableFilterComposer,
      $$ClassroomsTableOrderingComposer,
      $$ClassroomsTableAnnotationComposer,
      $$ClassroomsTableCreateCompanionBuilder,
      $$ClassroomsTableUpdateCompanionBuilder,
      (Classroom, BaseReferences<_$AppDatabase, $ClassroomsTable, Classroom>),
      Classroom,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ScheduleEntriesTableTableManager get scheduleEntries =>
      $$ScheduleEntriesTableTableManager(_db, _db.scheduleEntries);
  $$ClassroomsTableTableManager get classrooms =>
      $$ClassroomsTableTableManager(_db, _db.classrooms);
}
