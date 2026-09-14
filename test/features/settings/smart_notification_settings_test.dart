import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/settings/domain/smart_notification_settings.dart';

void main() {
  test('detects quiet hours that cross midnight', () {
    const settings = SmartNotificationSettings(
      quietHoursStart: 22,
      quietHoursEnd: 7,
    );

    expect(settings.isQuietTime(DateTime(2026, 9, 9, 23)), isTrue);
    expect(settings.isQuietTime(DateTime(2026, 9, 10, 6, 59)), isTrue);
    expect(settings.isQuietTime(DateTime(2026, 9, 10, 12)), isFalse);
  });

  test('disabled quiet hours never suppress notifications', () {
    const settings = SmartNotificationSettings(quietHoursEnabled: false);

    expect(settings.isQuietTime(DateTime(2026, 9, 9, 23)), isFalse);
  });

  test('equal quiet-hour boundaries do not silence the whole day', () {
    const settings = SmartNotificationSettings(
      quietHoursStart: 8,
      quietHoursEnd: 8,
    );

    expect(settings.isQuietTime(DateTime(2026, 9, 9, 8)), isFalse);
  });

  test('round-trips notification preferences', () {
    const settings = SmartNotificationSettings(
      scheduleChangesEnabled: false,
      quietHoursEnabled: false,
      quietDuringLessons: false,
      soundEnabled: false,
      vibrationEnabled: false,
    );

    final restored = SmartNotificationSettings.fromJson(settings.toJson());

    expect(restored.scheduleChangesEnabled, isFalse);
    expect(restored.quietHoursEnabled, isFalse);
    expect(restored.quietDuringLessons, isFalse);
    expect(restored.soundEnabled, isFalse);
    expect(restored.vibrationEnabled, isFalse);
  });
}
