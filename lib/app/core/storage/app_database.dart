import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:ngieuapp/app/core/storage/tables/classrooms_table.dart';
import 'package:ngieuapp/app/core/storage/tables/lessons_table.dart';
import 'package:ngieuapp/app/core/storage/tables/sent_schedule_change_notifications_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [ScheduleEntries, Classrooms, SentScheduleChangeNotifications],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'ngieu_app'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_schedule_date '
        'ON schedule_entries(date);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_schedule_classroom '
        'ON schedule_entries(classroom, building);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_schedule_actor '
        'ON schedule_entries(actor_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_sent_schedule_changes_actor '
        'ON sent_schedule_change_notifications(actor_id);',
      );
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.deleteTable('schedule_entries');
        await m.createTable(scheduleEntries);
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_schedule_date '
          'ON schedule_entries(date);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_schedule_classroom '
          'ON schedule_entries(classroom, building);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_schedule_actor '
          'ON schedule_entries(actor_id);',
        );
      }
      if (from < 3) {
        await m.createTable(sentScheduleChangeNotifications);
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_sent_schedule_changes_actor '
          'ON sent_schedule_change_notifications(actor_id);',
        );
      }
    },
  );
}
