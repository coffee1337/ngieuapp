import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ngieuapp/app/features/schedule/data/week_type_api_datasource.dart';
import 'package:ngieuapp/app/features/schedule/data/week_type_cache_datasource.dart';
import 'package:ngieuapp/app/features/schedule/data/week_type_repository_impl.dart';
import 'package:ngieuapp/app/features/schedule/domain/week_type.dart';

class MockWeekTypeApiDataSource extends Mock implements WeekTypeApiDataSource {}

class MockWeekTypeCacheDataSource extends Mock
    implements WeekTypeCacheDataSource {}

void main() {
  late MockWeekTypeApiDataSource api;
  late MockWeekTypeCacheDataSource cache;
  late WeekTypeRepositoryImpl repository;

  final requestedDate = DateTime(2025, 3, 12);
  final cachedWeek = WeekType(date: DateTime(2025, 3, 10), isUpperWeek: true);

  setUp(() {
    api = MockWeekTypeApiDataSource();
    cache = MockWeekTypeCacheDataSource();
    repository = WeekTypeRepositoryImpl(api, cache);
  });

  test('returns a current cached week without requesting the API', () async {
    when(() => cache.loadWeekType()).thenAnswer((_) async => cachedWeek);

    final result = await repository.getWeekType(requestedDate);

    expect(result, cachedWeek);
    verifyNever(() => api.getWeekType(any()));
  });

  test('uses an expired API value when the device is offline', () async {
    when(() => cache.loadWeekType()).thenAnswer((_) async => null);
    when(() => api.getWeekType(requestedDate)).thenThrow(Exception('offline'));
    when(
      () => cache.loadWeekType(allowExpired: true),
    ).thenAnswer((_) async => cachedWeek);

    final result = await repository.getWeekType(requestedDate);

    expect(result, cachedWeek);
  });

  test('uses the server response date for the current week', () async {
    final serverWeek = WeekType(
      date: DateTime(2025, 3, 13),
      isUpperWeek: false,
    );
    when(() => api.getCurrentWeekType()).thenAnswer((_) async => serverWeek);
    when(() => cache.saveWeekType(serverWeek)).thenAnswer((_) async {});

    expect(await repository.getCurrentWeekType(), serverWeek);
  });
}
