import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ngieuapp/app/features/schedule/presentation/free_rooms/background_loader_notifier.dart';
import 'package:ngieuapp/app/features/schedule/presentation/free_rooms/filter_sheets.dart';
import 'package:ngieuapp/app/shared/widgets/app_components.dart';
import 'package:ngieuapp/app/theme/app_theme.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

class FreeRoomsFilterPanel extends StatelessWidget {
  const FreeRoomsFilterPanel({
    required this.semantic,
    required this.dateFmt,
    required this.date,
    required this.from,
    required this.to,
    required this.minDurationMinutes,
    required this.instituteFilter,
    required this.loader,
    required this.onPickDate,
    required this.onPickTimeFrom,
    required this.onPickTimeTo,
    required this.onDurationPicked,
    required this.onInstitutePicked,
    required this.onSearch,
    required this.onLoadSchedule,
    required this.shortInstitute,
    super.key,
  });

  final AppSemanticColors semantic;
  final DateFormat dateFmt;
  final DateTime date;
  final TimeOfDay from;
  final TimeOfDay to;
  final int minDurationMinutes;
  final String? instituteFilter;
  final BackgroundLoaderState loader;
  final VoidCallback onPickDate;
  final VoidCallback onPickTimeFrom;
  final VoidCallback onPickTimeTo;
  final ValueChanged<int> onDurationPicked;
  final ValueChanged<String> onInstitutePicked;
  final VoidCallback onSearch;
  final VoidCallback onLoadSchedule;
  final String Function(String) shortInstitute;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.md,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: AppRadius.xxlBr,
          border: Border.all(color: semantic.cardBorder),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: AppRadius.lgBr,
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: scheme.primary,
                    size: AppSizes.iconLg,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Параметры поиска',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Выберите дату, время и длительность',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            AppCompactField(
              icon: Icons.calendar_today_rounded,
              label: dateFmt.format(date),
              onTap: onPickDate,
              active: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            LayoutBuilder(
              builder: (context, constraints) {
                final useColumns = constraints.maxWidth >= 300;
                final fieldWidth = useColumns
                    ? (constraints.maxWidth - AppSpacing.sm) / 2
                    : constraints.maxWidth;
                return Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    SizedBox(
                      width: fieldWidth,
                      child: AppCompactField(
                        icon: Icons.schedule_rounded,
                        label: 'С ${from.format(context)}',
                        onTap: onPickTimeFrom,
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: AppCompactField(
                        icon: Icons.schedule_outlined,
                        label: 'До ${to.format(context)}',
                        onTap: onPickTimeTo,
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: AppCompactField(
                        icon: Icons.timer_outlined,
                        label: 'От $minDurationMinutes мин',
                        onTap: () async {
                          final picked = await showModalBottomSheet<int>(
                            context: context,
                            builder: (_) =>
                                MinDurationSheet(current: minDurationMinutes),
                          );
                          if (picked != null) onDurationPicked(picked);
                        },
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: AppCompactField(
                        icon: Icons.school_outlined,
                        label: instituteFilter != null
                            ? shortInstitute(instituteFilter!)
                            : 'Все институты',
                        active: instituteFilter != null,
                        onTap: () async {
                          final picked = await showModalBottomSheet<String?>(
                            context: context,
                            builder: (_) =>
                                InstituteSheet(current: instituteFilter),
                          );
                          if (picked != null) onInstitutePicked(picked);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            AppPrimaryButton(
              onPressed: onSearch,
              label: loader.isLoading
                  ? 'Подготавливаем расписание'
                  : 'Найти аудитории',
              icon: loader.isLoading
                  ? Icons.sync_rounded
                  : Icons.search_rounded,
              enabled: !loader.isLoading,
            ),
            if (!loader.isLoading &&
                loader.loaded == 0 &&
                !loader.shouldAutoLoad)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeightSm,
                  child: OutlinedButton.icon(
                    onPressed: onLoadSchedule,
                    icon: const Icon(
                      Icons.cloud_download_rounded,
                      size: AppSizes.iconSm,
                    ),
                    label: Text(
                      'Загрузить расписание',
                      style: theme.textTheme.bodySmall,
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: scheme.primary),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.mdBr,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
