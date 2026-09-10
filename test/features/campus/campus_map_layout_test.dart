import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/campus/domain/campus_map_layout.dart';

void main() {
  test('keeps stable building identifiers for future campus labels', () {
    final ids = CampusMapLayout.buildings.map((building) => building.id);

    expect(CampusMapLayout.buildings, hasLength(16));
    expect(ids.toSet(), hasLength(16));
    expect(ids.first, 'building-01');
  });

  test('finds a building by a point inside its footprint', () {
    final building = CampusMapLayout.hitTest(const Offset(90, 120));

    expect(building?.id, 'building-01');
  });

  test('does not select roads or empty campus areas', () {
    expect(CampusMapLayout.hitTest(const Offset(600, 350)), isNull);
  });
}
