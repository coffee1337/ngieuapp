import 'package:drift/drift.dart';

class Classrooms extends Table {
  TextColumn get code => text()();
  TextColumn get building => text().withDefault(const Constant(''))();
  IntColumn get capacity => integer().nullable()();

  @override
  Set<Column> get primaryKey => {code, building};
}
