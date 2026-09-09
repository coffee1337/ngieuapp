import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngieuapp/app/features/notifications/notifications_provider.dart';
import 'package:ngieuapp/app/features/notifications/reschedule_notifications.dart';
import 'package:ngieuapp/app/features/settings/data/settings_providers.dart';
import 'package:ngieuapp/app/features/settings/domain/app_settings.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _SettingsSection(
            title: 'Внешний вид',
            icon: Icons.palette_outlined,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final option in const [
                      (
                        mode: AppThemeMode.system,
                        label: 'Система',
                        icon: Icons.brightness_auto_outlined,
                      ),
                      (
                        mode: AppThemeMode.light,
                        label: 'Светлая',
                        icon: Icons.light_mode_outlined,
                      ),
                      (
                        mode: AppThemeMode.dark,
                        label: 'Тёмная',
                        icon: Icons.dark_mode_outlined,
                      ),
                    ])
                      ChoiceChip(
                        avatar: Icon(option.icon, size: 18),
                        label: Text(option.label),
                        selected: s.themeMode == option.mode,
                        onSelected: (_) => notifier.setThemeMode(option.mode),
                      ),
                  ],
                ),
              ),
            ],
          ),
          _SettingsSection(
            title: 'Размер шрифта',
            icon: Icons.text_fields_rounded,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: SegmentedButton<AppFontScale>(
                  showSelectedIcon: false,
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
            ],
          ),
          _SettingsSection(
            title: 'Расписание',
            icon: Icons.calendar_today_outlined,
            children: [
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(
                  'Свободная аудитория: длительность в минутах',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: SegmentedButton<int>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: 30, label: Text('30')),
                    ButtonSegment(value: 45, label: Text('45')),
                    ButtonSegment(value: 60, label: Text('60')),
                    ButtonSegment(value: 90, label: Text('90')),
                  ],
                  selected: {s.defaultFreeRoomDurationMinutes},
                  onSelectionChanged: (sel) =>
                      notifier.setDefaultFreeRoomDurationMinutes(sel.first),
                ),
              ),
            ],
          ),
          _SettingsSection(
            title: 'Новости',
            icon: Icons.article_outlined,
            children: [
              SwitchListTile(
                title: const Text('Показывать изображения в новостях'),
                subtitle: const Text('Отключите, чтобы экономить трафик'),
                value: s.showNewsImages,
                onChanged: notifier.setShowNewsImages,
              ),
            ],
          ),
          _SettingsSection(
            title: 'Виджет',
            icon: Icons.widgets_outlined,
            children: [
              SwitchListTile(
                title: const Text('Обновлять виджет «Следующая пара»'),
                subtitle: const Text('Для виджета на домашнем экране'),
                value: s.homeWidgetEnabled,
                onChanged: notifier.setHomeWidgetEnabled,
              ),
              SwitchListTile(
                title: const Text('В виджете показывать аудиторию'),
                subtitle: const Text('Отключите, чтобы скрыть аудиторию'),
                value: s.homeWidgetShowRoom,
                onChanged: s.homeWidgetEnabled
                    ? notifier.setHomeWidgetShowRoom
                    : null,
              ),
            ],
          ),
          _SettingsSection(
            title: 'Уведомления',
            icon: Icons.notifications_none_rounded,
            children: [
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: SegmentedButton<int>(
                    showSelectedIcon: false,
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
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });
  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: Row(
              children: [
                Icon(icon, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
              ],
            ),
          ),
          Card(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
