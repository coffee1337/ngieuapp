import 'dart:math' as math;
import 'dart:ui';

import 'package:ngieuapp/app/features/campus/domain/campus_map_layout.dart';

class CampusRoutePlanner {
  const CampusRoutePlanner();

  List<Offset> route({
    required String fromBuildingId,
    required String toBuildingId,
  }) {
    if (fromBuildingId == toBuildingId) return const [];
    final from = CampusMapLayout.entranceForBuilding(fromBuildingId);
    final to = CampusMapLayout.entranceForBuilding(toBuildingId);
    if (from == null || to == null) return const [];

    final nodes = {
      for (final node in CampusMapLayout.routeNodes) node.id: node,
    };
    final neighbors = <String, List<String>>{};
    for (final edge in CampusMapLayout.routeEdges) {
      neighbors.putIfAbsent(edge.from, () => []).add(edge.to);
      neighbors.putIfAbsent(edge.to, () => []).add(edge.from);
    }

    final distance = {for (final id in nodes.keys) id: double.infinity};
    final previous = <String, String>{};
    final unvisited = nodes.keys.toSet();
    distance[from.routeNodeId] = 0;

    while (unvisited.isNotEmpty) {
      String? current;
      var best = double.infinity;
      for (final id in unvisited) {
        final candidate = distance[id] ?? double.infinity;
        if (candidate < best) {
          current = id;
          best = candidate;
        }
      }
      if (current == null || best == double.infinity) break;
      if (current == to.routeNodeId) break;
      unvisited.remove(current);
      for (final neighbor in neighbors[current] ?? const <String>[]) {
        if (!unvisited.contains(neighbor)) continue;
        final candidate =
            best +
            _distance(nodes[current]!.position, nodes[neighbor]!.position);
        if (candidate < distance[neighbor]!) {
          distance[neighbor] = candidate;
          previous[neighbor] = current;
        }
      }
    }

    if (distance[to.routeNodeId] == double.infinity) return const [];
    final nodeIds = <String>[to.routeNodeId];
    while (nodeIds.last != from.routeNodeId) {
      final parent = previous[nodeIds.last];
      if (parent == null) return const [];
      nodeIds.add(parent);
    }
    final points = <Offset>[
      from.position,
      ...nodeIds.reversed.map((id) => nodes[id]!.position),
      to.position,
    ];
    return _removeConsecutiveDuplicates(points);
  }

  double _distance(Offset a, Offset b) =>
      math.sqrt(math.pow(a.dx - b.dx, 2) + math.pow(a.dy - b.dy, 2));

  List<Offset> _removeConsecutiveDuplicates(List<Offset> points) {
    final result = <Offset>[];
    for (final point in points) {
      if (result.isEmpty || result.last != point) result.add(point);
    }
    return result;
  }
}
