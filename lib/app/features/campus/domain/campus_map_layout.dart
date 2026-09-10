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
  });

  final String id;
  final int number;
  final List<Offset> footprint;
  final double height;
  final CampusBuildingTone tone;
  final String? name;

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
        Offset(0, 47),
        Offset(245, 42),
        Offset(526, 39),
        Offset(864, 42),
      ],
      width: 10,
    ),
    CampusMapRoad(
      points: [
        Offset(253, 0),
        Offset(253, 150),
        Offset(250, 300),
        Offset(256, 637),
      ],
      width: 12,
    ),
    CampusMapRoad(
      points: [
        Offset(250, 300),
        Offset(413, 298),
        Offset(585, 292),
        Offset(721, 285),
      ],
      width: 11,
    ),
    CampusMapRoad(
      points: [
        Offset(413, 298),
        Offset(379, 319),
        Offset(380, 430),
        Offset(397, 454),
        Offset(432, 457),
      ],
      width: 9,
    ),
    CampusMapRoad(points: [Offset(249, 350), Offset(366, 350)], width: 7),
    CampusMapRoad(points: [Offset(248, 454), Offset(367, 454)], width: 7),
    CampusMapRoad(
      points: [
        Offset(721, 285),
        Offset(788, 283),
        Offset(803, 269),
        Offset(803, 44),
      ],
      width: 10,
    ),
    CampusMapRoad(
      points: [
        Offset(0, 615),
        Offset(288, 612),
        Offset(575, 607),
        Offset(864, 604),
      ],
      width: 14,
    ),
    CampusMapRoad(
      points: [
        Offset(319, 506),
        Offset(343, 565),
        Offset(389, 597),
        Offset(494, 604),
      ],
      width: 6,
    ),
  ];

  static const buildings = <CampusMapBuilding>[
    CampusMapBuilding(
      id: 'building-01',
      number: 1,
      height: 18,
      tone: CampusBuildingTone.utility,
      footprint: [
        Offset(43, 64),
        Offset(123, 62),
        Offset(123, 92),
        Offset(113, 98),
        Offset(113, 239),
        Offset(81, 242),
        Offset(78, 96),
        Offset(43, 96),
      ],
    ),
    CampusMapBuilding(
      id: 'building-02',
      number: 2,
      height: 20,
      tone: CampusBuildingTone.utility,
      footprint: [
        Offset(189, 59),
        Offset(226, 58),
        Offset(228, 150),
        Offset(191, 153),
      ],
    ),
    CampusMapBuilding(
      id: 'building-03',
      number: 3,
      height: 24,
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
      footprint: [
        Offset(525, 210),
        Offset(746, 207),
        Offset(748, 253),
        Offset(527, 258),
      ],
    ),
    CampusMapBuilding(
      id: 'building-06',
      number: 6,
      height: 22,
      tone: CampusBuildingTone.utility,
      footprint: [
        Offset(767, 22),
        Offset(864, 20),
        Offset(864, 57),
        Offset(816, 58),
        Offset(816, 178),
        Offset(786, 181),
        Offset(785, 58),
        Offset(767, 58),
      ],
    ),
    CampusMapBuilding(
      id: 'building-07',
      number: 7,
      height: 25,
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
      footprint: [
        Offset(570, 420),
        Offset(607, 420),
        Offset(611, 570),
        Offset(576, 573),
      ],
    ),
    CampusMapBuilding(
      id: 'building-11',
      number: 11,
      height: 20,
      tone: CampusBuildingTone.residence,
      footprint: [
        Offset(674, 472),
        Offset(789, 470),
        Offset(790, 509),
        Offset(676, 512),
      ],
    ),
    CampusMapBuilding(
      id: 'building-12',
      number: 12,
      height: 13,
      tone: CampusBuildingTone.utility,
      footprint: [
        Offset(18, 8),
        Offset(171, 5),
        Offset(172, 28),
        Offset(20, 32),
      ],
    ),
    CampusMapBuilding(
      id: 'building-13',
      number: 13,
      height: 13,
      tone: CampusBuildingTone.utility,
      footprint: [
        Offset(193, 4),
        Offset(342, 2),
        Offset(343, 28),
        Offset(194, 31),
      ],
    ),
    CampusMapBuilding(
      id: 'building-14',
      number: 14,
      height: 14,
      tone: CampusBuildingTone.utility,
      footprint: [
        Offset(376, 1),
        Offset(559, 0),
        Offset(559, 20),
        Offset(377, 23),
      ],
    ),
    CampusMapBuilding(
      id: 'building-15',
      number: 15,
      height: 14,
      tone: CampusBuildingTone.utility,
      footprint: [
        Offset(589, 1),
        Offset(719, 0),
        Offset(719, 15),
        Offset(590, 18),
      ],
    ),
    CampusMapBuilding(
      id: 'building-16',
      number: 16,
      height: 19,
      tone: CampusBuildingTone.utility,
      footprint: [
        Offset(706, 213),
        Offset(752, 211),
        Offset(753, 345),
        Offset(770, 345),
        Offset(770, 372),
        Offset(711, 374),
        Offset(711, 354),
        Offset(687, 354),
        Offset(687, 315),
        Offset(706, 315),
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
