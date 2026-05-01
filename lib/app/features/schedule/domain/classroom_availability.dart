import 'package:freezed_annotation/freezed_annotation.dart';

part 'classroom_availability.freezed.dart';

@freezed
abstract class ClassroomAvailability with _$ClassroomAvailability {
  const factory ClassroomAvailability({
    required String classroom,
    required String building,
    required DateTime freeFrom,
    required DateTime freeUntil,
    required Duration freeDuration,
    required String institute,
    required int? floor,
  }) = _ClassroomAvailability;

  const ClassroomAvailability._();

  /// Форматированный номер кабинета с этажом
  String get formattedRoom {
    if (floor == null) return classroom;
    return '$classroom ($floor ${_getFloorWord(floor!)})';
  }

  /// Возвращает правильную форму слова "этаж"
  static String _getFloorWord(int floor) {
    if (floor == 0) return 'цокольный этаж';

    final lastDigit = floor % 10;
    final lastTwoDigits = floor % 100;

    if (lastTwoDigits >= 11 && lastTwoDigits <= 19) {
      return 'этаж';
    }

    return switch (lastDigit) {
      1 => 'этаж',
      2 || 3 || 4 => 'этажа',
      _ => 'этаж',
    };
  }
}
