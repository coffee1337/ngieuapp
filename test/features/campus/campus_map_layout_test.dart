import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/campus/domain/campus_map_layout.dart';

void main() {
  test('keeps stable building identifiers for future campus labels', () {
    final ids = CampusMapLayout.buildings.map((building) => building.id);

    expect(CampusMapLayout.buildings, hasLength(8));
    expect(ids.toSet(), hasLength(8));
    expect(ids.toList(), [
      'building-03',
      'building-04',
      'building-05',
      'building-07',
      'building-08',
      'building-09',
      'building-10',
      'building-12',
    ]);
    expect(
      CampusMapLayout.buildings.every(
        (building) => building.name?.isNotEmpty ?? false,
      ),
      isTrue,
    );
  });

  test('finds a building by a point inside its footprint', () {
    final building = CampusMapLayout.hitTest(const Offset(290, 180));

    expect(building?.id, 'building-03');
  });

  test('does not select roads or empty campus areas', () {
    expect(CampusMapLayout.hitTest(const Offset(600, 350)), isNull);
  });

  test('keeps only the compact campus road network', () {
    expect(CampusMapLayout.roads, hasLength(7));
    expect(
      CampusMapLayout.roads.every(
        (road) => road.points.length >= 2 && road.width >= 4 && road.width <= 9,
      ),
      isTrue,
    );
    expect(
      CampusMapLayout.roads.any(
        (road) => road.points.every((point) => point.dy < 60),
      ),
      isFalse,
    );
  });
}
