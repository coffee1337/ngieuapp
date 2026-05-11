import 'package:ngieuapp/app/features/schedule/domain/utils/classroom_utils.dart';

/// Утилиты для определения этажей с учетом специфики институтов НГИЭУ
class FloorUtils {
  /// Определяет этаж по номеру кабинета с учетом института
  ///
  /// Правила разных институтов:
  /// 1. Институт экономики и управления (первая цифра = 1):
  ///    - вторая цифра 1 => 1 этаж
  ///    - вторая цифра 2 => 2 этаж
  ///    - вторая цифра 3 => 3 этаж
  ///    - и т.д.
  ///    Примеры: 121 → 2 этаж, 136 → 3 этаж
  ///
  /// 2. Институт информационных технологий и систем связи (первая цифра = 2):
  ///    - вторая цифра 0 => 1 этаж
  ///    - вторая цифра 1 => 2 этаж
  ///    - вторая цифра 2 => 3 этаж
  ///    - вторая цифра 3 => 4 этаж
  ///    Формула: этаж = вторая цифра + 1
  ///    Примеры: 206 → 1 этаж, 220 → 3 этаж, 231 → 4 этаж
  ///
  /// 3. Инженерный институт (первая цифра = 3):
  ///    - вторая цифра 0 => 1 этаж
  ///    - вторая цифра 1 => 2 этаж
  ///    - вторая цифра 2 => 3 этаж
  ///    - вторая цифра 3 => 4 этаж
  ///    Формула: этаж = вторая цифра + 1
  ///    Примеры: 307 → 1 этаж, 312 → 2 этаж, 321 → 3 этаж
  ///
  /// 4. Для некорректных аудиторий ("спортзал", "121А", "А-121", пустая строка):
  ///    - возвращает null
  ///    - UI должен аккуратно обрабатывать null
  static int? getFloorFromRoomNumber(String roomNumber) {
    // Нестандартные аудитории — не вычисляем этаж
    if (!ClassroomUtils.isStandardRoomNumber(roomNumber)) return null;

    final digits = ClassroomUtils.extractAllDigits(roomNumber);
    if (digits.length < 3) return null;

    final firstDigit = int.tryParse(digits[0]);
    final secondDigit = int.tryParse(digits[1]);

    if (firstDigit == null || secondDigit == null) return null;

    final floor = switch (firstDigit) {
      1 => secondDigit, // Вторая цифра напрямую
      2 || 3 => secondDigit + 1, // Этаж = вторая цифра + 1
      _ => null,
    };

    // Этаж ≤ 0 не показываем
    if (floor != null && floor <= 0) return null;
    return floor;
  }

  /// Определяет институт по номеру кабинета
  ///
  /// Возвращает название института или null если не удалось определить
  static String? getInstituteFromRoomNumber(String roomNumber) {
    // Нестандартные аудитории — не определяем институт
    if (!ClassroomUtils.isStandardRoomNumber(roomNumber)) return null;

    final digits = ClassroomUtils.extractAllDigits(roomNumber);
    if (digits.isEmpty) return null;

    final firstDigit = int.tryParse(digits[0]);
    return switch (firstDigit) {
      1 => 'Институт экономики и управления',
      2 => 'Институт информационных технологий и систем связи',
      3 => 'Инженерный институт',
      _ => null,
    };
  }

  /// Форматирует отображение этажа с правильными окончаниями
  ///
  /// Примеры: "1-й этаж", "2-й этаж", "3-й этаж"
  static String formatFloor(int floor) {
    final lastDigit = floor % 10;
    final lastTwoDigits = floor % 100;

    // Исключения для 11-19
    if (lastTwoDigits >= 11 && lastTwoDigits <= 19) {
      return '$floor-й этаж';
    }

    return switch (lastDigit) {
      1 => '$floor-й этаж',
      2 || 3 || 4 => '$floor-й этаж',
      _ => '$floor-й этаж',
    };
  }

  /// Получает полную информацию о расположении кабинета
  static RoomLocationInfo getRoomLocationInfo(String roomNumber) {
    final institute = getInstituteFromRoomNumber(roomNumber);
    final floor = getFloorFromRoomNumber(roomNumber);

    // Извлекаем номер кабинета (последние 1-2 цифры)
    final digits = ClassroomUtils.extractAllDigits(roomNumber);
    var roomNum = '';
    if (digits.length >= 3) {
      // Последняя цифра или две
      roomNum = digits.sublist(2).join();
    }

    return RoomLocationInfo(
      institute: institute,
      floor: floor,
      roomNumber: roomNum.isNotEmpty ? roomNum : roomNumber,
      originalNumber: roomNumber,
    );
  }

  /// Форматирует информацию о кабинете для отображения
  ///
  /// Примеры:
  /// - "220А • 2 этаж • Институт информационных технологий и систем связи"
  /// - "121А • 2 этаж • Институт экономики и управления"
  static String formatRoomInfo(String roomNumber) {
    final info = getRoomLocationInfo(roomNumber);
    final parts = <String>[];

    // Номер аудитории (с сохранением оригинального формата)
    parts.add(info.originalNumber);

    // Этаж если определен
    if (info.floor != null) {
      parts.add(formatFloor(info.floor!));
    }

    // Институт если определен
    if (info.institute != null) {
      parts.add(info.institute!);
    }

    return parts.join(' • ');
  }

  /// Упрощенное форматирование для компактного отображения
  ///
  /// Примеры:
  /// - "220А • 2 этаж"
  /// - "121А • Институт экономики и управления"
  static String formatRoomInfoCompact(String roomNumber) {
    final info = getRoomLocationInfo(roomNumber);
    final parts = <String>[];

    // Номер аудитории
    parts.add(info.originalNumber);

    // Этаж если определен (приоритетнее института для компактности)
    if (info.floor != null) {
      parts.add(formatFloor(info.floor!));
    } else if (info.institute != null) {
      // Если этаж не определен, показываем институт
      parts.add(info.institute!);
    }

    return parts.join(' • ');
  }

  /// Форматирует информацию о кабинете для карточек занятий
  ///
  /// Пример: "Ауд. 220А • 2 этаж"
  static String formatRoomForLesson(String roomNumber) {
    final info = getRoomLocationInfo(roomNumber);

    if (info.floor != null) {
      return 'Ауд. ${info.originalNumber} • ${formatFloor(info.floor!)}';
    }

    return 'Ауд. ${info.originalNumber}';
  }
}

/// Информация о расположении кабинета
class RoomLocationInfo {
  RoomLocationInfo({
    required this.institute,
    required this.floor,
    required this.roomNumber,
    required this.originalNumber,
  });

  final String? institute;
  final int? floor;
  final String roomNumber;
  final String originalNumber;

  @override
  String toString() {
    final parts = <String>[];

    if (institute != null) parts.add(institute!);
    if (floor != null) parts.add(FloorUtils.formatFloor(floor!));
    parts.add('Аудитория $originalNumber');

    return parts.join(' · ');
  }
}
