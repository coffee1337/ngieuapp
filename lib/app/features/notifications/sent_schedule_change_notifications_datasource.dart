import 'package:drift/drift.dart';
import 'package:ngieuapp/app/core/storage/app_database.dart';

class SentScheduleChangeNotificationsDataSource {
  SentScheduleChangeNotificationsDataSource(this._db);

  final AppDatabase _db;

  Future<Set<String>> getSentFingerprints(String actorId) async {
    final query = _db.select(_db.sentScheduleChangeNotifications)
      ..where((table) => table.actorId.equals(actorId));
    final rows = await query.get();
    return rows.map((row) => row.fingerprint).toSet();
  }

  Future<void> markSent({
    required String fingerprint,
    required String actorId,
    required DateTime lessonDate,
  }) async {
    await _db
        .into(_db.sentScheduleChangeNotifications)
        .insert(
          SentScheduleChangeNotificationsCompanion.insert(
            fingerprint: fingerprint,
            actorId: actorId,
            lessonDate: lessonDate,
            createdAt: DateTime.now(),
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }
}
