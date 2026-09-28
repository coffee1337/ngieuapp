import 'package:ngieuapp/app/features/schedule/domain/utils/floor_utils.dart';

class CampusInstitute {
  const CampusInstitute({
    required this.name,
    required this.shortName,
    required this.roomPrefix,
    required this.maxFloor,
  });

  final String name;
  final String shortName;
  final String roomPrefix;
  final int maxFloor;
}

class CampusRoomResult {
  const CampusRoomResult({
    required this.query,
    required this.institute,
    required this.floor,
  });

  final String query;
  final CampusInstitute? institute;
  final int? floor;

  bool get isRecognized => institute != null;
}

abstract final class CampusCatalog {
  static const universityName =
      'Нижегородский государственный '
      'инженерно-экономический университет';
  static const mainCampusAddress =
      'Нижегородская область, г. Княгинино, '
      'ул. Октябрьская, д. 22 А';
  static const phone = '+7 (83166) 4-15-50';
  static const email = 'ngieu_vuz@mail.52gov.ru';
  static const website = 'ngieu.ru';

  static const institutes = <CampusInstitute>[
    CampusInstitute(
      name: 'Институт экономики и управления',
      shortName: 'ИЭУ',
      roomPrefix: '1xx',
      maxFloor: 4,
    ),
    CampusInstitute(
      name:
          'Институт информационных технологий '
          'и систем связи',
      shortName: 'ИИТиСС',
      roomPrefix: '2xx',
      maxFloor: 3,
    ),
    CampusInstitute(
      name: 'Инженерный институт',
      shortName: 'ИИ',
      roomPrefix: '3xx',
      maxFloor: 2,
    ),
  ];

  static CampusRoomResult resolveRoom(String rawQuery) {
    final query = rawQuery.trim();
    final instituteName = FloorUtils.getInstituteFromRoomNumber(query);
    final institute = instituteName == null
        ? null
        : institutes.firstWhere((item) => item.name == instituteName);
    final floor = FloorUtils.getFloorFromRoomNumber(query);
    if (institute == null || floor == null || floor > institute.maxFloor) {
      return CampusRoomResult(query: query, institute: null, floor: null);
    }
    return CampusRoomResult(
      query: query,
      institute: institute,
      floor: floor,
    );
  }

  static List<CampusInstitute> searchInstitutes(String rawQuery) {
    final query = rawQuery.trim().toLowerCase();
    if (query.isEmpty || RegExp(r'^\d').hasMatch(query)) return institutes;

    return institutes
        .where(
          (institute) =>
              institute.name.toLowerCase().contains(query) ||
              institute.shortName.toLowerCase().contains(query) ||
              institute.roomPrefix.toLowerCase().contains(query),
        )
        .toList(growable: false);
  }
}
