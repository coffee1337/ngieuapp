import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_gradient_bar.dart';
import '../../notifications/notifications_service.dart';
import '../../profile/data/profile_providers.dart';
import '../../schedule/data/schedule_providers.dart';
import '../../schedule/domain/lesson.dart';
import '../../../core/utils/date_ext.dart';
import '../data/settings_providers.dart';
import '../domain/app_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _rescheduleNotifications(WidgetRef ref) async {
    final settings = ref.read(appSettingsProvider);
    if (!settings.notificationsEnabled) {
      await NotificationsService.instance.cancelAll();
      return;
    }
    final identity = await ref.read(studentIdentityProvider.future);
    if (identity == null) return;

    final weekStart = DateTime.now().startOfWeek;
    final key = (actorId: identity.actorId, weekStart: weekStart);
    final rawAsync = ref.read(rawWeekScheduleProvider(key).future);
    try {
      final lessons = await rawAsync;
      // Берём только "живые" занятия — без отменённых/заменённых мероприятий
      final relevant = _applyChanges(lessons, showChanges: settings.showChanges);
      await NotificationsService.instance.rescheduleFor(
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: AppGradientBar(),
        ),
      ),
      body: ListView(
        children: [
          const _SectionTitle('Внешний вид'),
          RadioListTile<AppThemeMode>(
            title: const Text('Как в системе'),
            value: AppThemeMode.system,
            groupValue: s.themeMode,
            onChanged: (v) => v == null ? null : notifier.setThemeMode(v),
          ),
          RadioListTile<AppThemeMode>(
            title: const Text('Светлая'),
            value: AppThemeMode.light,
            groupValue: s.themeMode,
            onChanged: (v) => v == null ? null : notifier.setThemeMode(v),
          ),
          RadioListTile<AppThemeMode>(
            title: const Text('Тёмная'),
            value: AppThemeMode.dark,
            groupValue: s.themeMode,
            onChanged: (v) => v == null ? null : notifier.setThemeMode(v),
          ),
          const Divider(),
          const _SectionTitle('Размер шрифта'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<AppFontScale>(
              segments: const [
                ButtonSegment(
                  value: AppFontScale.small,
                  label: Text('A', style: TextStyle(fontSize: 12)),
                ),
                ButtonSegment(
                  value: AppFontScale.normal,
                  label: Text('A', style: TextStyle(fontSize: 16)),
                ),
                ButtonSegment(
                  value: AppFontScale.large,
                  label: Text('A', style: TextStyle(fontSize: 20)),
                ),
                ButtonSegment(
                  value: AppFontScale.huge,
                  label: Text('A', style: TextStyle(fontSize: 24)),
                ),
              ],
              selected: {s.fontScale},
              onSelectionChanged: (sel) =>
                  notifier.setFontScale(sel.first),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          const _SectionTitle('Расписание'),
          SwitchListTile(
            title: const Text('Показывать замены и изменения'),
            subtitle: const Text(
              'Если выключить — покажет плановое расписание\nбез изменений и мероприятий',
            ),
            value: s.showChanges,
            onChanged: (v) async {
              await notifier.setShowChanges(v);
              await _rescheduleNotifications(ref);
            },
          ),
          const Divider(),
          const _SectionTitle('Уведомления'),
          SwitchListTile(
            title: const Text('Напоминать о парах'),
            subtitle: Text(
              s.notificationsEnabled
                  ? 'За ${s.notificationMinutesBefore} минут до начала'
                  : 'Выключено',
            ),
            value: s.notificationsEnabled,
            onChanged: (v) async {
              if (v) {
                final granted =
                    await NotificationsService.instance.requestPermissions();
                if (!granted) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Разрешение не предоставлено. Включите уведомления в настройках телефона.',
                        ),
                      ),
                    );
                  }
                  return;
                }
              }
              await notifier.setNotificationsEnabled(v);
              await _rescheduleNotifications(ref);
            },
          ),
          if (s.notificationsEnabled) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                'За сколько минут напоминать',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 5, label: Text('5')),
                  ButtonSegment(value: 15, label: Text('15')),
                  ButtonSegment(value: 30, label: Text('30')),
                  ButtonSegment(value: 60, label: Text('60')),
                ],
                selected: {s.notificationMinutesBefore},
                onSelectionChanged: (sel) async {
                  await notifier.setNotificationMinutes(sel.first);
                  await _rescheduleNotifications(ref);
                },
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
      ),
    );
  }
}