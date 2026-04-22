import 'dart:convert';
import '../domain/lesson.dart';

class LessonMapper {
  /// Толерантный маппер. Возвращает null если записи невалидны.
  static Lesson? fromApi(Map<String, dynamic> j) {
    try {
      final date = _parseDate(j['date'] ?? j['lessonDate'] ?? j['Date']);
      final start = _parseTime(date, j['startTime'] ?? j['timeStart'] ?? j['TimeStart']);
      final end = _parseTime(date, j['endTime'] ?? j['timeEnd'] ?? j['TimeEnd']);
      if (date == null || start == null || end == null) return null;

      final classroom = (j['classroom'] ?? j['room'] ?? j['Room'] ?? '').toString().trim();
      final subject = (j['subject'] ?? j['discipline'] ?? j['Subject'] ?? '').toString().trim();
      final pairNumber = (j['pairNumber'] ?? j['pair'] ?? j['lessonNumber'] ?? 0) as int;

      final teacherNames = _asStringList(j['teachers'] ?? j['teacherNames'] ?? j['lecturer']);
      final teacherIds = _asStringList(j['teacherIds']);
      final groupNames = _asStringList(j['groups'] ?? j['groupNames']);
      final groupIds = _asStringList(j['groupIds']);

      final id = _stableId(date, pairNumber, classroom, groupNames, subject);

      return Lesson(
        id: id,
        date: DateTime(date.year, date.month, date.day),
        pairNumber: pairNumber,
        startTime: start,
        endTime: end,
        subject: subject,
        type: _parseType(j['type'] ?? j['lessonType']),
        classroom: classroom,
        building: (j['building'] ?? j['korpus'] ?? '').toString().trim(),
        teacherIds: teacherIds,
        teacherNames: teacherNames,
        groupIds: groupIds,
        groupNames: groupNames,
        subgroup: j['subgroup']?.toString(),
        note: j['note']?.toString(),
      );
    } catch (_) {
      return null;
    }
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    final s = v.toString();
    return DateTime.tryParse(s);
  }

  static DateTime? _parseTime(DateTime? date, dynamic v) {
    if (date == null || v == null) return null;
    final s = v.toString();
    // Форматы: "09:00", "09:00:00", "2025-04-22T09:00:00"
    if (s.contains('T')) return DateTime.tryParse(s);
    final parts = s.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return DateTime(date.year, date.month, date.day, h, m);
  }

  static List<String> _asStringList(dynamic v) {
    if (v == null) return const [];
    if (v is List) return v.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
    final s = v.toString().trim();
    if (s.isEmpty) return const [];
    if (s.contains(',')) return s.split(',').map((e) => e.trim()).toList();
    return [s];
  }

  static LessonType _parseType(dynamic v) {
    final s = v?.toString().toLowerCase() ?? '';
    if (s.contains('лек')) return LessonType.lecture;
    if (s.contains('прак')) return LessonType.practice;
    if (s.contains('лаб')) return LessonType.lab;
    if (s.contains('экз')) return LessonType.exam;
    if (s.contains('конс')) return LessonType.consultation;
    return LessonType.unknown;
  }

  static String _stableId(DateTime d, int pair, String room,
      List<String> groups, String subject) {
    final key = '${d.toIso8601String()}|$pair|$room|${groups.join(",")}|$subject';
    return base64Url.encode(utf8.encode(key));
  }
}