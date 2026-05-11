import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngieuapp/app/features/notifications/notifications_provider.dart';
import 'package:ngieuapp/app/features/notifications/reschedule_notifications.dart';
import 'package:ngieuapp/app/features/settings/data/settings_providers.dart';
import 'package:ngieuapp/app/features/settings/domain/app_settings.dart';
import 'package:ngieuapp/app/shared/widgets/app_gradient_bar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(3),
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
              onSelectionChanged: (sel) => notifier.setFontScale(sel.first),
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
              await rescheduleNotifications(ref);
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
                final granted = await ref
                    .read(notificationsServiceProvider)
                    .requestPermissions();
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
              await rescheduleNotifications(ref);
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
                  await rescheduleNotifications(ref);
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
