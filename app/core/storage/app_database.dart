import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/classrooms_table.dart';
import 'tables/lessons_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Lessons, Classrooms])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'ngieu_app'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_lessons_date ON lessons(date);',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_lessons_classroom ON lessons(classroom, building);',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_lessons_actor ON lessons(actor_id);',
          );
        },
      );
}