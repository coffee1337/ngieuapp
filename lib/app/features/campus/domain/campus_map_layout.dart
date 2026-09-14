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

class CampusMapEntrance {
  const CampusMapEntrance({
    required this.id,
    required this.buildingId,
    required this.position,
    required this.routeNodeId,
  });

  final String id;
  final String buildingId;
  final Offset position;
  final String routeNodeId;
}

class CampusRouteNode {
  const CampusRouteNode({required this.id, required this.position});

  final String id;
  final Offset position;
}

class CampusRouteEdge {
  const CampusRouteEdge(this.from, this.to);

  final String from;
  final String to;
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
    CampusMapRoad(points: [Offset(252, 352), Offset(365, 352)], width: 5),
    CampusMapRoad(points: [Offset(253, 452), Offset(369, 452)], width: 5),
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

  /// Approximate public entrances. Their positions are isolated from building
  /// geometry so confirmed entrance data can be corrected independently.
  static const entrances = <CampusMapEntrance>[
    CampusMapEntrance(
      id: 'entrance-03',
      buildingId: 'building-03',
      position: Offset(329, 269),
      routeNodeId: 'entry-03',
    ),
    CampusMapEntrance(
      id: 'entrance-04',
      buildingId: 'building-04',
      position: Offset(468, 237),
      routeNodeId: 'entry-04',
    ),
    CampusMapEntrance(
      id: 'entrance-05',
      buildingId: 'building-05',
      position: Offset(636, 255),
      routeNodeId: 'entry-05',
    ),
    CampusMapEntrance(
      id: 'entrance-07',
      buildingId: 'building-07',
      position: Offset(405, 395),
      routeNodeId: 'entry-07',
    ),
    CampusMapEntrance(
      id: 'entrance-08',
      buildingId: 'building-08',
      position: Offset(317, 505),
      routeNodeId: 'entry-08',
    ),
    CampusMapEntrance(
      id: 'entrance-09',
      buildingId: 'building-09',
      position: Offset(433, 469),
      routeNodeId: 'entry-09',
    ),
    CampusMapEntrance(
      id: 'entrance-10',
      buildingId: 'building-10',
      position: Offset(594, 573),
      routeNodeId: 'entry-10',
    ),
    CampusMapEntrance(
      id: 'entrance-12',
      buildingId: 'building-12',
      position: Offset(294, 136),
      routeNodeId: 'entry-12',
    ),
  ];

  /// Pedestrian graph following the paths drawn on the supplied campus plan.
  static const routeNodes = <CampusRouteNode>[
    CampusRouteNode(id: 'north', position: Offset(252, 142)),
    CampusRouteNode(id: 'center-west', position: Offset(252, 299)),
    CampusRouteNode(id: 'center', position: Offset(408, 299)),
    CampusRouteNode(id: 'center-east', position: Offset(585, 292)),
    CampusRouteNode(id: 'east', position: Offset(780, 283)),
    CampusRouteNode(id: 'east-north', position: Offset(803, 210)),
    CampusRouteNode(id: 'inner-upper', position: Offset(376, 314)),
    CampusRouteNode(id: 'inner-mid', position: Offset(365, 408)),
    CampusRouteNode(id: 'inner-lower', position: Offset(376, 445)),
    CampusRouteNode(id: 'inner-gate', position: Offset(433, 458)),
    CampusRouteNode(id: 'west-mid', position: Offset(252, 352)),
    CampusRouteNode(id: 'west-lower', position: Offset(252, 452)),
    CampusRouteNode(id: 'dorm-walk', position: Offset(318, 506)),
    CampusRouteNode(id: 'lower-one', position: Offset(329, 545)),
    CampusRouteNode(id: 'lower-two', position: Offset(347, 571)),
    CampusRouteNode(id: 'lower-three', position: Offset(389, 597)),
    CampusRouteNode(id: 'lower-four', position: Offset(494, 604)),
    CampusRouteNode(id: 'bottom-east', position: Offset(575, 607)),
    CampusRouteNode(id: 'entry-03', position: Offset(329, 286)),
    CampusRouteNode(id: 'entry-04', position: Offset(468, 292)),
    CampusRouteNode(id: 'entry-05', position: Offset(636, 289)),
    CampusRouteNode(id: 'entry-07', position: Offset(405, 421)),
    CampusRouteNode(id: 'entry-08', position: Offset(318, 506)),
    CampusRouteNode(id: 'entry-09', position: Offset(433, 458)),
    CampusRouteNode(id: 'entry-10', position: Offset(575, 607)),
    CampusRouteNode(id: 'entry-12', position: Offset(252, 142)),
  ];

  static const routeEdges = <CampusRouteEdge>[
    CampusRouteEdge('north', 'center-west'),
    CampusRouteEdge('center-west', 'center'),
    CampusRouteEdge('center', 'center-east'),
    CampusRouteEdge('center-east', 'east'),
    CampusRouteEdge('east', 'east-north'),
    CampusRouteEdge('center', 'inner-upper'),
    CampusRouteEdge('inner-upper', 'inner-mid'),
    CampusRouteEdge('inner-mid', 'inner-lower'),
    CampusRouteEdge('inner-lower', 'inner-gate'),
    CampusRouteEdge('center-west', 'west-mid'),
    CampusRouteEdge('west-mid', 'west-lower'),
    CampusRouteEdge('west-lower', 'inner-lower'),
    CampusRouteEdge('west-lower', 'dorm-walk'),
    CampusRouteEdge('dorm-walk', 'lower-one'),
    CampusRouteEdge('lower-one', 'lower-two'),
    CampusRouteEdge('lower-two', 'lower-three'),
    CampusRouteEdge('lower-three', 'lower-four'),
    CampusRouteEdge('lower-four', 'bottom-east'),
    CampusRouteEdge('entry-03', 'center-west'),
    CampusRouteEdge('entry-03', 'center'),
    CampusRouteEdge('entry-04', 'center'),
    CampusRouteEdge('entry-04', 'center-east'),
    CampusRouteEdge('entry-05', 'center-east'),
    CampusRouteEdge('entry-05', 'east'),
    CampusRouteEdge('entry-07', 'inner-mid'),
    CampusRouteEdge('entry-07', 'inner-gate'),
    CampusRouteEdge('entry-08', 'dorm-walk'),
    CampusRouteEdge('entry-09', 'inner-gate'),
    CampusRouteEdge('entry-10', 'bottom-east'),
    CampusRouteEdge('entry-12', 'north'),
  ];

  static CampusMapBuilding? buildingById(String id) {
    for (final building in buildings) {
      if (building.id == id) return building;
    }
    return null;
  }

  static CampusMapEntrance? entranceForBuilding(String buildingId) {
    for (final entrance in entrances) {
      if (entrance.buildingId == buildingId) return entrance;
    }
    return null;
  }

  static CampusMapBuilding? hitTest(Offset point) {
    for (final building in buildings.reversed) {
      if (building.path.contains(point)) return building;
    }
    return null;
  }
}
