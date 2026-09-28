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
    final neighbors = <String, List<CampusRouteEdge>>{};
    for (final edge in CampusMapLayout.routeEdges) {
      neighbors.putIfAbsent(edge.from, () => []).add(edge);
      neighbors.putIfAbsent(edge.to, () => []).add(edge);
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
      for (final edge in neighbors[current] ?? const <CampusRouteEdge>[]) {
        final neighbor = edge.from == current ? edge.to : edge.from;
        if (!unvisited.contains(neighbor)) continue;
        final candidate = best + _edgeLength(
          edge,
          from: current,
          to: neighbor,
          nodes: nodes,
        );
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
    final routeNodeIds = nodeIds.reversed.toList(growable: false);
    final points = <Offset>[from.position, nodes[routeNodeIds.first]!.position];
    for (var index = 0; index < routeNodeIds.length - 1; index++) {
      final current = routeNodeIds[index];
      final next = routeNodeIds[index + 1];
      final edge = _edgeBetween(current, next, neighbors);
      if (edge == null) return const [];
      points.addAll(
        _pointsForEdge(
          edge,
          from: current,
          to: next,
          nodes: nodes,
        ).skip(1),
      );
    }
    points.add(to.position);
    return _removeConsecutiveDuplicates(points);
  }

  CampusRouteEdge? _edgeBetween(
    String from,
    String to,
    Map<String, List<CampusRouteEdge>> neighbors,
  ) {
    for (final edge in neighbors[from] ?? const <CampusRouteEdge>[]) {
      if ((edge.from == from && edge.to == to) ||
          (edge.from == to && edge.to == from)) {
        return edge;
      }
    }
    return null;
  }

  double _edgeLength(
    CampusRouteEdge edge, {
    required String from,
    required String to,
    required Map<String, CampusRouteNode> nodes,
  }) {
    final points = _pointsForEdge(edge, from: from, to: to, nodes: nodes);
    var length = 0.0;
    for (var index = 1; index < points.length; index++) {
      length += _distance(points[index - 1], points[index]);
    }
    return length;
  }

  List<Offset> _pointsForEdge(
    CampusRouteEdge edge, {
    required String from,
    required String to,
    required Map<String, CampusRouteNode> nodes,
  }) {
    final isForward = edge.from == from && edge.to == to;
    final via = isForward ? edge.via : edge.via.reversed;
    return [nodes[from]!.position, ...via, nodes[to]!.position];
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
