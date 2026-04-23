import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/providers.dart';
import '../../../core/storage/app_database.dart';
import '../../../core/utils/date_ext.dart';
import '../../settings/data/settings_providers.dart';
import '../domain/actor.dart';
import '../domain/classroom_availability.dart';
import '../domain/lesson.dart';
import '../domain/schedule_repository.dart';
import '../domain/usecases/find_free_classrooms.dart';
import '../domain/usecases/search_schedule.dart';
import 'actors_api_datasource.dart';
import 'schedule_api_datasource.dart';
import 'schedule_db_datasource.dart';
import 'schedule_repository_impl.dart';

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

// ---- Repository / Use-cases ----

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepositoryImpl(
    ref.watch(scheduleApiDataSourceProvider),
    ref.watch(scheduleDbDataSourceProvider),
  );
});

final findFreeClassroomsProvider = Provider<FindFreeClassrooms>((ref) {
  return FindFreeClassrooms(ref.watch(scheduleRepositoryProvider));
});

final searchScheduleProvider = Provider<SearchSchedule>((ref) {
  return SearchSchedule(ref.watch(scheduleRepositoryProvider));
});

// ---- UI state ----

class CurrentWeekStartNotifier extends StateNotifier<DateTime> {
  CurrentWeekStartNotifier() : super(DateTime.now().startOfWeek);

  void nextWeek() => state = state.add(const Duration(days: 7));
  void prevWeek() => state = state.subtract(const Duration(days: 7));
  void thisWeek() => state = DateTime.now().startOfWeek;
}

final currentWeekStartProvider =
    StateNotifierProvider<CurrentWeekStartNotifier, DateTime>((ref) {
  return CurrentWeekStartNotifier();
});

// ---- Data streams ----

typedef WeekKey = ({String actorId, DateTime weekStart});

final rawWeekScheduleProvider =
    StreamProvider.autoDispose.family<List<Lesson>, WeekKey>((ref, key) {
  return ref
      .watch(scheduleRepositoryProvider)
      .watchWeek(key.actorId, key.weekStart);
});

final weekScheduleProvider =
    Provider.autoDispose.family<AsyncValue<List<Lesson>>, WeekKey>((ref, key) {
  final rawAsync = ref.watch(rawWeekScheduleProvider(key));
  final showChanges = ref.watch(appSettingsProvider).showChanges;

  return rawAsync.whenData((all) {
    final weekEnd = key.weekStart.add(const Duration(days: 7));
    final thisWeek = all.where((l) =>
        !l.date.isBefore(key.weekStart) && l.date.isBefore(weekEnd)).toList();

    final byCell = <String, List<Lesson>>{};
    for (final l in thisWeek) {
      final k = '${l.date.toIso8601String()}|${l.pairNumber}';
      byCell.putIfAbsent(k, () => []).add(l);
    }

    final result = <Lesson>[];
    for (final cell in byCell.values) {
      final changes = cell.where((l) => l.isChange).toList();
      final regulars = cell.where((l) => !l.isChange).toList();

      if (showChanges && changes.isNotEmpty) {
        final visible = changes.where((l) =>
            !(l.isEvent &&
                l.subject.toLowerCase() == 'мероприятие' &&
                l.classroom.isEmpty)).toList();
        if (visible.isEmpty) {
          result.add(changes.first.copyWith(
            subject: 'Занятие отменено',
            isEvent: true,
          ));
        } else {
          result.addAll(visible);
        }
      } else {
        for (final l in regulars) {
          if (_parityMatches(l, key.weekStart)) {
            result.add(l);
          }
        }
      }
    }
    return result;
  });
});

bool _parityMatches(Lesson l, DateTime weekStart) {
  if (l.parity == WeekParity.any) return true;
  final isEven = weekStart.isEvenWeek;
  return (l.parity == WeekParity.even) == isEven;
}

final studentGroupsProvider = FutureProvider<List<Actor>>((ref) {
  return ref.watch(actorsApiDataSourceProvider).loadStudentGroups();
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
});

final freeRoomsProvider = FutureProvider.autoDispose
    .family<List<ClassroomAvailability>, FreeRoomsKey>((ref, key) {
  final uc = ref.watch(findFreeClassroomsProvider);
  return uc.call(
    date: key.date,
    from: TimeOfDay(hour: key.fromHour, minute: key.fromMinute),
    to: TimeOfDay(hour: key.toHour, minute: key.toMinute),
    minDuration: Duration(minutes: key.minDurationMinutes),
    buildingFilter:
        key.buildingFilter.isEmpty ? null : key.buildingFilter,
  );
});

// ---- Search ----

final scheduleSearchResultsProvider = FutureProvider.autoDispose
    .family<List<SearchScheduleResult>, String>((ref, query) {
  return ref.watch(searchScheduleProvider).call(query);
});