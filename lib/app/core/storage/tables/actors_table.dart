import 'package:drift/drift.dart';

/// Кэш списка акторов (группы студентов, преподаватели, кафедры).
class Actors extends Table {
  TextColumn get id => text()();
  IntColumn get departmentId => integer()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // 'studentGroup' | 'teacher' | 'department'
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id, type};
}
