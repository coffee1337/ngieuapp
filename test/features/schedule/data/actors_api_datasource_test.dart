import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/core/network/api_endpoints.dart';
import 'package:ngieuapp/app/features/schedule/data/actors_api_datasource.dart';
import 'package:ngieuapp/app/features/schedule/domain/actor.dart';

void main() {
  group('ActorsApiDataSource', () {
    test('loads current student and teacher ids from Actors/Get', () async {
      final requests = <RequestOptions>[];
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v2/'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requests.add(options);
            final isStudent = options.queryParameters['isStudent'] as bool;
            handler.resolve(
              Response<dynamic>(
                requestOptions: options,
                data: [
                  {
                    'id': isStudent
                        ? 'a11ce001-0000-0001-0000-004300000000'
                        : '343',
                    'departmentId': isStudent ? 2 : 9,
                    'name': isStudent ? 'Б-25ИвО' : 'Абувалов М. А.',
                  },
                ],
                statusCode: 200,
              ),
            );
          },
        ),
      );
      final source = ActorsApiDataSource(dio);

      final students = await source.loadStudentGroups();
      final teachers = await source.loadTeachers();

      expect(students.single.id, 'a11ce001-0000-0001-0000-004300000000');
      expect(students.single.type, ActorType.studentGroup);
      expect(teachers.single.id, '343');
      expect(teachers.single.type, ActorType.teacher);
      expect(requests, hasLength(2));
      expect(
        requests.every((request) => request.path == ApiEndpoints.actorsGet),
        isTrue,
      );
      expect(requests[0].queryParameters, {'isStudent': true});
      expect(requests[1].queryParameters, {'isStudent': false});
    });

    test('loads departments for both actor types', () async {
      final requests = <RequestOptions>[];
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v2/'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requests.add(options);
            handler.resolve(
              Response<dynamic>(
                requestOptions: options,
                data: {
                  'data': [
                    {'id': '9', 'name': 'Технические системы'},
                  ],
                },
                statusCode: 200,
              ),
            );
          },
        ),
      );
      final source = ActorsApiDataSource(dio);

      final departments = await source.fetchDepartments(isStudent: false);

      expect(departments.single.id, 9);
      expect(departments.single.name, 'Технические системы');
      expect(requests.single.path, ApiEndpoints.departmentsGet);
      expect(requests.single.queryParameters, {'isStudent': false});
    });

    test('uses the bundled list when the actors API is unavailable', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v2/'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) => handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.connectionError,
            ),
          ),
        ),
      );
      String? requestedAsset;
      final source = ActorsApiDataSource(
        dio,
        assetLoader: (path) async {
          requestedAsset = path;
          return '[{"id":"offline-7","departmentId":8,"name":"Иванов И. И."}]';
        },
      );

      final teachers = await source.loadTeachers();

      expect(requestedAsset, 'assets/json/teachers.json');
      expect(teachers.single.id, 'offline-7');
      expect(teachers.single.type, ActorType.teacher);
    });

    test('uses the bundled list for a malformed empty response', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v2/'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) => handler.resolve(
            Response<dynamic>(
              requestOptions: options,
              data: const <dynamic>[],
              statusCode: 200,
            ),
          ),
        ),
      );
      final source = ActorsApiDataSource(
        dio,
        assetLoader: (_) async =>
            '[{"id":"offline-group","departmentId":2,"name":"Б-25ИвО"}]',
      );

      final students = await source.loadStudentGroups();

      expect(students.single.id, 'offline-group');
      expect(students.single.type, ActorType.studentGroup);
    });
  });

  group('Actor.fromApiJson', () {
    test('accepts numeric ids and string department ids', () {
      final actor = Actor.fromApiJson({
        'id': 343,
        'departmentId': '9',
        'name': ' Абувалов М. А. ',
      }, type: ActorType.teacher);

      expect(actor.id, '343');
      expect(actor.departmentId, 9);
      expect(actor.name, 'Абувалов М. А.');
    });
  });
}
