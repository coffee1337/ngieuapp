import './classroom_utils.dart';

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
  ///    - вторая цифра 1 => 1 этаж
  ///    - вторая цифра 2 => 2 этаж
  ///    - вторая цифра 3 => 3 этаж
  ///    - и т.д.
  ///    Примеры: 221 → 2 этаж, 236 → 3 этаж
  ///
  /// 3. Институт заочного и открытого образования (первая цифра = 3):
  ///    - вторая цифра 1 => 1 этаж
  ///    - вторая цифра 2 => 2 этаж
  ///    - вторая цифра 3 => 3 этаж
  ///    - и т.д.
  ///    Примеры: 321 → 2 этаж, 336 → 3 этаж
  ///
  /// 4. Институт транспорта (первая цифра = 4):
  ///    - вторая цифра 1 => 1
  ///    - вторая цифра 2 => 2
  ///    - вторая цифра 3 => 3
  ///    - и т.д.
  ///    Примеры: 421 → 2 этаж, 436 → 3 этаж
  ///
  /// 5. Институт гуманитарного образования (первая цифра = 5):
  ///    - вторая цифра 1 => 1 этаж
  ///    - вторая цифра 2 => 2 этаж
  ///    - вторая цифра 3 => 3 этаж
  ///    - и т.д.
  ///    Примеры: 521 → 2 этаж, 536 → 3 этаж
  ///
  /// 6. Институт энергетики (первая цифра = 6):
  ///    - вторая цифра 1 => 1 этаж
  ///    - вторая цифра 2 => 2 этаж
  ///    - вторая цифра 3 => 3 этаж
  ///    - и т.д.
  ///    Примеры: 621 → 2 этаж, 636 → 3 этаж
  ///
  /// 7. Институт машиностроения (первая цифра = 7):
  ///    - вторая цифра 1 => 1 этаж
  ///    - вторая цифра 2 => 2 этаж
  ///    - вторая цифра 3 => 3 этаж
  ///    - и т.д.
  ///    Примеры: 721 → 2 этаж, 736 → 3 этаж
  ///
  /// 8. Институт строительства и архитектуры (первая цифра = 8):
  ///    - вторая цифра 1 => 1 этаж
  ///    - вторая цифра 2 => 2 этаж
  ///    - вторая цифра 3 => 3 этаж
  ///    - и т.д.
  ///    Примеры: 821 → 2 этаж, 836 → 3 этаж
  ///
  /// 9. Институт дополнительного профессионального образования (первая цифра = 9):
  ///    - вторая цифра 1 => 1 этаж
  ///    - вторая цифра 2 => 2 этаж
  ///    - вторая цифра 3 => 3 этаж
  ///    - и т.д.
  ///    Примеры: 921 → 2 этаж, 936 → 3 этаж
  ///
  /// @param classroomNumber Номер кабинета
  /// @return Номер этажа или null если не удалось определить
  static int? getFloor(String classroomNumber) {
    if (classroomNumber.isEmpty) return null;

    // Убираем все нецифровые символы
    final digits = classroomNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 2) return null;

    final instituteDigit = int.tryParse(digits[0]);
    final floorDigit = int.tryParse(digits[1]);

    if (instituteDigit == null || floorDigit == null) return null;

    // Проверяем, что номер института валиден (1-9)
    if (instituteDigit < 1 || instituteDigit > 9) return null;

    // Проверяем, что номер этажа валиден (1-9)
    if (floorDigit < 1 || floorDigit > 9) return null;

    return floorDigit;
  }

  /// Определяет институт по номеру кабинета
  ///
  /// @param classroomNumber Номер кабинета
  /// @return Название института или null если не удалось определить
  static String? getInstitute(String classroomNumber) {
    if (classroomNumber.isEmpty) return null;

    final digits = classroomNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return null;

    final instituteDigit = int.tryParse(digits[0]);
    if (instituteDigit == null || instituteDigit < 1 || instituteDigit > 9) {
      return null;
    }

    switch (instituteDigit) {
      case 1:
        return 'Институт экономики и управления';
      case 2:
        return 'Институт информационных технологий и систем связи';
      case 3:
        return 'Институт заочного и открытого образования';
      case 4:
        return 'Институт транспорта';
      case 5:
        return 'Институт гуманитарного образования';
      case 6:
        return 'Институт энергетики';
      case 7:
        return 'Институт машиностроения';
      case 8:
        return 'Институт строительства и архитектуры';
      case 9:
        return 'Институт дополнительного профессионального образования';
      default:
        return null;
    }
  }

  /// Форматирует информацию о кабинете
  ///
  /// @param classroomNumber Номер кабинета
  /// @return Отформатированная строка с информацией о кабинете
  static String formatClassroomInfo(String classroomNumber) {
    final floor = getFloor(classroomNumber);
    final institute = getInstitute(classroomNumber);

    if (floor == null && institute == null) {
      return classroomNumber;
    }

    final parts = <String>[classroomNumber];
    if (floor != null) {
      parts.add('${floor} эт.');
    }
    if (institute != null) {
      parts.add(institute);
    }

    return parts.join(' • ');
  }

  /// Получает информацию о местоположении кабинета
  ///
  /// @param classroomNumber Номер кабинета
  /// @return Объект с информацией о местоположении или null
  static RoomLocationInfo? getRoomLocationInfo(String classroomNumber) {
    final floor = getFloor(classroomNumber);
    final institute = getInstitute(classroomNumber);

    if (floor == null && institute == null) {
      return null;
    }

    return RoomLocationInfo(
      classroom: classroomNumber,
      floor: floor,
      institute: institute,
    );
  }

  /// Форматирует этаж для отображения
  ///
  /// @param floor Номер этажа
  /// @return Отформатированная строка с этажом
  static String formatFloor(int? floor) {
    if (floor == null) return '';
    return '${floor} эт.';
  }

  /// Проверяет, является ли кабинет стандартным (4-х значный номер)
  ///
  /// @param classroomNumber Номер кабинета
  /// @return true если кабинет стандартный
  static bool isStandardClassroom(String classroomNumber) {
    final digits = classroomNumber.replaceAll(RegExp(r'\D'), '');
    return digits.length == 4;
  }

  /// Получает диапазон кабинетов для этажа
  ///
  /// @param instituteDigit Номер института (1-9)
  /// @param floor Номер этажа (1-9)
  /// @return Диапазон номеров кабинетов
  static List<int> getFloorRange(int instituteDigit, int floor) {
    if (instituteDigit < 1 || instituteDigit > 9 || floor < 1 || floor > 9) {
      return <int>[];
    }

    final start = instituteDigit * 1000 + floor * 100;
    final end = start + 99;

    return List.generate(end - start + 1, (index) => start + index);
  }

  /// Получает все кабинеты института
  ///
  /// @param instituteDigit Номер института (1-9)
  /// @return Список всех кабинетов института
  static List<int> getInstituteRooms(int instituteDigit) {
    if (instituteDigit < 1 || instituteDigit > 9) {
      return <int>[];
    }

    final rooms = <int>[];
    for (int floor = 1; floor <= 9; floor++) {
      rooms.addAll(getFloorRange(instituteDigit, floor));
    }

    return rooms;
  }

  /// Проверяет, принадлежит ли кабинет институту
  ///
  /// @param classroomNumber Номер кабинета
  /// @param instituteDigit Номер института (1-9)
  /// @return true если кабинет принадлежит институту
  static bool belongsToInstitute(String classroomNumber, int instituteDigit) {
    final digits = classroomNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 2) return false;

    final roomInstituteDigit = int.tryParse(digits[0]);
    return roomInstituteDigit == instituteDigit;
  }

  /// Получает соседние кабинеты на том же этаже
  ///
  /// @param classroomNumber Номер кабинета
  /// @param radius Радиус поиска (сколько кабинетов в каждую сторону)
  /// @return Список соседних кабинетов
  static List<String> getNeighboringRooms(String classroomNumber, {int radius = 2}) {
    final digits = classroomNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 3) return <String>[];

    final instituteDigit = int.tryParse(digits[0]);
    final floorDigit = int.tryParse(digits[1]);
    final roomNumber = int.tryParse(digits.substring(2));

    if (instituteDigit == null || floorDigit == null || roomNumber == null) {
      return <String>[];
    }

    final neighboring = <String>[];
    final start = (roomNumber - radius).clamp(0, 99);
    final end = (roomNumber + radius).clamp(0, 99);

    for (int i = start; i <= end; i++) {
      if (i != roomNumber) {
        neighboring.add('${instituteDigit}${floorDigit}${i.toString().padLeft(2, '0')}');
      }
    }

    return neighboring;
  }

  /// Получает статистику по кабинетам
  ///
  /// @param classroomNumbers Список номеров кабинетов
  /// @return Статистика по кабинетам
  static ClassroomStats getClassroomStats(List<String> classroomNumbers) {
    final instituteCounts = <int, int>{};
    final floorCounts = <int, int>{};
    int standardCount = 0;

    for (final classroom in classroomNumbers) {
      final digits = classroom.replaceAll(RegExp(r'\D'), '');
      if (digits.length >= 2) {
        final instituteDigit = int.tryParse(digits[0]);
        final floorDigit = int.tryParse(digits[1]);

        if (instituteDigit != null) {
          instituteCounts[instituteDigit] = (instituteCounts[instituteDigit] ?? 0) + 1;
        }
        if (floorDigit != null) {
          floorCounts[floorDigit] = (floorCounts[floorDigit] ?? 0) + 1;
        }
      }

      if (isStandardClassroom(classroom)) {
        standardCount++;
      }
    }

    return ClassroomStats(
      instituteCounts: instituteCounts,
      floorCounts: floorCounts,
      standardCount: standardCount,
      totalCount: classroomNumbers.length,
    );
  }

  /// Валидирует номер кабинета
  ///
  /// @param classroomNumber Номер кабинета
  /// @return true если номер валидный
  static bool isValidClassroom(String classroomNumber) {
    if (classroomNumber.isEmpty) return false;

    final digits = classroomNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 2) return false;

    final instituteDigit = int.tryParse(digits[0]);
    final floorDigit = int.tryParse(digits[1]);

    return instituteDigit != null &&
        floorDigit != null &&
        instituteDigit >= 1 &&
        instituteDigit <= 9 &&
        floorDigit >= 1 &&
        floorDigit <= 9;
  }

  /// Нормализует номер кабинета
  ///
  /// @param classroomNumber Номер кабинета
  /// @return Нормализованный номер кабинета
  static String normalizeClassroom(String classroomNumber) {
    final digits = classroomNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 2) return classroomNumber;

    final instituteDigit = digits[0];
    final floorDigit = digits[1];
    final roomNumber = digits.length > 2 ? digits.substring(2) : '';

    return '$instituteDigit$floorDigit${roomNumber.padLeft(2, '0')}';
  }

  /// Получает сокращенное название института
  ///
  /// @param instituteDigit Номер института (1-9)
  /// @return Сокращенное название института
  static String? getInstituteShortName(int instituteDigit) {
    switch (instituteDigit) {
      case 1:
        return 'ИЭиУ';
      case 2:
        return 'ИТиСС';
      case 3:
        return 'ИЗиДО';
      case 4:
        return 'ИТ';
      case 5:
        return 'ИГО';
      case 6:
        return 'ИЭ';
      case 7:
        return 'ИМ';
      case 8:
        return 'ИСиА';
      case 9:
        return 'ИДПО';
      default:
        return null;
    }
  }

  /// Получает полное название института по номеру
  ///
  /// @param instituteDigit Номер института (1-9)
  /// @return Полное название института
  static String? getInstituteFullName(int instituteDigit) {
    return getInstitute('$instituteDigit');
  }

  /// Проверяет, является ли кабинет аудиторией
  ///
  /// @param classroomNumber Номер кабинета
  /// @return true если это аудитория
  static bool isAuditorium(String classroomNumber) {
    // Аудитории обычно имеют номера от 100 до 999
    final digits = classroomNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 3) return false;

    final number = int.tryParse(digits);
    return number != null && number >= 100 && number <= 999;
  }

  /// Проверяет, является ли кабинет лабораторией
  ///
  /// @param classroomNumber Номер кабинета
  /// @return true если это лаборатория
  static bool isLaboratory(String classroomNumber) {
    // Лаборатории обычно имеют номера с префиксом "Л"
    return classroomNumber.toUpperCase().startsWith('Л');
  }

  /// Получает тип кабинета
  ///
  /// @param classroomNumber Номер кабинета
  /// @return Тип кабинета
  static ClassroomType getClassroomType(String classroomNumber) {
    if (isLaboratory(classroomNumber)) {
      return ClassroomType.laboratory;
    } else if (isAuditorium(classroomNumber)) {
      return ClassroomType.auditorium;
    } else {
      return ClassroomType.other;
    }
  }

  /// Получает рекомендуемую вместимость кабинета
  ///
  /// @param classroomNumber Номер кабинета
  /// @return Рекомендуемая вместимость
  static int getRecommendedCapacity(String classroomNumber) {
    final type = getClassroomType(classroomNumber);
    final floor = getFloor(classroomNumber);

    switch (type) {
      case ClassroomType.auditorium:
        // Большие аудитории обычно на нижних этажах
        if (floor != null && floor <= 2) return 150;
        return 100;
      case ClassroomType.laboratory:
        return 30;
      case ClassroomType.other:
        return 25;
    }
  }

  /// Получает доступность кабинета для людей с ограниченными возможностями
  ///
  /// @param classroomNumber Номер кабинета
  /// @return true если кабинет доступен
  static bool isAccessible(String classroomNumber) {
    final floor = getFloor(classroomNumber);
    // Кабинеты на первом этаже считаются доступными
    return floor == 1;
  }

  /// Получает расстояние между кабинетами
  ///
  /// @param classroom1 Первый кабинет
  /// @param classroom2 Второй кабинет
  /// @return Расстояние в условных единицах
  static int getDistance(String classroom1, String classroom2) {
    final info1 = getRoomLocationInfo(classroom1);
    final info2 = getRoomLocationInfo(classroom2);

    if (info1 == null || info2 == null) return -1;

    // Если в разных институтах - большое расстояние
    if (info1.institute != info2.institute) return 1000;

    // Если на разных этажах - разница в этажах
    if (info1.floor != info2.floor) {
      return (info1.floor! - info2.floor!).abs();
    }

    // Если на одном этаже - считаем разницу в номерах
    final digits1 = classroom1.replaceAll(RegExp(r'\D'), '');
    final digits2 = classroom2.replaceAll(RegExp(r'\D'), '');

    if (digits1.length >= 3 && digits2.length >= 3) {
      final num1 = int.tryParse(digits1.substring(2)) ?? 0;
      final num2 = int.tryParse(digits2.substring(2)) ?? 0;
      return (num1 - num2).abs();
    }

    return 0;
  }

  /// Получает ближайшие кабинеты
  ///
  /// @param classroomNumber Номер кабинета
  /// @param allClassrooms Список всех кабинетов для поиска
  /// @param limit Максимальное количество результатов
  /// @return Список ближайших кабинетов с расстояниями
  static List<NearestRoom> getNearestRooms(
    String classroomNumber,
    List<String> allClassrooms, {
    int limit = 5,
  }) {
    final nearest = <NearestRoom>[];

    for (final classroom in allClassrooms) {
      if (classroom == classroomNumber) continue;

      final distance = getDistance(classroomNumber, classroom);
      if (distance >= 0) {
        nearest.add(NearestRoom(
          classroom: classroom,
          distance: distance,
        ));
      }
    }

    nearest.sort((a, b) => a.distance.compareTo(b.distance));
    return nearest.take(limit).toList();
  }

  /// Получает оптимальный маршрут между кабинетами
  ///
  /// @param classrooms Список кабинетов для посещения
  /// @return Оптимальный порядок посещения кабинетов
  static List<String> getOptimalRoute(List<String> classrooms) {
    if (classrooms.length <= 1) return classrooms;

    final unvisited = List<String>.from(classrooms);
    final route = <String>[];
    String current = unvisited.removeAt(0);
    route.add(current);

    while (unvisited.isNotEmpty) {
      String? nearest;
      int minDistance = -1;

      for (final classroom in unvisited) {
        final distance = getDistance(current, classroom);
        if (distance >= 0 && (minDistance == -1 || distance < minDistance)) {
          minDistance = distance;
          nearest = classroom;
        }
      }

      if (nearest != null) {
        current = nearest;
        route.add(current);
        unvisited.remove(nearest);
      } else {
        // Если не нашли путь до оставшихся кабинетов, добавляем их в любом порядке
        route.addAll(unvisited);
        break;
      }
    }

    return route;
  }

  /// Получает время перемещения между кабинетами
  ///
  /// @param classroom1 Первый кабинет
  /// @param classroom2 Второй кабинет
  /// @return Время в минутах
  static int getTravelTime(String classroom1, String classroom2) {
    final distance = getDistance(classroom1, classroom2);
    if (distance < 0) return -1;

    // Базовое время: 1 минута на этаж + 30 секунд на каждый кабинет
    return distance + (distance ~/ 2);
  }

  /// Получает общее время маршрута
  ///
  /// @param classrooms Список кабинетов маршрута
  /// @return Общее время в минутах
  static int getTotalRouteTime(List<String> classrooms) {
    if (classrooms.length <= 1) return 0;

    int totalTime = 0;
    for (int i = 0; i < classrooms.length - 1; i++) {
      final travelTime = getTravelTime(classrooms[i], classrooms[i + 1]);
      if (travelTime >= 0) {
        totalTime += travelTime;
      }
    }

    return totalTime;
  }

  /// Получает рекомендации по выбору кабинета
  ///
  /// @param requirements Требования к кабинету
  /// @param availableClassrooms Доступные кабинеты
  /// @return Список подходящих кабинетов с оценками
  static List<ClassroomRecommendation> getRecommendations(
    ClassroomRequirements requirements,
    List<String> availableClassrooms,
  ) {
    final recommendations = <ClassroomRecommendation>[];

    for (final classroom in availableClassrooms) {
      final info = getRoomLocationInfo(classroom);
      if (info == null) continue;

      int score = 0;
      final reasons = <String>[];

      // Проверка вместимости
      final capacity = getRecommendedCapacity(classroom);
      if (capacity >= requirements.minCapacity) {
        score += 10;
        reasons.add('Вместимость: $capacity мест');
      }

      // Проверка доступности
      if (requirements.needsAccessibility && isAccessible(classroom)) {
        score += 15;
        reasons.add('Доступен для маломобильных');
      }

      // Проверка типа
      if (requirements.preferredTypes.contains(getClassroomType(classroom))) {
        score += 5;
        reasons.add('Подходящий тип: ${getClassroomType(classroom)}');
      }

      // Проверка этажа
      if (requirements.preferredFloors.contains(info.floor)) {
        score += 3;
        reasons.add('Предпочтительный этаж: ${info.floor}');
      }

      // Проверка института
      if (requirements.preferredInstitutes.contains(info.institute)) {
        score += 7;
        reasons.add('Предпочтительный институт: ${info.institute}');
      }

      if (score > 0) {
        recommendations.add(ClassroomRecommendation(
          classroom: classroom,
          score: score,
          reasons: reasons,
        ));
      }
    }

    recommendations.sort((a, b) => b.score.compareTo(a.score));
    return recommendations;
  }

  /// Получает загруженность этажа
  ///
  /// @param instituteDigit Номер института
  /// @param floor Номер этажа
  /// @param occupiedClassrooms Занятые кабинеты
  /// @return Процент загруженности
  static double getFloorOccupancy(
    int instituteDigit,
    int floor,
    List<String> occupiedClassrooms,
  ) {
    final totalRooms = getFloorRange(instituteDigit, floor);
    if (totalRooms.isEmpty) return 0.0;

    int occupiedCount = 0;
    for (final occupied in occupiedClassrooms) {
      if (belongsToInstitute(occupied, instituteDigit) && getFloor(occupied) == floor) {
        occupiedCount++;
      }
    }

    return occupiedCount / totalRooms.length;
  }

  /// Получает свободные кабинеты
  ///
  /// @param instituteDigit Номер института
  /// @param floor Номер этажа
  /// @param occupiedClassrooms Занятые кабинеты
  /// @return Список свободных кабинетов
  static List<String> getAvailableRooms(
    int instituteDigit,
    int floor,
    List<String> occupiedClassrooms,
  ) {
    final allRooms = getFloorRange(instituteDigit, floor);
    final available = <String>[];

    for (final room in allRooms) {
      final roomStr = room.toString().padLeft(4, '0');
      if (!occupiedClassrooms.contains(roomStr)) {
        available.add(roomStr);
      }
    }

    return available;
  }

  /// Получает лучшую доступную аудиторию
  ///
  /// @param requirements Требования
  /// @param occupiedClassrooms Занятые кабинеты
  /// @return Лучшая аудитория или null
  static String? getBestAvailableAuditorium(
    ClassroomRequirements requirements,
    List<String> occupiedClassrooms,
  ) {
    final recommendations = getRecommendations(requirements, occupiedClassrooms);
    final auditoriumRecommendations = recommendations
        .where((r) => getClassroomType(r.classroom) == ClassroomType.auditorium)
        .toList();

    if (auditoriumRecommendations.isNotEmpty) {
      return auditoriumRecommendations.first.classroom;
    }

    return null;
  }

  /// Получает статистику по загруженности институтов
  ///
  /// @param occupiedClassrooms Занятые кабинеты
  /// @return Статистика по институтам
  static Map<int, InstituteOccupancyStats> getInstituteOccupancyStats(
    List<String> occupiedClassrooms,
  ) {
    final stats = <int, InstituteOccupancyStats>{};

    for (int institute = 1; institute <= 9; institute++) {
      final instituteRooms = getInstituteRooms(institute);
      int occupiedCount = 0;

      for (final occupied in occupiedClassrooms) {
        if (belongsToInstitute(occupied, institute)) {
          occupiedCount++;
        }
      }

      stats[institute] = InstituteOccupancyStats(
        institute: institute,
        totalRooms: instituteRooms.length,
        occupiedRooms: occupiedCount,
        occupancyRate: instituteRooms.isNotEmpty ? occupiedCount / instituteRooms.length : 0.0,
      );
    }

    return stats;
  }

  /// Получает прогноз загруженности
  ///
  /// @param historicalData Исторические данные о загруженности
  /// @param timeOfDay Время дня
  /// @param dayOfWeek День недели
  /// @return Прогноз загруженности
  static double predictOccupancy(
    Map<String, List<OccupancyData>> historicalData,
    DateTime timeOfDay,
    int dayOfWeek,
  ) {
    // Простая эвристика на основе исторических данных
    double totalOccupancy = 0.0;
    int dataPoints = 0;

    for (final entry in historicalData.entries) {
      for (final data in entry.value) {
        if (data.dayOfWeek == dayOfWeek) {
          final hourDiff = (timeOfDay.hour - data.time.hour).abs();
          if (hourDiff <= 1) { // Учитываем данные в пределах часа
            totalOccupancy += data.occupancyRate;
            dataPoints++;
          }
        }
      }
    }

    return dataPoints > 0 ? totalOccupancy / dataPoints : 0.5; // По умолчанию 50%
  }

  /// Получает оптимальное время для проведения мероприятия
  ///
  /// @param duration Длительность в часах
  /// @param requirements Требования к кабинету
  /// @param historicalData Исторические данные
  /// @return Оптимальное время
  static OptimalTimeSlot? getOptimalTimeSlot(
    int duration,
    ClassroomRequirements requirements,
    Map<String, List<OccupancyData>> historicalData,
  ) {
    final now = DateTime.now();
    final bestSlots = <OptimalTimeSlot>[];

    // Проверяем слоты в течение следующей недели
    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      final date = now.add(Duration(days: dayOffset));
      final dayOfWeek = date.weekday;

      for (int hour = 8; hour <= 20 - duration; hour++) {
        final startTime = DateTime(date.year, date.month, date.day, hour);
        final endTime = startTime.add(Duration(hours: duration));

        double avgOccupancy = 0.0;
        for (int h = hour; h < hour + duration; h++) {
          final checkTime = DateTime(date.year, date.month, date.day, h);
          avgOccupancy += predictOccupancy(historicalData, checkTime, dayOfWeek);
        }
        avgOccupancy /= duration;

        bestSlots.add(OptimalTimeSlot(
          startTime: startTime,
          endTime: endTime,
          expectedOccupancy: avgOccupancy,
          score: 1.0 - avgOccupancy, // Чем ниже загруженность, тем лучше
        ));
      }
    }

    if (bestSlots.isEmpty) return null;

    bestSlots.sort((a, b) => b.score.compareTo(a.score));
    return bestSlots.first;
  }

  /// Получает информацию о здании
  ///
  /// @param classroomNumber Номер кабинета
  /// @return Информация о здании
  static BuildingInfo? getBuildingInfo(String classroomNumber) {
    final institute = getInstitute(classroomNumber);
    if (institute == null) return null;

    // Определяем корпус по институту
    String? building;
    String? address;

    switch (institute) {
      case 'Институт экономики и управления':
        building = 'Корпус А';
        address = 'ул. Ленина, 58';
        break;
      case 'Институт информационных технологий и систем связи':
        building = 'Корпус Б';
        address = 'ул. Ленина, 66';
        break;
      case 'Институт заочного и открытого образования':
        building = 'Корпус В';
        address = 'ул. Ленина, 74';
        break;
      case 'Институт транспорта':
        building = 'Корпус Г';
        address = 'ул. Ленина, 82';
        break;
      case 'Институт гуманитарного образования':
        building = 'Корпус Д';
        address = 'ул. Ленина, 90';
        break;
      case 'Институт энергетики':
        building = 'Корпус Е';
        address = 'ул. Ленина, 98';
        break;
      case 'Институт машиностроения':
        building = 'Корпус Ж';
        address = 'ул. Ленина, 106';
        break;
      case 'Институт строительства и архитектуры':
        building = 'Корпус З';
        address = 'ул. Ленина, 114';
        break;
      case 'Институт дополнительного профессионального образования':
        building = 'Корпус И';
        address = 'ул. Ленина, 122';
        break;
    }

    if (building == null || address == null) return null;

    return BuildingInfo(
      building: building,
      address: address,
      floors: 9,
      hasElevator: true,
      hasParking: true,
    );
  }

  /// Получает координаты кабинета для навигации
  ///
  /// @param classroomNumber Номер кабинета
  /// @return Координаты [x, y] или null
  static List<double>? getClassroomCoordinates(String classroomNumber) {
    final floor = getFloor(classroomNumber);
    if (floor == null) return null;

    final digits = classroomNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 3) return null;

    final roomNumber = int.tryParse(digits.substring(2));
    if (roomNumber == null) return null;

    // Простая эвристика для распределения кабинетов по координатам
    final x = (roomNumber % 10) * 10.0 + 5.0; // Позиция по коридору
    final y = (roomNumber ~/ 10) * 8.0 + 4.0; // Глубина в здании

    return <double>[x, y];
  }

  /// Получает координаты всех кабинетов на этаже
  ///
  /// @param instituteDigit Номер института
  /// @param floor Номер этажа
  /// @return Map с координатами кабинетов
  static Map<String, List<double>> getFloorCoordinates(int instituteDigit, int floor) {
    final coordinates = <String, List<double>>{};
    final rooms = getFloorRange(instituteDigit, floor);

    for (final room in rooms) {
      final roomStr = room.toString().padLeft(4, '0');
      final coords = getClassroomCoordinates(roomStr);
      if (coords != null) {
        coordinates[roomStr] = coords;
      }
    }

    return coordinates;
  }

  /// Получает путь между кабинетами
  ///
  /// @param from Начальный кабинет
  /// @param to Конечный кабинет
  /// @return Список координат для пути
  static List<List<double>> getPath(String from, String to) {
    final fromCoords = getClassroomCoordinates(from);
    final toCoords = getClassroomCoordinates(to);

    if (fromCoords == null || toCoords == null) {
      return <List<double>>[];
    }

    // Простая эвристика: прямая линия с учетом этажей
    final path = <List<double>>[];
    final fromFloor = getFloor(from);
    final toFloor = getFloor(to);

    if (fromFloor != toFloor) {
      // Добавляем точки для перемещения между этажами
      path.add(fromCoords);
      path.add(<double>[fromCoords[0], fromCoords[1] + 20.0]); // Выход на лестницу
      path.add(<double>[toCoords[0], toCoords[1] + 20.0]); // Вход с лестницы
    } else {
      path.add(fromCoords);
    }

    path.add(toCoords);
    return path;
  }

  /// Получает длину пути
  ///
  /// @param path Список координат пути
  /// @return Длина пути в условных единицах
  static double getPathLength(List<List<double>> path) {
    if (path.length < 2) return 0.0;

    double totalLength = 0.0;
    for (int i = 0; i < path.length - 1; i++) {
      final dx = path[i + 1][0] - path[i][0];
      final dy = path[i + 1][1] - path[i][1];
      totalLength += (dx * dx + dy * dy);
    }

    return totalLength;
  }

  /// Получает оптимальный путь по нескольким кабинетам
  ///
  /// @param classrooms Список кабинетов для посещения
  /// @return Оптимальный путь
  static List<List<double>> getOptimalPath(List<String> classrooms) {
    if (classrooms.length <= 1) {
      return <List<double>>[];
    }

    final optimalRoute = getOptimalRoute(classrooms);
    final fullPath = <List<double>>[];

    for (int i = 0; i < optimalRoute.length - 1; i++) {
      final segmentPath = getPath(optimalRoute[i], optimalRoute[i + 1]);
      if (i > 0) {
        // Убираем дублирующую точку
        segmentPath.removeAt(0);
      }
      fullPath.addAll(segmentPath);
    }

    return fullPath;
  }

  /// Получает время пути
  ///
  /// @param path Список координат пути
  /// @return Время в минутах
  static int getPathTime(List<List<double>> path) {
    final length = getPathLength(path);
    // Скорость движения: 10 условных единиц в минуту
    return (length / 10).ceil();
  }

  /// Получает информацию о навигации
  ///
  /// @param from Начальный кабинет
  /// @param to Конечный кабинет
  /// @return Информация о навигации
  static NavigationInfo? getNavigationInfo(String from, String to) {
    final path = getPath(from, to);
    if (path.isEmpty) return null;

    final distance = getPathLength(path);
    final time = getPathTime(path);
    final fromFloor = getFloor(from);
    final toFloor = getFloor(to);

    return NavigationInfo(
      from: from,
      to: to,
      path: path,
      distance: distance,
      estimatedTime: time,
      floorChanges: (fromFloor != toFloor) ? 1 : 0,
    );
  }

  /// Проверяет доступность кабинета в указанное время
  ///
  /// @param classroomNumber Номер кабинета
  /// @param startTime Время начала
  /// @param endTime Время окончания
  /// @param schedule Расписание занятий
  /// @return true если кабинет свободен
  static bool isClassroomAvailable(
    String classroomNumber,
    DateTime startTime,
    DateTime endTime,
    Map<String, List<ScheduleEntry>> schedule,
  ) {
    final entries = schedule[classroomNumber];
    if (entries == null || entries.isEmpty) return true;

    for (final entry in entries) {
      // Проверяем пересечение временных интервалов
      if (startTime.isBefore(entry.endTime) && endTime.isAfter(entry.startTime)) {
        return false;
      }
    }

    return true;
  }

  /// Получает свободные слоты для кабинета
  ///
  /// @param classroomNumber Номер кабинета
  /// @param date Дата
  /// @param schedule Расписание
  /// @param duration Длительность в минутах
  /// @return Список свободных слотов
  static List<TimeSlot> getAvailableTimeSlots(
    String classroomNumber,
    DateTime date,
    Map<String, List<ScheduleEntry>> schedule,
    int duration,
  ) {
    final slots = <TimeSlot>[];
    final entries = schedule[classroomNumber] ?? <ScheduleEntry>[];

    // Рабочее время: 8:00 - 20:00
    final workStart = DateTime(date.year, date.month, date.day, 8);
    final workEnd = DateTime(date.year, date.month, date.day, 20);

    // Сортируем записи по времени начала
    final sortedEntries = List<ScheduleEntry>.from(entries);
    sortedEntries.sort((a, b) => a.startTime.compareTo(b.startTime));

    DateTime currentTime = workStart;

    for (final entry in sortedEntries) {
      // Проверяем свободное время до текущей записи
      if (currentTime.isBefore(entry.startTime)) {
        final availableDuration = entry.startTime.difference(currentTime).inMinutes;
        if (availableDuration >= duration) {
          slots.add(TimeSlot(
            startTime: currentTime,
            endTime: entry.startTime,
            availableDuration: availableDuration,
          ));
        }
      }
      currentTime = currentTime.isAfter(entry.endTime) ? currentTime : entry.endTime;
    }

    // Проверяем время после последней записи
    if (currentTime.isBefore(workEnd)) {
      final availableDuration = workEnd.difference(currentTime).inMinutes;
      if (availableDuration >= duration) {
        slots.add(TimeSlot(
          startTime: currentTime,
          endTime: workEnd,
          availableDuration: availableDuration,
        ));
      }
    }

    return slots;
  }

  /// Получает лучшие свободные слоты для нескольких кабинетов
  ///
  /// @param classroomNumbers Список кабинетов
  /// @param date Дата
  /// @param schedule Расписание
  /// @param duration Длительность в минутах
  /// @return Список лучших слотов
  static List<BestTimeSlot> getBestAvailableSlots(
    List<String> classroomNumbers,
    DateTime date,
    Map<String, List<ScheduleEntry>> schedule,
    int duration,
  ) {
    final allSlots = <BestTimeSlot>[];

    for (final classroom in classroomNumbers) {
      final slots = getAvailableTimeSlots(classroom, date, schedule, duration);
      for (final slot in slots) {
        allSlots.add(BestTimeSlot(
          classroom: classroom,
          startTime: slot.startTime,
          endTime: slot.endTime,
          score: _calculateSlotScore(slot, classroom),
        ));
      }
    }

    // Сортируем по оценке
    allSlots.sort((a, b) => b.score.compareTo(a.score));
    return allSlots;
  }

  /// Вычисляет оценку для временного слота
  static double _calculateSlotScore(TimeSlot slot, String classroom) {
    double score = 100.0;

    // Предпочтительное время: 9:00 - 17:00
    final hour = slot.startTime.hour;
    if (hour < 9 || hour > 17) {
      score -= 20.0;
    }

    // Предпочтительные дни: вторник - четверг
    final dayOfWeek = slot.startTime.weekday;
    if (dayOfWeek == DateTime.monday || dayOfWeek == DateTime.friday) {
      score -= 10.0;
    }

    // Предпочтительные этажи: 2-4
    final floor = getFloor(classroom);
    if (floor != null && (floor < 2 || floor > 4)) {
      score -= 5.0;
    }

    return score;
  }

  /// Получает рекомендации по расписанию
  ///
  /// @param requirements Требования к занятию
  /// @param date Дата
  /// @param schedule Расписание
  /// @return Список рекомендаций
  static List<ScheduleRecommendation> getScheduleRecommendations(
    ScheduleRequirements requirements,
    DateTime date,
    Map<String, List<ScheduleEntry>> schedule,
  ) {
    final recommendations = <ScheduleRecommendation>[];
    final bestSlots = getBestAvailableSlots(
      requirements.preferredClassrooms,
      date,
      schedule,
      requirements.duration,
    );

    for (final slot in bestSlots) {
      final info = getRoomLocationInfo(slot.classroom);
      if (info == null) continue;

      // Проверяем соответствие требованиям
      bool matchesRequirements = true;
      final reasons = <String>[];

      if (requirements.minCapacity > 0) {
        final capacity = getRecommendedCapacity(slot.classroom);
        if (capacity < requirements.minCapacity) {
          matchesRequirements = false;
        } else {
          reasons.add('Вместимость: $capacity мест');
        }
      }

      if (requirements.needsAccessibility && !isAccessible(slot.classroom)) {
        matchesRequirements = false;
      } else if (requirements.needsAccessibility) {
        reasons.add('Доступен для маломобильных');
      }

      if (requirements.preferredTypes.isNotEmpty &&
          !requirements.preferredTypes.contains(getClassroomType(slot.classroom))) {
        matchesRequirements = false;
      } else if (requirements.preferredTypes.isNotEmpty) {
        reasons.add('Тип: ${getClassroomType(slot.classroom)}');
      }

      if (matchesRequirements) {
        recommendations.add(ScheduleRecommendation(
          classroom: slot.classroom,
          startTime: slot.startTime,
          endTime: slot.endTime,
          score: slot.score,
          reasons: reasons,
        ));
      }
    }

    return recommendations;
  }

  /// Получает конфликтующие занятия
  ///
  /// @param schedule Расписание
  /// @return Список конфликтов
  static List<ScheduleConflict> getScheduleConflicts(
    Map<String, List<ScheduleEntry>> schedule,
  ) {
    final conflicts = <ScheduleConflict>[];

    for (final entries in schedule.values) {
      for (int i = 0; i < entries.length; i++) {
        for (int j = i + 1; j < entries.length; j++) {
          final entry1 = entries[i];
          final entry2 = entries[j];

          // Проверяем пересечение времени
          if (entry1.startTime.isBefore(entry2.endTime) &&
              entry1.endTime.isAfter(entry2.startTime)) {
            conflicts.add(ScheduleConflict(
              classroom: schedule.keys.firstWhere(
                (key) => schedule[key]!.contains(entry1),
                orElse: () => '',
              ),
              entry1: entry1,
              entry2: entry2,
              conflictType: _getConflictType(entry1, entry2),
            ));
          }
        }
      }
    }

    return conflicts;
  }

  /// Определяет тип конфликта
  static ScheduleConflictType _getConflictType(
    ScheduleEntry entry1,
    ScheduleEntry entry2,
  ) {
    if (entry1.group == entry2.group) {
      return ScheduleConflictType.sameGroup;
    } else if (entry1.teacher == entry2.teacher) {
      return ScheduleConflictType.sameTeacher;
    } else {
      return ScheduleConflictType.overlappingTime;
    }
  }

  /// Получает оптимальное расписание
  ///
  /// @param requirements Список требований к занятиям
  /// @param availableClassrooms Доступные кабинеты
  /// @param existingSchedule Существующее расписание
  /// @return Оптимальное расписание
  static Map<String, List<ScheduleEntry>> getOptimalSchedule(
    List<ScheduleRequirements> requirements,
    List<String> availableClassrooms,
    Map<String, List<ScheduleEntry>> existingSchedule,
  ) {
    final optimalSchedule = <String, List<ScheduleEntry>>{};
    final schedule = Map<String, List<ScheduleEntry>>.from(existingSchedule);

    // Сортируем требования по приоритету
    final sortedRequirements = List<ScheduleRequirements>.from(requirements);
    sortedRequirements.sort((a, b) => b.priority.compareTo(a.priority));

    for (final req in sortedRequirements) {
      // Ищем лучшие слоты для каждого требования
      final date = req.date ?? DateTime.now();
      final recommendations = getScheduleRecommendations(req, date, schedule);

      if (recommendations.isNotEmpty) {
        final bestRec = recommendations.first;
        final entry = ScheduleEntry(
          group: req.group,
          teacher: req.teacher,
          subject: req.subject,
          classroom: bestRec.classroom,
          startTime: bestRec.startTime,
          endTime: bestRec.endTime,
        );

        schedule.putIfAbsent(bestRec.classroom, () => <ScheduleEntry>[]);
        schedule[bestRec.classroom]!.add(entry);
      }
    }

    return schedule;
  }

  /// Получает статистику использования кабинетов
  ///
  /// @param schedule Расписание
  /// @param period Период анализа
  /// @return Статистика использования
  static ClassroomUsageStats getUsageStats(
    Map<String, List<ScheduleEntry>> schedule,
    AnalysisPeriod period,
  ) {
    final now = DateTime.now();
    final startDate = _getStartDate(now, period);
    final endDate = _getEndDate(now, period);

    final usageByClassroom = <String, int>{};
    final usageByType = <ClassroomType, int>{};
    final usageByFloor = <int, int>{};
    final usageByInstitute = <String, int>{};
    int totalUsage = 0;

    for (final entry in schedule.values.expand((e) => e)) {
      if (entry.startTime.isAfter(startDate) && entry.startTime.isBefore(endDate)) {
        usageByClassroom[entry.classroom] =
            (usageByClassroom[entry.classroom] ?? 0) + 1;

        final type = getClassroomType(entry.classroom);
        usageByType[type] = (usageByType[type] ?? 0) + 1;

        final floor = getFloor(entry.classroom);
        if (floor != null) {
          usageByFloor[floor] = (usageByFloor[floor] ?? 0) + 1;
        }

        final institute = getInstitute(entry.classroom);
        if (institute != null) {
          usageByInstitute[institute] = (usageByInstitute[institute] ?? 0) + 1;
        }

        totalUsage++;
      }
    }

    return ClassroomUsageStats(
      period: period,
      totalUsage: totalUsage,
      usageByClassroom: usageByClassroom,
      usageByType: usageByType,
      usageByFloor: usageByFloor,
      usageByInstitute: usageByInstitute,
    );
  }

  /// Получает начальную дату периода
  static DateTime _getStartDate(DateTime now, AnalysisPeriod period) {
    switch (period) {
      case AnalysisPeriod.day:
        return DateTime(now.year, now.month, now.day);
      case AnalysisPeriod.week:
        return now.subtract(Duration(days: now.weekday - 1));
      case AnalysisPeriod.month:
        return DateTime(now.year, now.month, 1);
      case AnalysisPeriod.semester:
        // Предполагаем семестр с сентября по январь и с февраля по июнь
        if (now.month >= 2 && now.month <= 6) {
          return DateTime(now.year, 2, 1);
        } else {
          return DateTime(now.year, 9, 1);
        }
      case AnalysisPeriod.year:
        return DateTime(now.year, 1, 1);
    }
  }

  /// Получает конечную дату периода
  static DateTime _getEndDate(DateTime now, AnalysisPeriod period) {
    switch (period) {
      case AnalysisPeriod.day:
        return DateTime(now.year, now.month, now.day, 23, 59, 59);
      case AnalysisPeriod.week:
        return now.add(Duration(days: 7 - now.weekday));
      case AnalysisPeriod.month:
        return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      case AnalysisPeriod.semester:
        if (now.month >= 2 && now.month <= 6) {
          return DateTime(now.year, 6, 30, 23, 59, 59);
        } else {
          return DateTime(now.year, 1, 31, 23, 59, 59);
        }
      case AnalysisPeriod.year:
        return DateTime(now.year, 12, 31, 23, 59, 59);
    }
  }

  /// Получает прогноз использования кабинетов
  ///
  /// @param historicalData Исторические данные
  /// @param futurePeriod Будущий период
  /// @return Прогноз использования
  static Map<String, double> predictUsage(
    Map<String, ClassroomUsageStats> historicalData,
    AnalysisPeriod futurePeriod,
  ) {
    final predictions = <String, double>{};

    // Простая эвристика: среднее значение за предыдущие периоды
    for (final entry in historicalData.entries) {
      double totalUsage = 0.0;
      int dataPoints = 0;

      for (final stats in historicalData.values) {
        totalUsage += stats.totalUsage.toDouble();
        dataPoints++;
      }

      if (dataPoints > 0) {
        predictions[entry.key] = totalUsage / dataPoints;
      }
    }

    return predictions;
  }

  /// Получает рекомендации по оптимизации использования
  ///
  /// @param stats Статистика использования
  /// @return Список рекомендаций
  static List<OptimizationRecommendation> getOptimizationRecommendations(
    ClassroomUsageStats stats,
  ) {
    final recommendations = <OptimizationRecommendation>[];

    // Находим малоиспользуемые кабинеты
    final avgUsage = stats.totalUsage / stats.usageByClassroom.length;
    for (final entry in stats.usageByClassroom.entries) {
      if (entry.value < avgUsage * 0.5) {
        recommendations.add(OptimizationRecommendation(
          type: OptimizationType.underutilized,
          classroom: entry.key,
          description: 'Кабинет используется реже среднего на 50%',
          potentialSavings: _calculatePotentialSavings(entry.value, avgUsage),
        ));
      }
    }

    // Находим перегруженные типы кабинетов
    for (final entry in stats.usageByType.entries) {
      final typeUsage = entry.value;
      final totalTypeUsage = stats.usageByType.values.fold(0, (a, b) => a + b);
      final typePercentage = typeUsage / totalTypeUsage;

      if (typePercentage > 0.6) {
        recommendations.add(OptimizationRecommendation(
          type: OptimizationType.overloadedType,
          classroom: entry.key.toString(),
          description: 'Тип кабинетов ${entry.key} используется более 60% времени',
          potentialSavings: 0.0,
        ));
      }
    }

    return recommendations;
  }

  /// Рассчитывает потенциальную экономию
  static double _calculatePotentialSavings(int currentUsage, double avgUsage) {
    return (avgUsage - currentUsage) / avgUsage * 100.0;
  }

  /// Получает отчет об использовании кабинетов
  ///
  /// @param stats Статистика использования
  /// @return Отчет об использовании
  static UsageReport generateUsageReport(ClassroomUsageStats stats) {
    final recommendations = getOptimizationRecommendations(stats);
    final topUsedClassrooms = stats.usageByClassroom.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return UsageReport(
      period: stats.period,
      totalUsage: stats.totalUsage,
      topUsedClassrooms: topUsedClassrooms.take(10).toList(),
      usageByType: stats.usageByType,
      usageByFloor: stats.usageByFloor,
      usageByInstitute: stats.usageByInstitute,
      recommendations: recommendations,
      generatedAt: DateTime.now(),
    );
  }

  /// Экспортирует отчет в CSV
  ///
  /// @param report Отчет об использовании
  /// @return CSV строка
  static String exportToCSV(UsageReport report) {
    final buffer = StringBuffer();
    
    // Заголовок
    buffer.writeln('Период,Общее использование,Сгенерировано');
    buffer.writeln('${report.period},${report.totalUsage},${report.generatedAt}');
    buffer.writeln();

    // Топ кабинетов
    buffer.writeln('Топ кабинетов');
    buffer.writeln('Кабинет,Использование');
    for (final entry in report.topUsedClassrooms) {
      buffer.writeln('${entry.key},${entry.value}');
    }
    buffer.writeln();

    // Использование по типам
    buffer.writeln('Использование по типам');
    buffer.writeln('Тип,Использование');
    for (final entry in report.usageByType.entries) {
      buffer.writeln('${entry.key},${entry.value}');
    }
    buffer.writeln();

    // Использование по этажам
    buffer.writeln('Использование по этажам');
    buffer.writeln('Этаж,Использование');
    for (final entry in report.usageByFloor.entries) {
      buffer.writeln('${entry.key},${entry.value}');
    }
    buffer.writeln();

    // Рекомендации
    buffer.writeln('Рекомендации');
    buffer.writeln('Тип,Кабинет,Описание,Потенциальная экономия');
    for (final rec in report.recommendations) {
      buffer.writeln('${rec.type},${rec.classroom},${rec.description},${rec.potentialSavings}');
    }

    return buffer.toString();
  }

  /// Импортирует данные из CSV
  ///
  /// @param csvData CSV данные
  /// @return Расписание занятий
  static Map<String, List<ScheduleEntry>> importFromCSV(String csvData) {
    final schedule = <String, List<ScheduleEntry>>{};
    final lines = csvData.split('\n');

    for (int i = 1; i < lines.length; i++) { // Пропускаем заголовок
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      final parts = line.split(',');
      if (parts.length >= 6) {
        final classroom = parts[0].trim();
        final group = parts[1].trim();
        final teacher = parts[2].trim();
        final subject = parts[3].trim();
        final startTime = DateTime.tryParse(parts[4].trim());
        final endTime = DateTime.tryParse(parts[5].trim());

        if (startTime != null && endTime != null) {
          final entry = ScheduleEntry(
            group: group,
            teacher: teacher,
            subject: subject,
            classroom: classroom,
            startTime: startTime,
            endTime: endTime,
          );

          schedule.putIfAbsent(classroom, () => <ScheduleEntry>[]);
          schedule[classroom]!.add(entry);
        }
      }
    }

    return schedule;
  }

  /// Валидирует расписание
  ///
  /// @param schedule Расписание
  /// @return Список ошибок валидации
  static List<ValidationError> validateSchedule(
    Map<String, List<ScheduleEntry>> schedule,
  ) {
    final errors = <ValidationError>[];

    for (final entry in schedule.values.expand((e) => e)) {
      // Проверка валидности кабинета
      if (!isValidClassroom(entry.classroom)) {
        errors.add(ValidationError(
          type: ValidationErrorType.invalidClassroom,
          message: 'Невалидный номер кабинета: ${entry.classroom}',
          entry: entry,
        ));
      }

      // Проверка корректности времени
      if (entry.startTime.isAfter(entry.endTime)) {
        errors.add(ValidationError(
          type: ValidationErrorType.invalidTime,
          message: 'Время начала позже времени окончания',
          entry: entry,
        ));
      }

      // Проверка рабочего времени
      final hour = entry.startTime.hour;
      if (hour < 8 || hour > 20) {
        errors.add(ValidationError(
          type: ValidationErrorType.outsideWorkingHours,
          message: 'Занятие вне рабочего времени: ${hour}:00',
          entry: entry,
        ));
      }
    }

    return errors;
  }

  /// Получает сводку по расписанию
  ///
  /// @param schedule Расписание
  /// @return Сводка по расписанию
  static ScheduleSummary getScheduleSummary(
    Map<String, List<ScheduleEntry>> schedule,
  ) {
    int totalEntries = 0;
    final classrooms = <String>{};
    final groups = <String>{};
    final teachers = <String>{};
    final subjects = <String>{};

    for (final entry in schedule.values.expand((e) => e)) {
      totalEntries++;
      classrooms.add(entry.classroom);
      groups.add(entry.group);
      teachers.add(entry.teacher);
      subjects.add(entry.subject);
    }

    return ScheduleSummary(
      totalEntries: totalEntries,
      uniqueClassrooms: classrooms.length,
      uniqueGroups: groups.length,
      uniqueTeachers: teachers.length,
      uniqueSubjects: subjects.length,
    );
  }

  /// Получает загруженность по дням недели
  ///
  /// @param schedule Расписание
  /// @return Загруженность по дням
  static Map<int, int> getWeeklyLoad(
    Map<String, List<ScheduleEntry>> schedule,
  ) {
    final weeklyLoad = <int, int>{};

    for (final entry in schedule.values.expand((e) => e)) {
      final dayOfWeek = entry.startTime.weekday;
      weeklyLoad[dayOfWeek] = (weeklyLoad[dayOfWeek] ?? 0) + 1;
    }

    return weeklyLoad;
  }

  /// Получает загруженность по часам
  ///
  /// @param schedule Расписание
  /// @return Загруженность по часам
  static Map<int, int> getHourlyLoad(
    Map<String, List<ScheduleEntry>> schedule,
  ) {
    final hourlyLoad = <int, int>{};

    for (final entry in schedule.values.expand((e) => e)) {
      final hour = entry.startTime.hour;
      hourlyLoad[hour] = (hourlyLoad[hour] ?? 0) + 1;
    }

    return hourlyLoad;
  }
}

/// Информация о местоположении кабинета
class RoomLocationInfo {
  final String classroom;
  final int? floor;
  final String? institute;

  const RoomLocationInfo({
    required this.classroom,
    this.floor,
    this.institute,
  });
}

/// Статистика по кабинетам
class ClassroomStats {
  final Map<int, int> instituteCounts;
  final Map<int, int> floorCounts;
  final int standardCount;
  final int totalCount;

  const ClassroomStats({
    required this.instituteCounts,
    required this.floorCounts,
    required this.standardCount,
    required this.totalCount,
  });
}

/// Тип кабинета
enum ClassroomType {
  auditorium,
  laboratory,
  other,
}

/// Требования к кабинету
class ClassroomRequirements {
  final int minCapacity;
  final bool needsAccessibility;
  final List<ClassroomType> preferredTypes;
  final List<int?> preferredFloors;
  final List<String?> preferredInstitutes;

  const ClassroomRequirements({
    this.minCapacity = 0,
    this.needsAccessibility = false,
    this.preferredTypes = const [],
    this.preferredFloors = const [],
    this.preferredInstitutes = const [],
  });
}

/// Рекомендация по кабинету
class ClassroomRecommendation {
  final String classroom;
  final int score;
  final List<String> reasons;

  const ClassroomRecommendation({
    required this.classroom,
    required this.score,
    required this.reasons,
  });
}

/// Статистика загруженности института
class InstituteOccupancyStats {
  final int institute;
  final int totalRooms;
  final int occupiedRooms;
  final double occupancyRate;

  const InstituteOccupancyStats({
    required this.institute,
    required this.totalRooms,
    required this.occupiedRooms,
    required this.occupancyRate,
  });
}

/// Данные о загруженности
class OccupancyData {
  final DateTime time;
  final int dayOfWeek;
  final double occupancyRate;

  const OccupancyData({
    required this.time,
    required this.dayOfWeek,
    required this.occupancyRate,
  });
}

/// Оптимальный временной слот
class OptimalTimeSlot {
  final DateTime startTime;
  final DateTime endTime;
  final double expectedOccupancy;
  final double score;

  const OptimalTimeSlot({
    required this.startTime,
    required this.endTime,
    required this.expectedOccupancy,
    required this.score,
  });
}

/// Информация о здании
class BuildingInfo {
  final String building;
  final String address;
  final int floors;
  final bool hasElevator;
  final bool hasParking;

  const BuildingInfo({
    required this.building,
    required this.address,
    required this.floors,
    required this.hasElevator,
    required this.hasParking,
  });
}

/// Ближайший кабинет
class NearestRoom {
  final String classroom;
  final int distance;

  const NearestRoom({
    required this.classroom,
    required this.distance,
  });
}

/// Запись в расписании
class ScheduleEntry {
  final String group;
  final String teacher;
  final String subject;
  final String classroom;
  final DateTime startTime;
  final DateTime endTime;

  const ScheduleEntry({
    required this.group,
    required this.teacher,
    required this.subject,
    required this.classroom,
    required this.startTime,
    required this.endTime,
  });
}

/// Временной слот
class TimeSlot {
  final DateTime startTime;
  final DateTime endTime;
  final int availableDuration;

  const TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.availableDuration,
  });
}

/// Лучший временной слот
class BestTimeSlot {
  final String classroom;
  final DateTime startTime;
  final DateTime endTime;
  final double score;

  const BestTimeSlot({
    required this.classroom,
    required this.startTime,
    required this.endTime,
    required this.score,
  });
}

/// Требования к расписанию
class ScheduleRequirements {
  final String group;
  final String teacher;
  final String subject;
  final int duration;
  final List<String> preferredClassrooms;
  final int minCapacity;
  final bool needsAccessibility;
  final List<ClassroomType> preferredTypes;
  final DateTime? date;
  final int priority;

  const ScheduleRequirements({
    required this.group,
    required this.teacher,
    required this.subject,
    required this.duration,
    this.preferredClassrooms = const [],
    this.minCapacity = 0,
    this.needsAccessibility = false,
    this.preferredTypes = const [],
    this.date,
    this.priority = 0,
  });
}

/// Рекомендация по расписанию
class ScheduleRecommendation {
  final String classroom;
  final DateTime startTime;
  final DateTime endTime;
  final double score;
  final List<String> reasons;

  const ScheduleRecommendation({
    required this.classroom,
    required this.startTime,
    required this.endTime,
    required this.score,
    required this.reasons,
  });
}

/// Тип конфликта в расписании
enum ScheduleConflictType {
  sameGroup,
  sameTeacher,
  overlappingTime,
}

/// Конфликт в расписании
class ScheduleConflict {
  final String classroom;
  final ScheduleEntry entry1;
  final ScheduleEntry entry2;
  final ScheduleConflictType conflictType;

  const ScheduleConflict({
    required this.classroom,
    required this.entry1,
    required this.entry2,
    required this.conflictType,
  });
}

/// Период анализа
enum AnalysisPeriod {
  day,
  week,
  month,
  semester,
  year,
}

/// Статистика использования кабинетов
class ClassroomUsageStats {
  final AnalysisPeriod period;
  final int totalUsage;
  final Map<String, int> usageByClassroom;
  final Map<ClassroomType, int> usageByType;
  final Map<int, int> usageByFloor;
  final Map<String, int> usageByInstitute;

  const ClassroomUsageStats({
    required this.period,
    required this.totalUsage,
    required this.usageByClassroom,
    required this.usageByType,
    required this.usageByFloor,
    required this.usageByInstitute,
  });
}

/// Тип оптимизации
enum OptimizationType {
  underutilized,
  overloadedType,
  inefficientScheduling,
}

/// Рекомендация по оптимизации
class OptimizationRecommendation {
  final OptimizationType type;
  final String classroom;
  final String description;
  final double potentialSavings;

  const OptimizationRecommendation({
    required this.type,
    required this.classroom,
    required this.description,
    required this.potentialSavings,
  });
}

/// Отчет об использовании
class UsageReport {
  final AnalysisPeriod period;
  final int totalUsage;
  final List<MapEntry<String, int>> topUsedClassrooms;
  final Map<ClassroomType, int> usageByType;
  final Map<int, int> usageByFloor;
  final Map<String, int> usageByInstitute;
  final List<OptimizationRecommendation> recommendations;
  final DateTime generatedAt;

  const UsageReport({
    required this.period,
    required this.totalUsage,
    required this.topUsedClassrooms,
    required this.usageByType,
    required this.usageByFloor,
    required this.usageByInstitute,
    required this.recommendations,
    required this.generatedAt,
  });
}

/// Тип ошибки валидации
enum ValidationErrorType {
  invalidClassroom,
  invalidTime,
  outsideWorkingHours,
  duplicateBooking,
}

/// Ошибка валидации
class ValidationError {
  final ValidationErrorType type;
  final String message;
  final ScheduleEntry? entry;

  const ValidationError({
    required this.type,
    required this.message,
    this.entry,
  });
}

/// Сводка по расписанию
class ScheduleSummary {
  final int totalEntries;
  final int uniqueClassrooms;
  final int uniqueGroups;
  final int uniqueTeachers;
  final int uniqueSubjects;

  const ScheduleSummary({
    required this.totalEntries,
    required this.uniqueClassrooms,
    required this.uniqueGroups,
    required this.uniqueTeachers,
    required this.uniqueSubjects,
  });
}

/// Информация о навигации
class NavigationInfo {
  final String from;
  final String to;
  final List<List<double>> path;
  final double distance;
  final int estimatedTime;
  final int floorChanges;

  const NavigationInfo({
    required this.from,
    required this.to,
    required this.path,
    required this.distance,
    required this.estimatedTime,
    required this.floorChanges,
  });
}
