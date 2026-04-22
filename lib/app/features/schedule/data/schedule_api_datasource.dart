import 'package:dio/dio.dart';
import '../domain/lesson.dart';
import 'lesson_mapper.dart';

class ScheduleApiDataSource {
  ScheduleApiDataSource(this._dio);
  final Dio _dio;

  Future<List<Lesson>> fetchSchedule(String actorId, {CancelToken? ct}) async {
    final resp = await _dio.get<dynamic>(
      'Schedule/Get',
      queryParameters: {'actorId': actorId},
      cancelToken: ct,
    );
    final data = resp.data;
    // API может вернуть как List, так и { data: [...] } — проверим оба
    final List raw = switch (data) {
      List l => l,
      Map m when m['data'] is List => m['data'] as List,
      Map m when m['schedule'] is List => m['schedule'] as List,
      _ => const [],
    };
    return raw
        .whereType<Map<String, dynamic>>()
        .map(LessonMapper.fromApi)
        .whereType<Lesson>()
        .toList();
  }
}