import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ngieuapp/app/core/network/api_endpoints.dart';
import 'package:ngieuapp/app/features/schedule/domain/actor.dart';
import 'package:ngieuapp/app/features/schedule/domain/department.dart';

typedef AssetLoader = Future<String> Function(String path);

class ActorsApiDataSource {
  ActorsApiDataSource(this._dio, {AssetLoader? assetLoader})
    : _assetLoader = assetLoader ?? rootBundle.loadString;

  final Dio _dio;
  final AssetLoader _assetLoader;

  Future<List<Actor>> loadStudentGroups({CancelToken? ct}) => _loadActors(
    isStudent: true,
    type: ActorType.studentGroup,
    fallbackAsset: 'assets/json/student.json',
    cancelToken: ct,
  );

  Future<List<Actor>> loadTeachers({CancelToken? ct}) => _loadActors(
    isStudent: false,
    type: ActorType.teacher,
    fallbackAsset: 'assets/json/teachers.json',
    cancelToken: ct,
  );

  Future<List<Department>> fetchDepartments({
    required bool isStudent,
    CancelToken? ct,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiEndpoints.departmentsGet,
      queryParameters: {'isStudent': isStudent},
      cancelToken: ct,
    );
    return _extractList(response.data)
        .whereType<Map<String, dynamic>>()
        .map(Department.fromJson)
        .where((department) => department.id > 0 && department.name.isNotEmpty)
        .toList(growable: false);
  }

  Future<List<Actor>> _loadActors({
    required bool isStudent,
    required ActorType type,
    required String fallbackAsset,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.actorsGet,
        queryParameters: {'isStudent': isStudent},
        cancelToken: cancelToken,
      );
      final actors = _parseActors(response.data, type);
      if (actors.isEmpty) {
        throw const FormatException('API вернул пустой список');
      }
      return actors;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.cancel) rethrow;
      return _loadBundledActors(fallbackAsset, type);
    } on FormatException {
      return _loadBundledActors(fallbackAsset, type);
    }
  }

  Future<List<Actor>> _loadBundledActors(
    String assetPath,
    ActorType type,
  ) async {
    final raw = await _assetLoader(assetPath);
    return _parseActors(jsonDecode(raw), type);
  }

  List<Actor> _parseActors(Object? data, ActorType type) => _extractList(data)
      .whereType<Map<String, dynamic>>()
      .map((json) => Actor.fromApiJson(json, type: type))
      .where((actor) => actor.id.isNotEmpty && actor.name.isNotEmpty)
      .toList(growable: false);

  List<dynamic> _extractList(Object? data) => switch (data) {
    final List<dynamic> list => list,
    final Map<dynamic, dynamic> map when map['data'] is List<dynamic> =>
      map['data'] as List<dynamic>,
    final Map<dynamic, dynamic> map when map['actors'] is List<dynamic> =>
      map['actors'] as List<dynamic>,
    _ => const <dynamic>[],
  };
}
