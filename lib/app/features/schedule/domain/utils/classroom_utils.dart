/// Утилиты для работы с номерами кабинетов
class ClassroomUtils {
  /// Определяет институт по номеру кабинета
  ///
  /// Правила:
  /// 1 — Институт экономики и управления
  /// 2 — Институт информационных технологий и систем связи
  /// 3 — Инженерный институт
  /// Другие цифры/форматы — возвращает исходное значение building
  static String getInstituteFromRoomNumber(String roomNumber, String building) {
    final firstDigit = _extractFirstDigit(roomNumber);

    if (firstDigit == null) {
      return building;
    }

    return switch (firstDigit) {
      '1' => 'Институт экономики и управления',
      '2' => 'Институт информационных технологий и систем связи',
      '3' => 'Инженерный институт',
      _ => building,
    };
  }

  /// Определяет этаж по номеру кабинета с учетом института
  ///
  /// Для института 1: вторая цифра = этаж (112→1, 121→2, 136→3)
  /// Для институтов 2,3: вторая цифра + 1 = этаж (206→1, 310→2, 321→3)
  /// Нестандартные аудитории ("8 корпус", "спортзал") → null
  static int? getFloorFromRoomNumber(String roomNumber) {
    if (!isStandardRoomNumber(roomNumber)) return null;

    final digits = extractAllDigits(roomNumber);
    if (digits.length < 3) return null;

    final firstDigit = int.tryParse(digits[0]);
    final secondDigit = int.tryParse(digits[1]);

    if (firstDigit == null || secondDigit == null) return null;

    final floor = switch (firstDigit) {
      1 => secondDigit,
      2 || 3 => secondDigit + 1,
      _ => null,
    };

    // Этаж ≤ 0 не показываем
    if (floor != null && floor <= 0) return null;
    return floor;
  }

  /// Извлекает первую цифру из строки
  static String? _extractFirstDigit(String input) {
    final digits = extractAllDigits(input);
    return digits.isNotEmpty ? digits[0] : null;
  }

  /// Извлекает все цифры из строки
  static List<String> extractAllDigits(String input) {
    return RegExp(
      r'\d',
    ).allMatches(input).map((match) => match.group(0)!).toList();
  }

  /// Форматирует отображение кабинета с этажом
  /// Пример: "121 (2 этаж)"
  static String formatRoomWithFloor(String roomNumber) {
    final floor = getFloorFromRoomNumber(roomNumber);
    if (floor == null) {
      return roomNumber;
    }
    return '$roomNumber ($floor ${_getFloorWord(floor)})';
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

  /// Проверяет, является ли строка валидным номером кабинета
  static bool isValidRoomNumber(String roomNumber) {
    if (roomNumber.isEmpty) return false;
    return RegExp(r'\d').hasMatch(roomNumber);
  }

  /// Проверяет, является ли аудитория стандартным 3-значным номером
  /// (возможно с буквенным суффиксом, например "121А", "303Б").
  ///
  /// Стандартный номер: начинается с цифры 1-3, за которой идут ещё
  /// минимум 2 цифры. Допускается буквенный суффикс.
  ///
  /// Примеры стандартных: "121", "206", "303Б", "121А"
  /// Примеры нестандартных: "8 корпус", "спортзал", "актовый зал", "", "42"
  static bool isStandardRoomNumber(String roomNumber) {
    if (roomNumber.isEmpty) return false;
    return RegExp(r'^[1-3]\d{2}').hasMatch(roomNumber.trim());
  }

  /// Получает полную информацию о кабинете
  static ClassroomInfo getClassroomInfo(String roomNumber, String building) {
    return ClassroomInfo(
      roomNumber: roomNumber,
      building: building,
      institute: getInstituteFromRoomNumber(roomNumber, building),
      floor: getFloorFromRoomNumber(roomNumber),
    );
  }
}

/// Полная информация о кабинете
class ClassroomInfo {
  ClassroomInfo({
    required this.roomNumber,
    required this.building,
    required this.institute,
    required this.floor,
  });

  final String roomNumber;
  final String building;
  final String institute;
  final int? floor;

  @override
  String toString() {
    final floorStr = floor != null
        ? ' ($floor ${ClassroomUtils._getFloorWord(floor!)})'
        : '';
    return '$roomNumber$floorStr ($institute)';
  }
}
