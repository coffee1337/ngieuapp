import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/classrooms_table.dart';
import 'tables/lessons_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [ScheduleEntries, Classrooms])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'ngieu_app'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_schedule_date ON schedule_entries(date);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_schedule_classroom ON schedule_entries(classroom, building);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_schedule_actor ON schedule_entries(actor_id);',
      );
    },
    onUpgrade: (m, from, to) async {
      // Старая схема несовместима с новой — проще перекачать с нуля
      await m.deleteTable('schedule_entries');
      await m.createTable(scheduleEntries);
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_schedule_date ON schedule_entries(date);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_schedule_classroom ON schedule_entries(classroom, building);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_schedule_actor ON schedule_entries(actor_id);',
      );
    },
  );
}
