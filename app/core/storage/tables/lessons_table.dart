import 'package:drift/drift.dart';

class Lessons extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();        // 00:00 локально
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get pairNumber => integer()();
  TextColumn get subject => text()();
  TextColumn get type => text()();                // enum как строка
  TextColumn get classroom => text()();
  TextColumn get building => text().withDefault(const Constant(''))();
  TextColumn get teacherIds => text()();          // CSV или JSON
  TextColumn get teacherNames => text()();
  TextColumn get groupIds => text()();
  TextColumn get groupNames => text()();
  TextColumn get subgroup => text().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get cachedAt => dateTime()();    // для TTL

  @override
  Set<Column> get primaryKey => {id};
}

class Classrooms extends Table {
  TextColumn get code => text()();                // "215"
  TextColumn get building => text().withDefault(const Constant(''))();
  IntColumn get capacity => integer().nullable()();
  @override
  Set<Column> get primaryKey => {code, building};
}