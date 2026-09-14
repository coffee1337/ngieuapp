import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ngieuapp/app/core/utils/date_ext.dart';
import 'package:ngieuapp/app/features/notifications/notifications_provider.dart';
import 'package:ngieuapp/app/features/profile/data/profile_providers.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_providers.dart';
import 'package:ngieuapp/app/features/settings/data/settings_providers.dart';
import 'package:ngieuapp/app/features/widget/home_widget_provider.dart';
import 'package:ngieuapp/app/features/widget/lock_screen_card_settings.dart';

final homeWidgetSyncProvider = FutureProvider<void>((ref) async {
  if (!ref.watch(appSettingsLoadedProvider)) return;
  final settings = ref.watch(appSettingsProvider);
  final lockScreenCard = ref.watch(lockScreenCardSettingsProvider);
  if (!lockScreenCard.loaded) return;
  if (!settings.homeWidgetEnabled) {
    if (Platform.isAndroid) {
      await ref
          .read(notificationsServiceProvider)
          .updateAndroidLockScreenCard(const [], enabled: false);
    }
    return;
  }
  if (Platform.isAndroid && !lockScreenCard.enabled) {
    await ref
        .read(notificationsServiceProvider)
        .updateAndroidLockScreenCard(const [], enabled: false);
  }

  if (Platform.isAndroid && lockScreenCard.enabled) {
    // Make the lock-screen card appear immediately, even when the profile or
    // schedule request is still loading. It is replaced with lesson data below.
    await ref
        .read(notificationsServiceProvider)
        .updateAndroidLockScreenCard(const [], enabled: true);
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
  await ref
      .read(homeWidgetServiceProvider)
      .updateSchedule(lessons, showRoom: settings.homeWidgetShowRoom);
  if (Platform.isAndroid) {
    await ref
        .read(notificationsServiceProvider)
        .updateAndroidLockScreenCard(lessons, enabled: lockScreenCard.enabled);
  }
});
