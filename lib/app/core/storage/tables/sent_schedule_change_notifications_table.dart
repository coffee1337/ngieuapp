import 'package:drift/drift.dart';

class SentScheduleChangeNotifications extends Table {
  TextColumn get fingerprint => text()();
  TextColumn get actorId => text()();
  DateTimeColumn get lessonDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {fingerprint};
}
