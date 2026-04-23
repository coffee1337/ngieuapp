import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../domain/actor.dart';

class ActorsApiDataSource {
  ActorsApiDataSource(this._dio);
  final Dio _dio;

  Future<List<Actor>> loadStudentGroups() async {
    final raw = await rootBundle.loadString('assets/json/student.json');
    final list = jsonDecode(raw) as List;
    return list
        .whereType<Map<String, dynamic>>()
        .map(Actor.fromStudentJson)
        .toList();
  }

  Future<List<Actor>> loadTeachers() async {
    final raw = await rootBundle.loadString('assets/json/teachers.json');
    final list = jsonDecode(raw) as List;
    return list
        .whereType<Map<String, dynamic>>()
        .map(Actor.fromTeacherJson)
        .toList();
  }

  Future<List<Actor>> fetchDepartments({CancelToken? ct}) async {
    final resp = await _dio.get<dynamic>(
      'Departments/Get',
      queryParameters: {'isStudent': false},
      cancelToken: ct,
    );
    final data = resp.data;
    final List raw = switch (data) {
      List l => l,
      Map m when m['data'] is List => m['data'] as List,
      _ => const [],
    };
    return raw.whereType<Map<String, dynamic>>().map((j) {
      final depRaw = j['departmentId'] ?? j['id'];
      final departmentId = depRaw is int
          ? depRaw
          : int.tryParse(depRaw?.toString() ?? '') ?? 0;
      return Actor(
        id: j['id'].toString(),
        departmentId: departmentId,
        name: (j['name'] ?? '').toString(),
        type: ActorType.department,
      );
    }).toList();
  }
}