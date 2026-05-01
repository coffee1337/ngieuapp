import 'dart:convert';

import '../../../core/utils/date_ext.dart';
import '../domain/lesson.dart';

class LessonMapper {
  static List<Lesson> fromApi(Map<String, dynamic> j) {
    final dayName = (j['dayName'] ?? '').toString();
    final dayIndex = _dayIndex(dayName);
    if (dayIndex < 0) return const [];

    final classTime = (j['classTime'] ?? '').toString();
    final times = _parseClassTime(classTime);
    if (times == null) return const [];

    final pairNum = _parsePairNumber(j['classNumberName']);
    final subject =
        (j['subjects'] is List && (j['subjects'] as List).isNotEmpty)
        ? (j['subjects'] as List).first.toString()
        : '';
    final note = (j['notes'] is List && (j['notes'] as List).isNotEmpty)
        ? (j['notes'] as List).first.toString()
        : '';
    final office = (j['offices'] is List && (j['offices'] as List).isNotEmpty)
        ? (j['offices'] as List).first.toString()
        : '';

    final groups = _asStringList(j['groups']);
    final instructors = _asStringList(j['instructors']);

    final isChange = j['isChange'] == true;
    final isEvent = subject.toLowerCase().contains('мероприятие');

    final type = isEvent ? LessonType.event : _parseType(note);

    final explicitDate = j['date'] != null
        ? DateTime.tryParse(j['date'].toString())
        : null;
    final isUpperWeek = j['isUpperWeek'] as bool?;

    final List<DateTime> dates;
    if (isChange && explicitDate != null) {
      dates = [
        DateTime(explicitDate.year, explicitDate.month, explicitDate.day),
      ];
    } else {
      dates = _expandDates(dayIndex, isUpperWeek);
    }

    final parity = _parityFromApi(isUpperWeek);

    final result = <Lesson>[];
    for (final date in dates) {
      final startDt = DateTime(
        date.year,
        date.month,
        date.day,
        times.$1.hour,
        times.$1.minute,
      );
      final endDt = DateTime(
        date.year,
        date.month,
        date.day,
        times.$2.hour,
        times.$2.minute,
      );

      final id = _stableId(date, pairNum, office, groups, subject, isChange);

      result.add(
        Lesson(
          id: id,
          date: DateTime(date.year, date.month, date.day),
          pairNumber: pairNum,
          startTime: startDt,
          endTime: endDt,
          subject: subject,
          type: type,
          classroom: office,
          building: '',
          teacherIds: const [],
          teacherNames: instructors,
          groupIds: const [],
          groupNames: groups,
          parity: parity,
          isChange: isChange,
          isEvent: isEvent,
          note: note.isEmpty ? null : note,
        ),
      );
    }
    return result;
  }

  // ---- Helpers ----

  static const _daysMap = {
    'понедельник': 1,
    'вторник': 2,
    'среда': 3,
    'четверг': 4,
    'пятница': 5,
    'суббота': 6,
    'воскресенье': 7,
  };

  static int _dayIndex(String s) => _daysMap[s.trim().toLowerCase()] ?? -1;

  static (({int hour, int minute}), ({int hour, int minute}))? _parseClassTime(
    String raw,
  ) {
    final parts = raw.split('/').map((s) => s.trim()).toList();
    if (parts.length != 2) return null;
    final start = _parseHm(parts[0]);
    final end = _parseHm(parts[1]);
    if (start == null || end == null) return null;
    return (start, end);
  }

  static ({int hour, int minute})? _parseHm(String s) {
    final clean = s.replaceAll(' ', '');
    final m = RegExp(r'^(\d{1,2})[-:](\d{1,2})$').firstMatch(clean);
    if (m == null) return null;
    final h = int.tryParse(m.group(1)!);
    final mm = int.tryParse(m.group(2)!);
    if (h == null || mm == null) return null;
    if (h < 0 || h > 23 || mm < 0 || mm > 59) return null;
    return (hour: h, minute: mm);
  }

  static int _parsePairNumber(dynamic v) {
    if (v == null) return 0;
    final m = RegExp(r'(\d+)').firstMatch(v.toString());
    if (m == null) return 0;
    return int.tryParse(m.group(1)!) ?? 0;
  }

  static LessonType _parseType(String note) {
    final n = note.toLowerCase();
    if (n.contains('лек')) return LessonType.lecture;
    if (n.contains('прак')) return LessonType.practice;
    if (n.contains('лаб')) return LessonType.lab;
    if (n.contains('экз')) return LessonType.exam;
    if (n.contains('конс')) return LessonType.consultation;
    return LessonType.unknown;
  }

  static WeekParity _parityFromApi(bool? isUpperWeek) {
    if (isUpperWeek == null) return WeekParity.any;
    return isUpperWeek ? WeekParity.even : WeekParity.odd;
  }

  static List<String> _asStringList(dynamic v) {
    if (v == null) return const [];
    if (v is List) {
      return v
          .map((e) => e.toString().trim())
          .where((s) => s.isNotEmpty)
          .toSet()
          .toList();
    }
    final s = v.toString().trim();
    return s.isEmpty ? const [] : [s];
  }

  static List<DateTime> _expandDates(int weekday, bool? isUpperWeek) {
    final now = DateTime.now();
    final thisWeekMonday = now.startOfWeek;
    final ranges = [
      thisWeekMonday.subtract(const Duration(days: 14)),
      thisWeekMonday.subtract(const Duration(days: 7)),
      thisWeekMonday,
      thisWeekMonday.add(const Duration(days: 7)),
      thisWeekMonday.add(const Duration(days: 14)),
    ];

    final result = <DateTime>[];
    for (final monday in ranges) {
      final date = monday.add(Duration(days: weekday - 1));
      if (isUpperWeek == null) {
        result.add(date);
      } else {
        // Вместо использования date.isEvenWeek, просто добавляем дату
        // Фильтрация по четности недели будет выполнена позже через weekTypeProvider
        result.add(date);
      }
    }
    return result;
  }

  static String _stableId(
    DateTime d,
    int pair,
    String room,
    List<String> groups,
    String subject,
    bool isChange,
  ) {
    final key =
        '${d.year}-${d.month}-${d.day}|$pair|$room|${groups.join(",")}|$subject|${isChange ? 'change' : 'plan'}';
    return base64Url.encode(utf8.encode(key));
  }
}
