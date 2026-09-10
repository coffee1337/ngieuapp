import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/notifications/notification_quiet_policy.dart';
import 'package:ngieuapp/app/features/settings/domain/smart_notification_settings.dart';

import '../../helpers/test_helpers.dart';

void main() {
  const policy = NotificationQuietPolicy();
  final lesson = makeLesson(
    startTime: DateTime(2026, 9, 10, 10),
    endTime: DateTime(2026, 9, 10, 11, 30),
  );

  test('silences an app notification while a lesson is active', () {
    expect(
      policy.shouldSilence(
        at: DateTime(2026, 9, 10, 10, 45),
        preferences: const SmartNotificationSettings(
          quietHoursEnabled: false,
        ),
        lessons: [lesson],
      ),
      isTrue,
    );
  });

  test('does not silence after the lesson has ended', () {
    expect(
      policy.shouldSilence(
        at: DateTime(2026, 9, 10, 11, 30),
        preferences: const SmartNotificationSettings(
          quietHoursEnabled: false,
        ),
        lessons: [lesson],
      ),
      isFalse,
    );
  });

  test('can disable lesson-based quiet mode', () {
    expect(
      policy.shouldSilence(
        at: DateTime(2026, 9, 10, 10, 45),
        preferences: const SmartNotificationSettings(
          quietHoursEnabled: false,
          quietDuringLessons: false,
        ),
        lessons: [lesson],
      ),
      isFalse,
    );
  });
}
