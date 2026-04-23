import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_gradient_bar.dart';
import '../data/settings_providers.dart';
import '../domain/app_settings.dart';

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
          preferredSize: Size.fromHeight(4),
          child: AppGradientBar(),
        ),
      ),
      body: ListView(
        children: [
          _SectionTitle('Внешний вид'),
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
          _SectionTitle('Размер шрифта'),
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
          _SectionTitle('Расписание'),
          SwitchListTile(
            title: const Text('Показывать замены и изменения'),
            subtitle: const Text(
              'Если выключить — покажет плановое расписание\nбез изменений и мероприятий',
            ),
            value: s.showChanges,
            onChanged: notifier.setShowChanges,
          ),
          const SizedBox(height: 16),
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