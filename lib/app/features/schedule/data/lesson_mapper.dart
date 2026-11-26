import 'package:intl/intl.dart';
import 'package:ngieuapp/app/core/utils/date_ext.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';

class LessonMapper {
  static List<Lesson> fromApi(Map<String, dynamic> j, {DateTime? anchorDate}) {
    final dayName = _str(j, const ['dayName', 'DayName', 'day', 'weekDay']);
    final dayIndex = _dayIndex(dayName);
    if (dayIndex < 0) return const [];

    final classTime = _str(j, const [
      'classTime',
      'ClassTime',
      'time',
      'Time',
      'pairTime',
    ]);
    final times = _parseClassTime(classTime);
    if (times == null) return const [];

    final pairNum = _parsePairNumber(
      j['classNumberName'] ?? j['classNumber'] ?? j['pairNumber'],
    );
    // Номер пары может отсутствовать в ответе API. Не теряем такую запись:
    // UI сможет показать её как занятие с неизвестным номером.

    final subject = _firstString(j['subjects'] ?? j['subject']);
    final note = _firstString(j['notes'] ?? j['note']);
    final office = _firstString(j['offices'] ?? j['office'] ?? j['classroom']);
    final building = _firstString(
      j['building'] ?? j['buildings'] ?? j['corpus'],
    );

    final groups = _asStringList(j['groups'] ?? j['group']);
    final instructors = _asStringList(
      j['instructors'] ?? j['teachers'] ?? j['teacher'],
    );

    final isChange = _parseBool(j['isChange']) ?? false;
    final isEvent = subject.toLowerCase().contains('мероприят');

    final type = isEvent ? LessonType.event : _parseType(note, subject);

    final explicitDate = _parseApiDateValue(
      j['date'] ?? j['Date'] ?? j['lessonDate'] ?? j['LessonDate'],
    );
    final isUpperWeek = _parseIsUpperWeek(j['isUpperWeek']);

    final List<DateTime> dates;
    if (isChange) {
      // В некоторых ответах API замена приходит без явной даты. Привязываем
      // такую запись к неделе запроса, но не создаём пять фантомных замен.
      dates = explicitDate == null
          ? [_dateForWeekday(dayIndex, anchorDate ?? DateTime.now())]
          : [DateTime(explicitDate.year, explicitDate.month, explicitDate.day)];
    } else if (explicitDate != null) {
      dates = [
        DateTime(explicitDate.year, explicitDate.month, explicitDate.day),
      ];
    } else {
      dates = _expandDates(dayIndex, anchorDate ?? DateTime.now());
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

      final id = _stableId(
        date,
        pairNum,
        office,
        building,
        groups,
        instructors,
        subject,
        note,
        startDt,
        endDt,
        isUpperWeek,
        isChange,
      );

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
          building: building,
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

  static String _str(Map<String, dynamic> j, List<String> keys) {
    for (final k in keys) {
      final v = j[k];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return '';
  }

  static String _firstString(dynamic v) {
    if (v == null) return '';
    if (v is List) {
      for (final e in v) {
        final s = e?.toString().trim() ?? '';
        if (s.isNotEmpty) return s;
      }
      return '';
    }
    return v.toString().trim();
  }

  static DateTime? _parseApiDate(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return null;
    final iso = DateTime.tryParse(s);
    if (iso != null) return iso;
    for (final pattern in ['dd.MM.yyyy', 'dd.MM.yyyy HH:mm', 'dd-MM-yyyy']) {
      try {
        return DateFormat(pattern).parseStrict(s);
      } on FormatException {
        continue;
      }
    }
    return null;
  }

  static DateTime? _parseApiDateValue(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return _parseApiDate(value.toString());
  }

  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) {
      if (value == 1) return true;
      if (value == 0) return false;
      return null;
    }
    return switch (value.toString().trim().toLowerCase()) {
      'true' || '1' || 'yes' || 'да' => true,
      'false' || '0' || 'no' || 'нет' => false,
      _ => null,
    };
  }

  static bool? _parseIsUpperWeek(dynamic v) {
    if (v == null) return null;
    if (v is bool) return v;
    if (v is num) {
      if (v == 1) return true;
      if (v == 0) return false;
      return null;
    }
    final s = v.toString().trim().toLowerCase();
    if (s == 'true' ||
        s == '1' ||
        s == 'верхняя' ||
        s == 'upper' ||
        s == 'even') {
      return true;
    }
    if (s == 'false' ||
        s == '0' ||
        s == 'нижняя' ||
        s == 'lower' ||
        s == 'odd') {
      return false;
    }
    return null;
  }

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
    final normalized = raw.trim();
    if (normalized.isEmpty) return null;
    if (normalized.contains('/')) {
      final parts = normalized.split('/').map((s) => s.trim()).toList();
      if (parts.length != 2) return null;
      final start = _parseHm(parts[0]);
      final end = _parseHm(parts[1]);
      if (start == null || end == null) return null;
      return (start, end);
    }
    // Fallback: "8:30-10:00", "8.30–10.00"
    final m = RegExp(
      r'(\d{1,2}[:\-.\s]\d{1,2})\s*[–—-]\s*(\d{1,2}[:\-.\s]\d{1,2})',
    ).firstMatch(normalized);
    if (m == null) return null;
    final start = _parseHm(m.group(1)!);
    final end = _parseHm(m.group(2)!);
    if (start == null || end == null) return null;
    return (start, end);
  }

  static ({int hour, int minute})? _parseHm(String s) {
    final clean = s.replaceAll(' ', '');
    final m = RegExp(r'^(\d{1,2})[-:.](\d{1,2})$').firstMatch(clean);
    if (m == null) return null;
    final h = int.tryParse(m.group(1)!);
    final mm = int.tryParse(m.group(2)!);
    if (h == null || mm == null) return null;
    if (h < 0 || h > 23 || mm < 0 || mm > 59) return null;
    return (hour: h, minute: mm);
  }

  static int _parsePairNumber(dynamic v) {
    if (v == null) return 0;
    if (v is num) {
      final i = v.toInt();
      return i > 0 ? i : 0;
    }
    final m = RegExp(r'(\d+)').firstMatch(v.toString());
    if (m == null) return 0;
    final parsed = int.tryParse(m.group(1)!) ?? 0;
    return parsed > 0 ? parsed : 0;
  }

  static LessonType _parseType(String note, String subject) {
    // 'лек' давал ложные срабатывания на 'комплекс' — ищем 'лекц'.
    // Тип ищем и в примечании, и в названии (экзамен с пустым note).
    final n = '${note.toLowerCase()} ${subject.toLowerCase()}';
    if (n.contains('экз')) return LessonType.exam;
    if (n.contains('конс') || n.contains('зач')) {
      // 'зач' покрывает зачёты, но не трогает обычные пары.
      if (n.contains('конс')) return LessonType.consultation;
    }
    if (n.contains('лаб')) return LessonType.lab;
    if (n.contains('практ') || n.contains('семин')) return LessonType.practice;
    if (n.contains('лекц')) return LessonType.lecture;
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

  static List<DateTime> _expandDates(int weekday, DateTime anchorDate) {
    final thisWeekMonday = anchorDate.startOfWeek;
    final baseOffset = weekday - 1;
    return List.generate(5, (i) {
      final monday = thisWeekMonday.add(Duration(days: (i - 2) * 7));
      return DateTime(monday.year, monday.month, monday.day + baseOffset);
    });
  }

  static DateTime _dateForWeekday(int weekday, DateTime anchorDate) {
    final monday = anchorDate.startOfWeek;
    return DateTime(monday.year, monday.month, monday.day + weekday - 1);
  }

  static String _stableId(
    DateTime d,
    int pair,
    String room,
    String building,
    List<String> groups,
    List<String> teachers,
    String subject,
    String note,
    DateTime start,
    DateTime end,
    bool? isUpperWeek,
    bool isChange,
  ) {
    final weekKind = switch (isUpperWeek) {
      true => 'upper',
      false => 'lower',
      null => 'any',
    };
    final key =
        '${d.year}-${d.month}-${d.day}|$pair|$room|$building|'
        '${groups.join(",")}|${teachers.join(",")}|$subject|$note|'
        '${start.hour}:${start.minute}-${end.hour}:${end.minute}|'
        '$weekKind|${isChange ? 'c' : 'p'}';
    // FNV-1a 32-bit hash — short, stable, no import needed
    var hash = 0x811c9dc5;
    for (var i = 0; i < key.length; i++) {
      hash ^= key.codeUnitAt(i);
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash.toRadixString(36);
  }
}
