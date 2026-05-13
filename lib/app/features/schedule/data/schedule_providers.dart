import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngieuapp/app/core/network/providers.dart';
import 'package:ngieuapp/app/core/storage/app_database.dart';
import 'package:ngieuapp/app/core/utils/date_ext.dart';
import 'package:ngieuapp/app/features/schedule/data/actors_api_datasource.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_api_datasource.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_db_datasource.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_repository_impl.dart';
import 'package:ngieuapp/app/features/schedule/data/week_type_api_datasource.dart';
import 'package:ngieuapp/app/features/schedule/data/week_type_cache_datasource.dart';
import 'package:ngieuapp/app/features/schedule/data/week_type_repository_impl.dart';
import 'package:ngieuapp/app/features/schedule/domain/actor.dart';
import 'package:ngieuapp/app/features/schedule/domain/classroom_availability.dart';
import 'package:ngieuapp/app/features/schedule/domain/department.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';
import 'package:ngieuapp/app/features/schedule/domain/schedule_repository.dart';
import 'package:ngieuapp/app/features/schedule/domain/usecases/filter_week_schedule.dart';
import 'package:ngieuapp/app/features/schedule/domain/usecases/find_free_classrooms.dart';
import 'package:ngieuapp/app/features/schedule/domain/usecases/get_next_lesson.dart';
import 'package:ngieuapp/app/features/schedule/domain/usecases/search_schedule.dart';
import 'package:ngieuapp/app/features/schedule/domain/week_type.dart';
import 'package:ngieuapp/app/features/schedule/domain/week_type_repository.dart';
import 'package:ngieuapp/app/features/settings/data/settings_providers.dart';

// ---- Core DB ----

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

// ---- Data sources ----

final scheduleApiDataSourceProvider = Provider<ScheduleApiDataSource>((ref) {
  return ScheduleApiDataSource(ref.watch(scheduleApiProvider));
});

final scheduleDbDataSourceProvider = Provider<ScheduleDbDataSource>((ref) {
  return ScheduleDbDataSource(ref.watch(appDatabaseProvider));
});

final actorsApiDataSourceProvider = Provider<ActorsApiDataSource>((ref) {
  return ActorsApiDataSource(ref.watch(scheduleApiProvider));
});

// ---- Week type data sources ----

final weekTypeApiDataSourceProvider = Provider<WeekTypeApiDataSource>((ref) {
  return WeekTypeApiDataSource(ref.watch(scheduleApiProvider));
});

final weekTypeCacheDataSourceProvider = Provider<WeekTypeCacheDataSource>((
  ref,
) {
  return WeekTypeCacheDataSource();
});

// ---- Repository / Use-cases ----

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepositoryImpl(
    ref.watch(scheduleApiDataSourceProvider),
    ref.watch(scheduleDbDataSourceProvider),
  );
});

final weekTypeRepositoryProvider = Provider<WeekTypeRepository>((ref) {
  return WeekTypeRepositoryImpl(
    ref.watch(weekTypeApiDataSourceProvider),
    ref.watch(weekTypeCacheDataSourceProvider),
  );
});

final findFreeClassroomsProvider = Provider<FindFreeClassrooms>((ref) {
  return FindFreeClassrooms(ref.watch(scheduleRepositoryProvider));
});

final searchScheduleProvider = Provider<SearchSchedule>((ref) {
  return SearchSchedule(ref.watch(scheduleRepositoryProvider));
});

final filterWeekScheduleProvider = Provider<FilterWeekSchedule>((ref) {
  return FilterWeekSchedule();
});

final getNextLessonProvider = Provider<GetNextLesson>((ref) {
  return GetNextLesson();
});

// ---- UI state ----

/// Провайдер для получения типа недели для указанной даты
final weekTypeProvider = FutureProvider.autoDispose.family<WeekType, DateTime>((
  ref,
  date,
) async {
  try {
    return await ref.watch(weekTypeRepositoryProvider).getWeekType(date);
  } catch (e) {
    // При ошибке используем локальную логику
    return WeekType(date: date, isUpperWeek: date.isEvenWeek);
  }
});

/// Провайдер для получения типа текущей недели
final currentWeekTypeProvider = FutureProvider.autoDispose<WeekType>((ref) {
  final now = DateTime.now();
  return ref.watch(weekTypeProvider(now).future);
});

class CurrentWeekStartNotifier extends StateNotifier<DateTime> {
  CurrentWeekStartNotifier() : super(DateTime.now().startOfWeek);

  void nextWeek() => state = state.add(const Duration(days: 7));
  void prevWeek() => state = state.subtract(const Duration(days: 7));
  void thisWeek() => state = DateTime.now().startOfWeek;
  void setDate(DateTime date) => state = date.startOfWeek;
}

final currentWeekStartProvider =
    StateNotifierProvider<CurrentWeekStartNotifier, DateTime>((ref) {
      return CurrentWeekStartNotifier();
    });

/// Провайдер для пользовательского выбора типа недели (null = использовать тип из API)
final weekTypeOverrideProvider = StateProvider<bool?>((ref) => null);

// ---- Data streams ----

typedef WeekKey = ({String actorId, DateTime weekStart});

final rawWeekScheduleProvider = StreamProvider.autoDispose
    .family<List<Lesson>, WeekKey>((ref, key) {
      return ref
          .watch(scheduleRepositoryProvider)
          .watchWeek(key.actorId, key.weekStart);
    });

final weekScheduleProvider = FutureProvider.autoDispose
    .family<List<Lesson>, WeekKey>((ref, key) async {
      final rawAsync = await ref.watch(rawWeekScheduleProvider(key).future);
      final showChanges = ref.watch(appSettingsProvider).showChanges;

      final weekType = await ref.watch(weekTypeProvider(key.weekStart).future);
      final weekTypeOverride = ref.watch(weekTypeOverrideProvider);
      final isEvenWeek = weekTypeOverride ?? weekType.isEvenWeek;

      final filter = ref.watch(filterWeekScheduleProvider);
      return filter(
        lessons: rawAsync,
        weekStart: key.weekStart,
        isEvenWeek: isEvenWeek,
        showChanges: showChanges,
      );
    });

final studentGroupsProvider = FutureProvider<List<Actor>>((ref) {
  return ref.watch(actorsApiDataSourceProvider).loadStudentGroups();
});

final studentDepartmentsProvider = FutureProvider<List<Department>>((ref) {
  return ref.watch(actorsApiDataSourceProvider).fetchStudentDepartments();
});

final teachersProvider = FutureProvider<List<Actor>>((ref) {
  return ref.watch(actorsApiDataSourceProvider).loadTeachers();
});

// ---- Free rooms ----

typedef FreeRoomsKey = ({
  DateTime date,
  int fromHour,
  int fromMinute,
  int toHour,
  int toMinute,
  int minDurationMinutes,
  String buildingFilter,
  String instituteFilter,
});

final freeRoomsProvider = FutureProvider.autoDispose
    .family<List<ClassroomAvailability>, FreeRoomsKey>((ref, key) {
      final uc = ref.watch(findFreeClassroomsProvider);
      return uc.call(
        date: key.date,
        from: TimeOfDay(hour: key.fromHour, minute: key.fromMinute),
        to: TimeOfDay(hour: key.toHour, minute: key.toMinute),
        minDuration: Duration(minutes: key.minDurationMinutes),
        buildingFilter: key.buildingFilter.isEmpty ? null : key.buildingFilter,
        instituteFilter: key.instituteFilter.isEmpty
            ? null
            : key.instituteFilter,
      );
    });

// ---- Search ----

final scheduleSearchResultsProvider = FutureProvider.autoDispose
    .family<List<SearchScheduleResult>, String>((ref, query) {
      return ref.watch(searchScheduleProvider).call(query);
    });
