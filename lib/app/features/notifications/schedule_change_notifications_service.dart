import 'package:ngieuapp/app/features/notifications/notifications_service.dart';
import 'package:ngieuapp/app/features/notifications/sent_schedule_change_notifications_datasource.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';
import 'package:ngieuapp/app/features/schedule/domain/usecases/detect_schedule_change_notifications.dart';

class ScheduleChangeNotificationsService {
  ScheduleChangeNotificationsService(
    this._notifications,
    this._sentNotifications,
    this._detectChanges,
  );

  final NotificationsService _notifications;
  final SentScheduleChangeNotificationsDataSource _sentNotifications;
  final DetectScheduleChangeNotifications _detectChanges;

  Future<void> notifyAboutNewChanges({
    required String actorId,
    required List<Lesson> oldLessons,
    required List<Lesson> freshLessons,
    DateTime? now,
  }) async {
    final sentFingerprints = await _sentNotifications.getSentFingerprints(
      actorId,
    );
    final changes = _detectChanges(
      actorId: actorId,
      oldLessons: oldLessons,
      freshLessons: freshLessons,
      now: now ?? DateTime.now(),
      sentFingerprints: sentFingerprints,
    );

    for (final change in changes) {
      await _notifications.showScheduleChangeNotification(
        lesson: change.lesson,
        fingerprint: change.fingerprint,
      );
      await _sentNotifications.markSent(
        fingerprint: change.fingerprint,
        actorId: actorId,
        lessonDate: change.lesson.date,
      );
    }
  }
}
