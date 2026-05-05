import 'dart:math';

/// Утилиты для работы с этажами и аудиториями
class FloorUtils {
  /// Получить номер этажа из аудитории
  static int getFloorNumber(String classroom) {
    // Извлекаем номер этажа из номера аудитории
    final match = RegExp(r'(\d+)').firstMatch(classroom);
    if (match != null) {
      final roomNumber = int.tryParse(match.group(1) ?? '') ?? 0;
      if (roomNumber >= 100 && roomNumber <= 999) {
        return roomNumber ~/ 100;
      } else if (roomNumber >= 1 && roomNumber <= 9) {
        return 1;
      }
    }
    return 1; // По умолчанию первый этаж
  }

  /// Получить корпус из аудитории
  static String getBuilding(String classroom) {
    if (classroom.startsWith('А')) return 'А';
    if (classroom.startsWith('Б')) return 'Б';
    if (classroom.startsWith('В')) return 'В';
    if (classroom.startsWith('Г')) return 'Г';
    return 'А'; // По умолчанию корпус А
  }

  /// Получить информацию о местоположении аудитории
  static Map<String, dynamic> getRoomLocationInfo(String classroom) {
    final floor = getFloorNumber(classroom);
    final building = getBuilding(classroom);
    
    return {
      'floor': floor,
      'building': building,
      'wing': _getWing(classroom),
      'section': _getSection(classroom),
    };
  }

  /// Получить крыло здания
  static String _getWing(String classroom) {
    if (classroom.contains('л')) return 'левое';
    if (classroom.contains('п')) return 'правое';
    return 'центральное';
  }

  /// Получить секцию
  static String _getSection(String classroom) {
    if (classroom.contains('а')) return 'А';
    if (classroom.contains('б')) return 'Б';
    if (classroom.contains('в')) return 'В';
    return '';
  }

  /// Рассчитать расстояние между аудиториями
  static double calculateDistance(String from, String to) {
    final fromInfo = getRoomLocationInfo(from);
    final toInfo = getRoomLocationInfo(to);
    
    final floorDiff = (fromInfo['floor'] as int - toInfo['floor'] as int).abs();
    final buildingDiff = fromInfo['building'] != toInfo['building'] ? 50.0 : 0.0;
    
    return floorDiff * 10.0 + buildingDiff;
  }

  /// Получить время перехода между аудиториями
  static Duration getTransitionTime(String from, String to) {
    final distance = calculateDistance(from, to);
    return Duration(seconds: (distance * 10).round());
  }

  /// Проверить доступность аудитории для людей с ограниченными возможностями
  static bool isAccessible(String classroom) {
    final floor = getFloorNumber(classroom);
    return floor == 1; // Только первый этаж доступен
  }

  /// Получить ближайшие доступные аудитории
  static List<String> getNearbyAccessibleRooms(String classroom) {
    final building = getBuilding(classroom);
    final floor = getFloorNumber(classroom);
    
    final rooms = <String>[];
    for (int i = 1; i <= 20; i++) {
      final room = '${building}${floor.toString().padLeft(2, '0')}${i.toString().padLeft(2, '0')}';
      if (isAccessible(room)) {
        rooms.add(room);
      }
    }
    
    return rooms.take(5).toList();
  }

  /// Получить информацию о вместимости аудитории
  static int getRoomCapacity(String classroom) {
    final floor = getFloorNumber(classroom);
    if (floor == 1) return 30; // Лекционные аудитории
    if (floor == 2) return 20; // Семинарские аудитории
    return 25; // Стандартные аудитории
  }

  /// Получить тип аудитории
  static String getRoomType(String classroom) {
    if (classroom.contains('лк')) return 'Лекционная';
    if (classroom.contains('лаб')) return 'Лабораторная';
    if (classroom.contains('каб')) return 'Кабинет';
    return 'Аудитория';
  }

  /// Проверить наличие оборудования в аудитории
  static bool hasEquipment(String classroom, String equipment) {
    final roomType = getRoomType(classroom);
    
    switch (equipment.toLowerCase()) {
      case 'проектор':
        return roomType == 'Лекционная';
      case 'компьютер':
        return roomType == 'Лабораторная';
      case 'доска':
        return true;
      default:
        return false;
    }
  }

  /// Получить список оборудования в аудитории
  static List<String> getRoomEquipment(String classroom) {
    final equipment = <String>[];
    final roomType = getRoomType(classroom);
    
    if (roomType == 'Лекционная') {
      equipment.addAll(['Проектор', 'Микрофон', 'Доска']);
    } else if (roomType == 'Лабораторная') {
      equipment.addAll(['Компьютеры', 'Доска']);
    } else {
      equipment.add('Доска');
    }
    
    return equipment;
  }

  /// Получить рекомендуемые аудитории для группы
  static List<String> getRecommendedRooms(int groupSize, String roomType) {
    final rooms = <String>[];
    final buildings = ['А', 'Б', 'В', 'Г'];
    
    for (final building in buildings) {
      for (int floor = 1; floor <= 4; floor++) {
        for (int room = 1; room <= 20; room++) {
          final roomNumber = '${building}${floor.toString().padLeft(2, '0')}${room.toString().padLeft(2, '0')}';
          final capacity = getRoomCapacity(roomNumber);
          
          if (capacity >= groupSize && getRoomType(roomNumber) == roomType) {
            rooms.add(roomNumber);
          }
        }
      }
    }
    
    return rooms.take(10).toList();
  }

  /// Получить координаты аудитории для навигации
  static List<double> getRoomCoordinates(String classroom) {
    final building = getBuilding(classroom);
    final floor = getFloorNumber(classroom);
    
    final buildingCoords = <String, List<double>>{
      'А': <double>[0.0, 0.0],
      'Б': <double>[100.0, 0.0],
      'В': <double>[0.0, 100.0],
      'Г': <double>[100.0, 100.0],
    };
    
    final baseCoords = buildingCoords[building] ?? <double>[0.0, 0.0];
    final floorOffset = (floor - 1) * 25.0;
    
    return <double>[
      baseCoords[0] + floorOffset,
      baseCoords[1] + floorOffset,
    ];
  }

  /// Получить путь между аудиториями
  static List<List<double>> getPathBetweenRooms(String from, String to) {
    final fromCoords = getRoomCoordinates(from);
    final toCoords = getRoomCoordinates(to);
    
    return <List<double>>[
      fromCoords,
      <double>[(fromCoords[0] + toCoords[0]) / 2, (fromCoords[1] + toCoords[1]) / 2],
      toCoords,
    ];
  }

  /// Получить информацию о навигации
  static Map<String, dynamic> getNavigationInfo(String from, String to) {
    final path = getPathBetweenRooms(from);
    final distance = calculateDistance(from, to);
    final time = getTransitionTime(from, to);
    
    return {
      'from': from,
      'to': to,
      'path': path,
      'distance': distance,
      'time': time.inSeconds,
    };
  }

  /// Получить аудитории на этаже
  static List<String> getRoomsOnFloor(String building, int floor) {
    final rooms = <String>[];
    
    for (int i = 1; i <= 20; i++) {
      final roomNumber = '${building}${floor.toString().padLeft(2, '0')}${i.toString().padLeft(2, '0')}';
      rooms.add(roomNumber);
    }
    
    return rooms;
  }

  /// Получить загрузку этажа
  static Map<String, int> getFloorLoad(String building, int floor, List<String> occupiedRooms) {
    final allRooms = getRoomsOnFloor(building, floor);
    final occupied = occupiedRooms.where((room) => 
      room.startsWith(building) && getFloorNumber(room) == floor
    ).toList();
    
    return {
      'total': allRooms.length,
      'occupied': occupied.length,
      'free': allRooms.length - occupied.length,
    };
  }

  /// Получить оптимальный маршрут для посещения нескольких аудиторий
  static List<String> getOptimalRoute(List<String> rooms) {
    if (rooms.length <= 1) return rooms;
    
    final route = <String>[rooms.first];
    final remaining = List<String>.from(rooms)..removeAt(0);
    
    while (remaining.isNotEmpty) {
      final current = route.last;
      String? nearest;
      double minDistance = double.infinity;
      
      for (final room in remaining) {
        final distance = calculateDistance(current, room);
        if (distance < minDistance) {
          minDistance = distance;
          nearest = room;
        }
      }
      
      if (nearest != null) {
        route.add(nearest);
        remaining.remove(nearest);
      } else {
        break;
      }
    }
    
    return route;
  }

  /// Получить статистику по аудиториям
  static Map<String, dynamic> getRoomStatistics(List<String> rooms) {
    final buildings = <String, int>{};
    final floors = <int, int>{};
    final types = <String, int>{};
    
    for (final room in rooms) {
      final building = getBuilding(room);
      final floor = getFloorNumber(room);
      final type = getRoomType(room);
      
      buildings[building] = (buildings[building] ?? 0) + 1;
      floors[floor] = (floors[floor] ?? 0) + 1;
      types[type] = (types[type] ?? 0) + 1;
    }
    
    return {
      'total': rooms.length,
      'buildings': buildings,
      'floors': floors,
      'types': types,
    };
  }

  /// Проверить корректность номера аудитории
  static bool isValidRoomNumber(String classroom) {
    final pattern = RegExp(r'^[А-ВГ]\d{3,4}$');
    return pattern.hasMatch(classroom);
  }

  /// Отформатировать номер аудитории
  static String formatRoomNumber(String classroom) {
    if (!isValidRoomNumber(classroom)) return classroom;
    
    final building = getBuilding(classroom);
    final match = RegExp(r'(\d+)').firstMatch(classroom);
    final number = match?.group(1) ?? '';
    
    return '$building${number.padLeft(3, '0')}';
  }

  /// Получить похожие номера аудиторий
  static List<String> getSimilarRooms(String classroom) {
    final building = getBuilding(classroom);
    final floor = getFloorNumber(classroom);
    final similar = <String>[];
    
    for (int i = 1; i <= 20; i++) {
      final room = '${building}${floor.toString().padLeft(2, '0')}${i.toString().padLeft(2, '0')}';
      if (room != classroom) {
        similar.add(room);
      }
    }
    
    return similar.take(5).toList();
  }
}
