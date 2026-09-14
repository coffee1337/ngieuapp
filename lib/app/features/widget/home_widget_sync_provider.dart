import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ngieuapp/app/core/utils/app_platform.dart';
import 'package:ngieuapp/app/core/utils/date_ext.dart';
import 'package:ngieuapp/app/features/notifications/notifications_provider.dart';
import 'package:ngieuapp/app/features/profile/data/profile_providers.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_providers.dart';
import 'package:ngieuapp/app/features/settings/data/settings_providers.dart';
import 'package:ngieuapp/app/features/widget/home_widget_provider.dart';
import 'package:ngieuapp/app/features/widget/lock_screen_card_settings.dart';

final homeWidgetSyncProvider = FutureProvider<void>((ref) async {
  if (!AppPlatform.supportsMobileIntegrations) return;
  var disposed = false;
  ref.onDispose(() => disposed = true);
  if (!ref.watch(appSettingsLoadedProvider)) return;
  final settings = ref.watch(appSettingsProvider);
  final lockScreenCard = ref.watch(lockScreenCardSettingsProvider);
  if (!lockScreenCard.loaded) return;
  if (!settings.homeWidgetEnabled) {
    await ref.read(homeWidgetServiceProvider).updateSchedule(const []);
    if (AppPlatform.isAndroid) {
      await ref
          .read(notificationsServiceProvider)
          .updateAndroidLockScreenCard(const [], enabled: false);
    }
    return;
  }

  final identity = await ref.watch(studentIdentityProvider.future);
  if (disposed) return;
  if (identity == null) {
    await ref.read(homeWidgetServiceProvider).updateSchedule(const []);
    if (disposed) return;
    if (AppPlatform.isAndroid) {
      await ref
          .read(notificationsServiceProvider)
          .updateAndroidLockScreenCard(const [], enabled: false);
    }
    return;
  }
  if (AppPlatform.isAndroid && !lockScreenCard.enabled) {
    await ref
        .read(notificationsServiceProvider)
        .updateAndroidLockScreenCard(const [], enabled: false);
  }

  final weekStart = (await ref.watch(
    currentWeekTypeProvider.future,
  )).date.startOfWeek;
  if (disposed) return;
  final lessons = await ref.watch(
    weekScheduleProvider((
      actorId: identity.actorId,
      weekStart: weekStart,
    )).future,
  );
  if (disposed) return;
  await ref
      .read(homeWidgetServiceProvider)
      .updateSchedule(lessons, showRoom: settings.homeWidgetShowRoom);
  if (disposed) return;
  if (AppPlatform.isAndroid) {
    await ref
        .read(notificationsServiceProvider)
        .updateAndroidLockScreenCard(lessons, enabled: lockScreenCard.enabled);
  }
});
