import 'dart:ui';

class CampusMapBuilding {
  const CampusMapBuilding({
    required this.id,
    required this.number,
    required this.footprint,
    required this.height,
    this.name,
  });

  final String id;
  final int number;
  final List<Offset> footprint;
  final double height;
  final String? name;

  Path get path => Path()..addPolygon(footprint, true);

  Offset get center {
    final bounds = path.getBounds();
    return bounds.center;
  }
}

class CampusMapRoad {
  const CampusMapRoad({required this.points, this.width = 18});

  final List<Offset> points;
  final double width;
}

abstract final class CampusMapLayout {
  static const canvasSize = Size(1000, 780);

  static const greenZones = <List<Offset>>[
    [
      Offset(232, 20),
      Offset(455, 20),
      Offset(478, 44),
      Offset(478, 116),
      Offset(458, 140),
      Offset(232, 140),
      Offset(210, 118),
      Offset(210, 42),
    ],
    [
      Offset(20, 366),
      Offset(205, 366),
      Offset(218, 390),
      Offset(218, 748),
      Offset(20, 748),
    ],
    [
      Offset(445, 545),
      Offset(650, 538),
      Offset(676, 575),
      Offset(648, 625),
      Offset(472, 618),
      Offset(430, 582),
    ],
    [
      Offset(760, 356),
      Offset(968, 350),
      Offset(975, 474),
      Offset(910, 492),
      Offset(824, 462),
      Offset(760, 430),
    ],
    [
      Offset(730, 38),
      Offset(968, 38),
      Offset(980, 176),
      Offset(744, 190),
      Offset(700, 130),
    ],
  ];

  static const roads = <CampusMapRoad>[
    CampusMapRoad(
      points: [Offset(224, 174), Offset(218, 350), Offset(220, 780)],
      width: 20,
    ),
    CampusMapRoad(
      points: [
        Offset(220, 350),
        Offset(474, 346),
        Offset(512, 310),
        Offset(512, 90),
        Offset(670, 90),
      ],
      width: 18,
    ),
    CampusMapRoad(
      points: [Offset(220, 350), Offset(975, 340), Offset(986, 284)],
      width: 19,
    ),
    CampusMapRoad(
      points: [
        Offset(392, 350),
        Offset(394, 505),
        Offset(420, 588),
        Offset(460, 590),
      ],
      width: 14,
    ),
    CampusMapRoad(points: [Offset(220, 442), Offset(382, 442)], width: 12),
    CampusMapRoad(points: [Offset(220, 525), Offset(382, 525)], width: 12),
    CampusMapRoad(points: [Offset(0, 758), Offset(1000, 758)], width: 24),
    CampusMapRoad(
      points: [
        Offset(320, 610),
        Offset(350, 680),
        Offset(420, 725),
        Offset(590, 728),
      ],
      width: 9,
    ),
  ];

  static const buildings = <CampusMapBuilding>[
    CampusMapBuilding(
      id: 'building-01',
      number: 1,
      height: 30,
      footprint: [
        Offset(112, 42),
        Offset(188, 42),
        Offset(188, 174),
        Offset(112, 174),
      ],
    ),
    CampusMapBuilding(
      id: 'building-02',
      number: 2,
      height: 24,
      footprint: [
        Offset(260, 174),
        Offset(338, 174),
        Offset(338, 230),
        Offset(300, 230),
        Offset(300, 286),
        Offset(392, 286),
        Offset(392, 214),
        Offset(438, 214),
        Offset(438, 334),
        Offset(260, 334),
      ],
    ),
    CampusMapBuilding(
      id: 'building-03',
      number: 3,
      height: 20,
      footprint: [
        Offset(480, 184),
        Offset(526, 184),
        Offset(526, 284),
        Offset(480, 284),
      ],
    ),
    CampusMapBuilding(
      id: 'building-04',
      number: 4,
      height: 18,
      footprint: [
        Offset(650, 266),
        Offset(920, 258),
        Offset(924, 306),
        Offset(652, 318),
      ],
    ),
    CampusMapBuilding(
      id: 'building-05',
      number: 5,
      height: 28,
      footprint: [
        Offset(422, 416),
        Offset(655, 406),
        Offset(657, 490),
        Offset(422, 504),
      ],
    ),
    CampusMapBuilding(
      id: 'building-06',
      number: 6,
      height: 32,
      footprint: [
        Offset(252, 482),
        Offset(314, 478),
        Offset(320, 748),
        Offset(252, 748),
      ],
    ),
    CampusMapBuilding(
      id: 'building-07',
      number: 7,
      height: 26,
      footprint: [
        Offset(422, 626),
        Offset(628, 626),
        Offset(628, 650),
        Offset(716, 650),
        Offset(716, 704),
        Offset(606, 704),
        Offset(606, 728),
        Offset(422, 728),
      ],
    ),
    CampusMapBuilding(
      id: 'building-08',
      number: 8,
      height: 34,
      footprint: [
        Offset(714, 544),
        Offset(762, 544),
        Offset(762, 748),
        Offset(714, 748),
      ],
    ),
    CampusMapBuilding(
      id: 'building-09',
      number: 9,
      height: 19,
      footprint: [
        Offset(848, 642),
        Offset(968, 642),
        Offset(968, 704),
        Offset(848, 704),
      ],
    ),
    CampusMapBuilding(
      id: 'building-10',
      number: 10,
      height: 22,
      footprint: [
        Offset(812, 410),
        Offset(848, 410),
        Offset(848, 450),
        Offset(920, 450),
        Offset(920, 398),
        Offset(952, 398),
        Offset(952, 510),
        Offset(824, 510),
        Offset(824, 474),
        Offset(792, 474),
        Offset(792, 430),
        Offset(812, 430),
      ],
    ),
    CampusMapBuilding(
      id: 'building-11',
      number: 11,
      height: 18,
      footprint: [
        Offset(518, 136),
        Offset(566, 136),
        Offset(566, 250),
        Offset(518, 250),
      ],
    ),
  ];

  static CampusMapBuilding? hitTest(Offset point) {
    for (final building in buildings.reversed) {
      if (building.path.contains(point)) return building;
    }
    return null;
  }
}
