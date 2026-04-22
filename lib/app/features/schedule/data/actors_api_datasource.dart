import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../domain/actor.dart';

class ActorsApiDataSource {
  ActorsApiDataSource(this._dio);
  final Dio _dio;

  /// Группы студентов — из bundled JSON.
  Future<List<Actor>> loadStudentGroups() async {
    final raw = await rootBundle.loadString('assets/json/student.json');
    final list = jsonDecode(raw) as List;
    return list
        .whereType<Map<String, dynamic>>()
        .map(Actor.fromStudentJson)
        .toList();
  }

  /// Преподаватели — из bundled JSON.
  Future<List<Actor>> loadTeachers() async {
    final raw = await rootBundle.loadString('assets/json/teachers.json');
    final list = jsonDecode(raw) as List;
    return list
        .whereType<Map<String, dynamic>>()
        .map(Actor.fromTeacherJson)
        .toList();
  }

  /// Кафедры — из API.
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
      return Actor(
        id: j['id'].toString(),
        departmentId: (j['departmentId'] ?? j['id']) is int
            ? (j['departmentId'] ?? j['id']) as int
            : int.tryParse(j['departmentId']?.toString() ?? j['id'].toString()) ?? 0,
        name: (j['name'] ?? '').toString(),
        type: ActorType.department,
      );
    }).toList();
  }
}