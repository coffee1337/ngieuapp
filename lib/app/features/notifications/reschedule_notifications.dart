import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngieuapp/app/core/utils/date_ext.dart';
import 'package:ngieuapp/app/features/notifications/notifications_provider.dart';
import 'package:ngieuapp/app/features/profile/data/profile_providers.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_providers.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';
import 'package:ngieuapp/app/features/settings/data/settings_providers.dart';

Future<void> rescheduleNotifications(WidgetRef ref) async {
  final settings = ref.read(appSettingsProvider);
  final notifications = ref.read(notificationsServiceProvider);

  if (!settings.notificationsEnabled) {
    await notifications.cancelAll();
    return;
  }

  final identity = await ref.read(studentIdentityProvider.future);
  if (identity == null) return;

  final weekStart = DateTime.now().startOfWeek;
  final key = (actorId: identity.actorId, weekStart: weekStart);

  try {
    final lessons = await ref.read(rawWeekScheduleProvider(key).future);
    final relevant = _applyChanges(lessons, showChanges: settings.showChanges);
    await notifications.rescheduleFor(
      relevant,
      minutesBefore: settings.notificationMinutesBefore,
      enabled: true,
    );
  } catch (_) {}
}

List<Lesson> _applyChanges(List<Lesson> all, {required bool showChanges}) {
  final byCell = <String, List<Lesson>>{};
  for (final l in all) {
    final k = '${l.date.toIso8601String()}|${l.pairNumber}';
    byCell.putIfAbsent(k, () => []).add(l);
  }
  final result = <Lesson>[];
  for (final cell in byCell.values) {
    final changes = cell.where((l) => l.isChange).toList();
    final regulars = cell.where((l) => !l.isChange).toList();
    if (showChanges && changes.isNotEmpty) {
      result.addAll(changes.where((l) => !l.isEvent));
    } else {
      result.addAll(regulars);
    }
  }
  return result;
}
