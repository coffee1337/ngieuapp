import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngieuapp/app/features/notifications/notifications_provider.dart';
import 'package:ngieuapp/app/features/notifications/reschedule_notifications.dart';
import 'package:ngieuapp/app/features/notifications/notifications_service.dart';
import 'package:ngieuapp/app/features/settings/data/navigation_settings_providers.dart';
import 'package:ngieuapp/app/features/settings/data/settings_providers.dart';
import 'package:ngieuapp/app/features/settings/data/smart_notification_settings_providers.dart';
import 'package:ngieuapp/app/features/settings/data/visual_style_providers.dart';
import 'package:ngieuapp/app/features/settings/domain/app_navigation_settings.dart';
import 'package:ngieuapp/app/features/settings/domain/app_settings.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';
import 'package:ngieuapp/app/theme/app_visual_style.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);
    final visualStyle = ref.watch(visualStyleProvider);
    final visualStyleNotifier = ref.read(visualStyleProvider.notifier);
    final navigation = ref.watch(navigationSettingsProvider);
    final navigationNotifier = ref.read(navigationSettingsProvider.notifier);
    final smartNotifications = ref.watch(smartNotificationSettingsProvider);
    final smartNotificationsNotifier = ref.read(
      smartNotificationSettingsProvider.notifier,
    );

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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Стиль оформления',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
              for (final style in AppVisualStyle.values)
                _VisualStyleTile(
                  style: style,
                  selected: visualStyle == style,
                  onTap: () => visualStyleNotifier.setStyle(style),
                ),
              const Divider(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Режим яркости',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                        onSelected: visualStyle == AppVisualStyle.amoled
                            ? null
                            : (_) => notifier.setThemeMode(option.mode),
                      ),
                  ],
                ),
              ),
              if (visualStyle == AppVisualStyle.amoled)
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    'AMOLED использует полностью тёмный режим независимо от системной темы.',
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
            title: 'Навигация',
            icon: Icons.space_dashboard_outlined,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: DropdownButtonFormField<AppTab>(
                  key: ValueKey(navigation.defaultTab),
                  initialValue: navigation.defaultTab,
                  decoration: const InputDecoration(
                    labelText: 'Открывать при запуске',
                    prefixIcon: Icon(Icons.rocket_launch_outlined),
                  ),
                  items: [
                    for (final tab in AppTab.values)
                      DropdownMenuItem(value: tab, child: Text(tab.label)),
                  ],
                  onChanged: (tab) {
                    if (tab != null) navigationNotifier.setDefaultTab(tab);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  'Вкладки в нижнем меню',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              for (final tab in AppTab.values)
                SwitchListTile(
                  secondary: Icon(_tabIcon(tab)),
                  title: Text(tab.label),
                  subtitle: tab == navigation.defaultTab
                      ? const Text('Стартовая вкладка')
                      : null,
                  value: navigation.visibleTabs.contains(tab),
                  onChanged: (visible) async {
                    final changed = await navigationNotifier.setTabVisible(
                      tab,
                      visible: visible,
                    );
                    if (!changed && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Оставьте хотя бы одну вкладку'),
                        ),
                      );
                    }
                  },
                ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Text(
                  'Скрытые разделы останутся доступны через вкладку «Ещё».',
                ),
              ),
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
            title: 'Виджеты',
            icon: Icons.widgets_outlined,
            children: [
              SwitchListTile(
                title: const Text('Обновлять виджеты расписания'),
                subtitle: const Text(
                  'Android: 1×1, 2×1, 1×2 и большие · '
                  'iPhone: малый, средние и большой',
                ),
                value: s.homeWidgetEnabled,
                onChanged: (value) async {
                  await notifier.setHomeWidgetEnabled(value);
                },
              ),
              const ListTile(
                leading: Icon(Icons.view_quilt_outlined),
                title: Text('Доступные варианты'),
                subtitle: Text(
                  'Компактные варианты · Три ближайшие пары · '
                  'Расписание на сегодня',
                ),
              ),
              SwitchListTile(
                title: const Text('В виджете показывать аудиторию'),
                subtitle: const Text('Отключите, чтобы скрыть аудиторию'),
                value: s.homeWidgetShowRoom,
                onChanged: s.homeWidgetEnabled
                    ? (value) async {
                        await notifier.setHomeWidgetShowRoom(value);
                      }
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
                          SnackBar(
                            content: const Text(
                              'Разрешение не предоставлено. Включите уведомления в настройках телефона.',
                            ),
                            action: SnackBarAction(
                              label: 'Открыть',
                              onPressed: _openNotificationSettings,
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
                SwitchListTile(
                  secondary: const Icon(Icons.change_circle_outlined),
                  title: const Text('Сообщать об изменениях'),
                  subtitle: const Text('Отмены, переносы и замены аудитории'),
                  value: smartNotifications.scheduleChangesEnabled,
                  onChanged: (value) => smartNotificationsNotifier.update(
                    smartNotifications.copyWith(scheduleChangesEnabled: value),
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.bedtime_outlined),
                  title: const Text('Тихие часы'),
                  subtitle: Text(
                    '${smartNotifications.quietHoursStart.toString().padLeft(2, '0')}:00–'
                    '${smartNotifications.quietHoursEnd.toString().padLeft(2, '0')}:00 · изменения придут без звука',
                  ),
                  value: smartNotifications.quietHoursEnabled,
                  onChanged: (value) async {
                    await smartNotificationsNotifier.update(
                      smartNotifications.copyWith(quietHoursEnabled: value),
                    );
                    await rescheduleNotifications(ref);
                  },
                ),
                if (smartNotifications.quietHoursEnabled)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            key: ValueKey(
                              'quiet-start-${smartNotifications.quietHoursStart}',
                            ),
                            initialValue: smartNotifications.quietHoursStart,
                            decoration: const InputDecoration(
                              labelText: 'Начало',
                            ),
                            items: [
                              for (var hour = 0; hour < 24; hour++)
                                DropdownMenuItem(
                                  value: hour,
                                  child: Text(
                                    '${hour.toString().padLeft(2, '0')}:00',
                                  ),
                                ),
                            ],
                            onChanged: (hour) async {
                              if (hour == null) return;
                              await smartNotificationsNotifier.update(
                                smartNotifications.copyWith(
                                  quietHoursStart: hour,
                                ),
                              );
                              await rescheduleNotifications(ref);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            key: ValueKey(
                              'quiet-end-${smartNotifications.quietHoursEnd}',
                            ),
                            initialValue: smartNotifications.quietHoursEnd,
                            decoration: const InputDecoration(
                              labelText: 'Окончание',
                            ),
                            items: [
                              for (var hour = 0; hour < 24; hour++)
                                DropdownMenuItem(
                                  value: hour,
                                  child: Text(
                                    '${hour.toString().padLeft(2, '0')}:00',
                                  ),
                                ),
                            ],
                            onChanged: (hour) async {
                              if (hour == null) return;
                              await smartNotificationsNotifier.update(
                                smartNotifications.copyWith(
                                  quietHoursEnd: hour,
                                ),
                              );
                              await rescheduleNotifications(ref);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                SwitchListTile(
                  secondary: const Icon(Icons.volume_up_outlined),
                  title: const Text('Звук'),
                  value: smartNotifications.soundEnabled,
                  onChanged: (value) async {
                    await smartNotificationsNotifier.update(
                      smartNotifications.copyWith(soundEnabled: value),
                    );
                    await rescheduleNotifications(ref);
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.vibration_rounded),
                  title: const Text('Вибрация'),
                  value: smartNotifications.vibrationEnabled,
                  onChanged: (value) async {
                    await smartNotificationsNotifier.update(
                      smartNotifications.copyWith(vibrationEnabled: value),
                    );
                    await rescheduleNotifications(ref);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notification_add_outlined),
                  title: const Text('Проверить уведомление'),
                  subtitle: const Text('Отправить тест прямо сейчас'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () async {
                    await ref
                        .read(notificationsServiceProvider)
                        .showTestNotification(preferences: smartNotifications);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Тестовое уведомление отправлено'),
                        ),
                      );
                    }
                  },
                ),
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

  IconData _tabIcon(AppTab tab) => switch (tab) {
    AppTab.news => Icons.article_outlined,
    AppTab.schedule => Icons.calendar_today_outlined,
    AppTab.campus => Icons.map_outlined,
    AppTab.profile => Icons.person_outline,
    AppTab.learning => Icons.school_outlined,
  };

  static void _openNotificationSettings() {
    NotificationsService.instance.openSystemSettings();
  }
}

class _VisualStyleTile extends StatelessWidget {
  const _VisualStyleTile({
    required this.style,
    required this.selected,
    required this.onTap,
  });

  final AppVisualStyle style;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = switch (style) {
      AppVisualStyle.material => const [
        Color(0xFF9F003D),
        Color(0xFF4A5E89),
        Color(0xFFFFA300),
      ],
      AppVisualStyle.glass => const [
        Color(0xFF6046C6),
        Color(0xFF006A8E),
        Color(0xFFFF72B6),
      ],
      AppVisualStyle.university => const [
        Color(0xFF173B67),
        Color(0xFF8C1D40),
        Color(0xFFD5A62E),
      ],
      AppVisualStyle.amoled => const [
        Colors.black,
        Color(0xFFFF6F9E),
        Color(0xFF9CACCA),
      ],
    };

    return AnimatedContainer(
      duration: AppDurations.fast,
      color: selected
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.55)
          : Colors.transparent,
      child: ListTile(
        onTap: onTap,
        leading: SizedBox(
          width: 54,
          child: Stack(
            children: [
              for (var index = 0; index < colors.length; index++)
                Positioned(
                  left: index * 15,
                  top: 5,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: colors[index],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.surface,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        title: Text(style.label),
        subtitle: Text(style.description),
        trailing: Icon(
          selected
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
        ),
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
