import 'package:dio/dio.dart';
import 'package:ngieuapp/app/core/network/api_endpoints.dart';
import 'package:ngieuapp/app/core/network/api_exception.dart';
import 'package:ngieuapp/app/features/schedule/data/lesson_mapper.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';

class ScheduleApiDataSource {
  ScheduleApiDataSource(this._dio);
  final Dio _dio;

  Future<List<Lesson>> fetchSchedule(
    String actorId, {
    required DateTime anchorDate,
    CancelToken? ct,
  }) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiEndpoints.scheduleGet,
        queryParameters: {'actorId': actorId},
        cancelToken: ct,
      );
      final data = resp.data;
      final raw = _extractRawList(data);
      final lessons = raw
          .whereType<Map<dynamic, dynamic>>()
          .map((e) => Map<String, dynamic>.from(e))
          .expand((item) => LessonMapper.fromApi(item, anchorDate: anchorDate))
          .toList();
      if (raw.isNotEmpty && lessons.isEmpty) {
        throw const FormatException(
          'API расписания вернул данные, которые не удалось распознать',
        );
      }
      return lessons;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } on FormatException {
      rethrow;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Некорректные данные расписания: $e');
    }
  }

  List<dynamic> _extractRawList(Object? data) => switch (data) {
    final List<dynamic> list => list,
    final Map<dynamic, dynamic> map when map['data'] is List<dynamic> =>
      map['data'] as List<dynamic>,
    final Map<dynamic, dynamic> map when map['schedule'] is List<dynamic> =>
      map['schedule'] as List<dynamic>,
    final Map<dynamic, dynamic> map when map['actors'] is List<dynamic> =>
      map['actors'] as List<dynamic>,
    final Map<dynamic, dynamic> map when map['result'] is List<dynamic> =>
      map['result'] as List<dynamic>,
    final Map<dynamic, dynamic> map when map['items'] is List<dynamic> =>
      map['items'] as List<dynamic>,
    _ => throw const FormatException(
      'API расписания вернул неизвестный формат',
    ),
  };
}
