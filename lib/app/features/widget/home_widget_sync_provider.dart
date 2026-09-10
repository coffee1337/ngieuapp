import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ngieuapp/app/core/utils/date_ext.dart';
import 'package:ngieuapp/app/features/profile/data/profile_providers.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_providers.dart';
import 'package:ngieuapp/app/features/settings/data/settings_providers.dart';
import 'package:ngieuapp/app/features/widget/home_widget_provider.dart';

final homeWidgetSyncProvider = FutureProvider<void>((ref) async {
  if (!ref.watch(appSettingsLoadedProvider)) return;
  final settings = ref.watch(appSettingsProvider);
  if (!settings.homeWidgetEnabled) return;

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
});
