import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/storage/app_database.dart';
import '../../../core/storage/tables/lessons_table.dart';
import '../domain/lesson.dart';

class ScheduleDbDataSource {
  ScheduleDbDataSource(this._db);
  final AppDatabase _db;

  Future<List<Lesson>> getLessonsInRange(
    String actorId,
    DateTime from,
    DateTime to,
  ) async {
    final query = _db.select(_db.lessons)
      ..where((t) =>
          t.actorId.equals(actorId) &
          t.date.isBetweenValues(from, to));
    final rows = await query.get();
    return rows.map(_toLesson).toList();
  }

  Future<List<Lesson>> getAllLessonsForDate(DateTime date) async {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final query = _db.select(_db.lessons)
      ..where((t) => t.date.isBetweenValues(dayStart, dayEnd));
    final rows = await query.get();
    return rows.map(_toLesson).toList();
  }

  Future<void> replaceForActor(String actorId, List<Lesson> lessons) async {
    await _db.transaction(() async {
      // Удаляем старые записи этого актора
      await (_db.delete(_db.lessons)
            ..where((t) => t.actorId.equals(actorId)))
          .go();

      // Вставляем новые пачкой
      final now = DateTime.now();
      await _db.batch((batch) {
        batch.insertAll(
          _db.lessons,
          lessons.map((l) => _toCompanion(actorId, l, now)).toList(),
          mode: InsertMode.insertOrReplace,
        );
      });
    });
  }

  /// Устарел ли кэш по данному актору (нет записей или последняя вставка давно).
  Future<bool> isStale(String actorId, Duration ttl) async {
    final query = _db.select(_db.lessons)
      ..where((t) => t.actorId.equals(actorId))
      ..orderBy([(t) => OrderingTerm.desc(t.cachedAt)])
      ..limit(1);
    final row = await query.getSingleOrNull();
    if (row == null) return true;
    return DateTime.now().difference(row.cachedAt) > ttl;
  }

  // ---- Маппинг Drift ↔ Domain ----

  Lesson _toLesson(Lesson_ row) {
    return Lesson(
      id: row.id,
      date: row.date,
      pairNumber: row.pairNumber,
      startTime: row.startTime,
      endTime: row.endTime,
      subject: row.subject,
      type: LessonType.values.firstWhere(
        (e) => e.name == row.type,
        orElse: () => LessonType.unknown,
      ),
      classroom: row.classroom,
      building: row.building,
      teacherIds: _decodeList(row.teacherIds),
      teacherNames: _decodeList(row.teacherNames),
      groupIds: _decodeList(row.groupIds),
      groupNames: _decodeList(row.groupNames),
      subgroup: row.subgroup,
      note: row.note,
    );
  }

  LessonsCompanion _toCompanion(String actorId, Lesson l, DateTime cachedAt) {
    return LessonsCompanion.insert(
      id: l.id,
      actorId: actorId,
      date: l.date,
      startTime: l.startTime,
      endTime: l.endTime,
      pairNumber: l.pairNumber,
      subject: l.subject,
      type: l.type.name,
      classroom: l.classroom,
      building: Value(l.building),
      teacherIds: _encodeList(l.teacherIds),
      teacherNames: _encodeList(l.teacherNames),
      groupIds: _encodeList(l.groupIds),
      groupNames: _encodeList(l.groupNames),
      subgroup: Value(l.subgroup),
      note: Value(l.note),
      cachedAt: cachedAt,
    );
  }

  String _encodeList(List<String> list) => jsonEncode(list);

  List<String> _decodeList(String raw) {
    if (raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {
      // Если там была CSV-строка — поддержим и это
      return raw.split(',').map((e) => e.trim()).where((s) => s.isNotEmpty).toList();
    }
    return const [];
  }
}