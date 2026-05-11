import 'package:flutter/material.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

class MinDurationSheet extends StatelessWidget {
  const MinDurationSheet({required this.current, super.key});
  final int current;

  @override
  Widget build(BuildContext context) {
    const options = [15, 30, 45, 60, 90, 120, 180];
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Text(
              'Минимальная длительность',
              style: theme.textTheme.titleMedium,
            ),
          ),
          for (final m in options)
            RadioListTile<int>(
              title: Text('$m мин'),
              value: m,
              groupValue: current,
              onChanged: (v) => Navigator.pop(context, v),
            ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class InstituteSheet extends StatelessWidget {
  const InstituteSheet({required this.current, super.key});
  final String? current;

  @override
  Widget build(BuildContext context) {
    final options = [
      {'value': '', 'label': 'Любой институт'},
      {
        'value': 'Институт экономики и управления',
        'label': 'Институт экономики и управления',
      },
      {
        'value': 'Институт информационных технологий и систем связи',
        'label': 'Институт информационных технологий и систем связи',
      },
      {'value': 'Инженерный институт', 'label': 'Инженерный институт'},
    ];

    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Text('Институт', style: theme.textTheme.titleMedium),
          ),
          for (final option in options)
            RadioListTile<String>(
              title: Text(
                option['label']!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              value: option['value']!,
              groupValue: current ?? '',
              onChanged: (v) => Navigator.pop(context, v ?? ''),
            ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
