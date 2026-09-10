import 'dart:ui';

enum CampusBuildingTone { academic, residence, utility }

class CampusMapBuilding {
  const CampusMapBuilding({
    required this.id,
    required this.number,
    required this.footprint,
    required this.height,
    this.tone = CampusBuildingTone.academic,
    this.name,
    this.labelAnchor,
  });

  final String id;
  final int number;
  final List<Offset> footprint;
  final double height;
  final CampusBuildingTone tone;
  final String? name;
  final Offset? labelAnchor;

  Path get path => Path()..addPolygon(footprint, true);

  Offset get center => path.getBounds().center;
}

class CampusMapRoad {
  const CampusMapRoad({required this.points, this.width = 12});

  final List<Offset> points;
  final double width;
}

/// Vector tracing of the campus reference plan supplied by the user.
///
/// Coordinates intentionally match the 864 × 637 reference image. Keeping
/// every building as an independent shape lets us attach verified names,
/// entrances and rooms without redrawing the map later.
abstract final class CampusMapLayout {
  static const canvasSize = Size(864, 637);

  static const greenZones = <List<Offset>>[
    [
      Offset(248, 49),
      Offset(389, 49),
      Offset(404, 58),
      Offset(404, 109),
      Offset(394, 121),
      Offset(259, 123),
      Offset(248, 113),
    ],
    [
      Offset(114, 342),
      Offset(128, 320),
      Offset(163, 312),
      Offset(198, 321),
      Offset(222, 349),
      Offset(241, 402),
      Offset(241, 527),
      Offset(225, 568),
      Offset(197, 586),
      Offset(159, 584),
      Offset(127, 560),
      Offset(113, 517),
      Offset(111, 399),
    ],
    [
      Offset(443, 29),
      Offset(622, 28),
      Offset(647, 42),
      Offset(634, 71),
      Offset(574, 81),
      Offset(503, 69),
      Offset(455, 76),
      Offset(434, 57),
    ],
    [
      Offset(385, 397),
      Offset(438, 388),
      Offset(491, 401),
      Offset(563, 393),
      Offset(591, 417),
      Offset(565, 460),
      Offset(506, 468),
      Offset(440, 453),
      Offset(397, 463),
      Offset(377, 438),
    ],
    [
      Offset(596, 477),
      Offset(658, 459),
      Offset(718, 467),
      Offset(752, 498),
      Offset(747, 569),
      Offset(701, 593),
      Offset(638, 582),
      Offset(600, 548),
    ],
    [
      Offset(96, 185),
      Offset(127, 174),
      Offset(145, 194),
      Offset(136, 242),
      Offset(107, 253),
      Offset(90, 227),
    ],
  ];

  static const roads = <CampusMapRoad>[
    CampusMapRoad(
      points: [
        Offset(252, -12),
        Offset(252, 142),
        Offset(251, 286),
        Offset(252, 365),
        Offset(255, 649),
      ],
      width: 8,
    ),
    CampusMapRoad(
      points: [
        Offset(252, 300),
        Offset(360, 299),
        Offset(420, 298),
        Offset(585, 292),
        Offset(720, 285),
        Offset(780, 283),
        Offset(801, 267),
        Offset(803, 210),
        Offset(803, 44),
      ],
      width: 8,
    ),
    CampusMapRoad(
      points: [
        Offset(408, 299),
        Offset(376, 314),
        Offset(365, 336),
        Offset(365, 408),
        Offset(376, 445),
        Offset(401, 457),
        Offset(433, 458),
      ],
      width: 7,
    ),
    CampusMapRoad(
      points: [Offset(252, 352), Offset(365, 352)],
      width: 5,
    ),
    CampusMapRoad(
      points: [Offset(253, 452), Offset(369, 452)],
      width: 5,
    ),
    CampusMapRoad(
      points: [
        Offset(-12, 617),
        Offset(175, 615),
        Offset(288, 612),
        Offset(575, 607),
        Offset(876, 604),
      ],
      width: 9,
    ),
    CampusMapRoad(
      points: [
        Offset(318, 506),
        Offset(329, 545),
        Offset(347, 571),
        Offset(389, 597),
        Offset(494, 604),
      ],
      width: 4,
    ),
  ];

  static const buildings = <CampusMapBuilding>[
    CampusMapBuilding(
      id: 'building-03',
      number: 3,
      height: 24,
      name: 'Инженерный институт',
      labelAnchor: Offset(329, 286),
      footprint: [
        Offset(269, 156),
        Offset(317, 154),
        Offset(317, 204),
        Offset(350, 204),
        Offset(350, 183),
        Offset(387, 181),
        Offset(389, 267),
        Offset(271, 270),
      ],
    ),
    CampusMapBuilding(
      id: 'building-04',
      number: 4,
      height: 20,
      tone: CampusBuildingTone.utility,
      name: 'Ангар-склад',
      labelAnchor: Offset(467, 253),
      footprint: [
        Offset(445, 150),
        Offset(487, 148),
        Offset(489, 235),
        Offset(447, 238),
      ],
    ),
    CampusMapBuilding(
      id: 'building-05',
      number: 5,
      height: 17,
      tone: CampusBuildingTone.utility,
      name: 'Учебный корпус',
      labelAnchor: Offset(636, 270),
      footprint: [
        Offset(525, 210),
        Offset(746, 207),
        Offset(748, 253),
        Offset(527, 258),
      ],
    ),
    CampusMapBuilding(
      id: 'building-07',
      number: 7,
      height: 25,
      name: 'Институт информационных технологий и систем связи',
      labelAnchor: Offset(458, 413),
      footprint: [
        Offset(380, 326),
        Offset(532, 323),
        Offset(535, 391),
        Offset(381, 396),
      ],
    ),
    CampusMapBuilding(
      id: 'building-08',
      number: 8,
      height: 29,
      tone: CampusBuildingTone.residence,
      name: 'Общежитие №1',
      labelAnchor: Offset(296, 606),
      footprint: [
        Offset(269, 377),
        Offset(310, 375),
        Offset(319, 589),
        Offset(278, 592),
      ],
    ),
    CampusMapBuilding(
      id: 'building-09',
      number: 9,
      height: 27,
      name: 'Главный корпус НГИЭУ',
      labelAnchor: Offset(469, 551),
      footprint: [
        Offset(389, 470),
        Offset(568, 467),
        Offset(570, 497),
        Offset(522, 498),
        Offset(522, 530),
        Offset(390, 532),
      ],
    ),
    CampusMapBuilding(
      id: 'building-10',
      number: 10,
      height: 31,
      name: 'Институт педагогики · Институт экономики и управления',
      labelAnchor: Offset(625, 548),
      footprint: [
        Offset(570, 420),
        Offset(607, 420),
        Offset(611, 570),
        Offset(576, 573),
      ],
    ),
    CampusMapBuilding(
      id: 'building-12',
      number: 12,
      height: 12,
      tone: CampusBuildingTone.utility,
      name: 'Лыжная база',
      labelAnchor: Offset(341, 149),
      footprint: [
        Offset(294, 125),
        Offset(383, 123),
        Offset(384, 145),
        Offset(295, 148),
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
