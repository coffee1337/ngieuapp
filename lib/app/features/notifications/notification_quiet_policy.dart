import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';
import 'package:ngieuapp/app/features/settings/domain/smart_notification_settings.dart';

class NotificationQuietPolicy {
  const NotificationQuietPolicy();

  bool shouldSilence({
    required DateTime at,
    required SmartNotificationSettings preferences,
    required List<Lesson> lessons,
  }) {
    if (preferences.isQuietTime(at)) return true;
    if (!preferences.quietDuringLessons) return false;
    return lessons.any(
      (lesson) =>
          !lesson.isEvent &&
          !at.isBefore(lesson.startTime) &&
          at.isBefore(lesson.endTime),
    );
  }
}
