import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/campus/domain/campus_map_layout.dart';
import 'package:ngieuapp/app/features/campus/domain/campus_route_planner.dart';

void main() {
  const planner = CampusRoutePlanner();

  test('builds an offline path between distant campus buildings', () {
    final route = planner.route(
      fromBuildingId: 'building-08',
      toBuildingId: 'building-05',
    );

    expect(route.length, greaterThan(3));
    expect(
      route.first,
      CampusMapLayout.entranceForBuilding('building-08')!.position,
    );
    expect(
      route.last,
      CampusMapLayout.entranceForBuilding('building-05')!.position,
    );
  });

  test('every mapped building has a reachable entrance', () {
    for (final building in CampusMapLayout.buildings) {
      final entrance = CampusMapLayout.entranceForBuilding(building.id);
      expect(entrance, isNotNull, reason: building.id);
      if (building.id == 'building-09') continue;
      expect(
        planner.route(fromBuildingId: 'building-09', toBuildingId: building.id),
        isNotEmpty,
        reason: building.id,
      );
    }
  });

  test('does not draw a route to the same building', () {
    expect(
      planner.route(fromBuildingId: 'building-09', toBuildingId: 'building-09'),
      isEmpty,
    );
  });
}
