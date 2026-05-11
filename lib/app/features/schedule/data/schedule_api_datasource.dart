import 'package:dio/dio.dart';
import 'package:ngieuapp/app/features/schedule/data/lesson_mapper.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';

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
    final raw = switch (data) {
      final List l => l,
      final Map m when m['data'] is List => m['data'] as List,
      final Map m when m['schedule'] is List => m['schedule'] as List,
      _ => const [],
    };
    return raw
        .whereType<Map<String, dynamic>>()
        .expand(LessonMapper.fromApi)
        .toList();
  }
}
