import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ngieuapp/app/core/utils/date_ext.dart';
import 'package:ngieuapp/app/features/notifications/notifications_provider.dart';
import 'package:ngieuapp/app/features/profile/data/profile_providers.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_providers.dart';
import 'package:ngieuapp/app/features/settings/data/settings_providers.dart';
import 'package:ngieuapp/app/features/settings/data/smart_notification_settings_providers.dart';

final notificationSyncProvider = FutureProvider<void>((ref) async {
  if (!ref.watch(appSettingsLoadedProvider)) return;
  final settings = ref.watch(appSettingsProvider);
  final smartSettings = ref.watch(smartNotificationSettingsProvider);
  final notifications = ref.watch(notificationsServiceProvider);

  if (!settings.notificationsEnabled) {
    await notifications.cancelAll();
    return;
  }

  final identity = await ref.watch(studentIdentityProvider.future);
  if (identity == null) return;

  final weekStart = (await ref.watch(
    currentWeekTypeProvider.future,
  )).date.startOfWeek;
  final lessons = await ref.watch(
    weekScheduleProvider((
      actorId: identity.actorId,
      weekStart: weekStart,
    )).future,
  );
  await notifications.rescheduleFor(
    lessons,
    minutesBefore: settings.notificationMinutesBefore,
    enabled: true,
    preferences: smartSettings,
  );
});
