import 'package:drift/drift.dart';

class Lessons extends Table {
  TextColumn get id => text()();
  TextColumn get actorId => text()(); // кому принадлежит слот
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get pairNumber => integer()();
  TextColumn get subject => text()();
  TextColumn get type => text()();
  TextColumn get classroom => text()();
  TextColumn get building => text().withDefault(const Constant(''))();
  TextColumn get teacherIds => text()();
  TextColumn get teacherNames => text()();
  TextColumn get groupIds => text()();
  TextColumn get groupNames => text()();
  TextColumn get subgroup => text().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}