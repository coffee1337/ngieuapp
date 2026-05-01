import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/app_components.dart';
import '../../../shared/widgets/app_gradient_bar.dart';
import '../../../shared/widgets/empty_view.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_tokens.dart';
import '../data/schedule_providers.dart';
import '../domain/classroom_availability.dart';
import '../domain/utils/classroom_utils.dart';
import '../domain/utils/floor_utils.dart';

/// Background loader state -- survives between screen opens.
class BackgroundLoaderState {
  const BackgroundLoaderState({
    required this.isLoading,
    required this.loaded,
    required this.total,
    required this.lastRunTime,
    required this.shouldAutoLoad,
  });
  final bool isLoading;
  final int loaded;
  final int total;
  final DateTime? lastRunTime;
  final bool shouldAutoLoad;

  double? get progress => total == 0 ? null : loaded / total;

  bool get shouldRunAutomatically {
    if (!shouldAutoLoad) return false;
    if (isLoading) return false;
    if (lastRunTime == null) return true;
    final now = DateTime.now();
    final elapsed = now.difference(lastRunTime!);
    if (loaded < total * 0.5) return true;
    if (elapsed > const Duration(hours: 2)) return true;
    if (elapsed > const Duration(minutes: 30) && loaded < total) return true;
    return false;
  }
}

class BackgroundLoaderNotifier extends StateNotifier<BackgroundLoaderState> {
  BackgroundLoaderNotifier(this._ref)
    : super(
        const BackgroundLoaderState(
          isLoading: false,
          loaded: 0,
          total: 0,
          lastRunTime: null,
          shouldAutoLoad: true,
        ),
      );

  final Ref _ref;
  Completer<void>? _completer;

  Future<void> run() async {
    if (state.isLoading) return _completer?.future;
    _completer = Completer<void>();

    final groups = await _ref.read(studentGroupsProvider.future);
    state = BackgroundLoaderState(
      isLoading: true,
      loaded: 0,
      total: groups.length,
      lastRunTime: state.lastRunTime,
      shouldAutoLoad: state.shouldAutoLoad,
    );

    final apiDs = _ref.read(scheduleApiDataSourceProvider);
    final dbDs = _ref.read(scheduleDbDataSourceProvider);
    _ref.invalidate(freeRoomsProvider);

    const batchSize = 3;
    var loadedCount = 0;

    await Future.doWhile(() async {
      if (loadedCount >= groups.length) return false;
      final batch = groups.skip(loadedCount).take(batchSize).toList();
      try {
        await Future.wait(
          batch.map((g) async {
            try {
              final lessons = await apiDs
                  .fetchSchedule(g.id)
                  .timeout(const Duration(seconds: 10));
              await dbDs.replaceForActor(g.id, lessons);
            } catch (_) {}
            loadedCount++;
            state = BackgroundLoaderState(
              isLoading: true,
              loaded: loadedCount,
              total: groups.length,
              lastRunTime: state.lastRunTime,
              shouldAutoLoad: state.shouldAutoLoad,
            );
          }),
        );
      } catch (_) {
        loadedCount += batch.length;
      }
      await Future.delayed(const Duration(milliseconds: 50));
      return true;
    });

    state = BackgroundLoaderState(
      isLoading: false,
      loaded: loadedCount,
      total: groups.length,
      lastRunTime: DateTime.now(),
      shouldAutoLoad: state.shouldAutoLoad,
    );
    _ref.invalidate(freeRoomsProvider);
    _completer?.complete();
  }

  Future<void> runIfNeeded() async {
    if (state.shouldRunAutomatically) await run();
  }

  void setAutoLoad(bool enabled) {
    state = BackgroundLoaderState(
      isLoading: state.isLoading,
      loaded: state.loaded,
      total: state.total,
      lastRunTime: state.lastRunTime,
      shouldAutoLoad: enabled,
    );
  }

  void resetLastRunTime() {
    state = BackgroundLoaderState(
      isLoading: state.isLoading,
      loaded: state.loaded,
      total: state.total,
      lastRunTime: null,
      shouldAutoLoad: state.shouldAutoLoad,
    );
  }
}

final backgroundLoaderProvider =
    StateNotifierProvider<BackgroundLoaderNotifier, BackgroundLoaderState>(
  (ref) => BackgroundLoaderNotifier(ref),
);

// ---------------------------------------------------------------------------

class FreeRoomsScreen extends ConsumerStatefulWidget {
  const FreeRoomsScreen({super.key});

  @override
  ConsumerState<FreeRoomsScreen> createState() => _FreeRoomsScreenState();
}

class _FreeRoomsScreenState extends ConsumerState<FreeRoomsScreen> {
  DateTime _date = DateTime.now();
  TimeOfDay _from = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay _to = const TimeOfDay(hour: 12, minute: 0);
  bool _searched = false;
  int _minDurationMinutes = 45;
  String? _instituteFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(backgroundLoaderProvider.notifier).runIfNeeded();
    });
  }

  String _shortInstitute(String full) {
    if (full.contains('экономики')) return 'ИЭиУ';
    if (full.contains('информационных')) return 'ИИТиСС';
    if (full.contains('Инженерный')) return 'ИИ';
    return full;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 180)),
      locale: const Locale('ru'),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime(bool isFrom) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isFrom ? _from : _to,
    );
    if (picked != null) {
      setState(() => isFrom ? _from = picked : _to = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>()!;
    final dateFmt = DateFormat('EEEE, d MMMM', 'ru_RU');
    final loader = ref.watch(backgroundLoaderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Свободные аудитории'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(AppSizes.gradientBarHeight),
          child: AppGradientBar(),
        ),
      ),
      body: Column(
        children: [
          // Loading banner
          AnimatedSize(
            duration: AppDurations.normal,
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: loader.isLoading
                ? _LoadingBanner(loader: loader)
                : const SizedBox.shrink(),
          ),
          // Filter panel
          Container(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(color: semantic.subtleDivider, width: 1),
              ),
            ),
            child: Column(
              children: [
                AppCompactField(
                  icon: Icons.calendar_today_rounded,
                  label: dateFmt.format(_date),
                  onTap: _pickDate,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: AppCompactField(
                        icon: Icons.schedule_rounded,
                        label: 'С ${_from.format(context)}',
                        onTap: () => _pickTime(true),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppCompactField(
                        icon: Icons.schedule_outlined,
                        label: 'До ${_to.format(context)}',
                        onTap: () => _pickTime(false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: AppCompactField(
                        icon: Icons.timer_outlined,
                        label: 'От $_minDurationMinutes мин',
                        onTap: () async {
                          final picked = await showModalBottomSheet<int>(
                            context: context,
                            builder: (_) =>
                                _MinDurationSheet(current: _minDurationMinutes),
                          );
                          if (picked != null) {
                            setState(() => _minDurationMinutes = picked);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppCompactField(
                        icon: Icons.school_outlined,
                        label: _instituteFilter != null
                            ? _shortInstitute(_instituteFilter!)
                            : 'Институт',
                        active: _instituteFilter != null,
                        onTap: () async {
                          final picked = await showModalBottomSheet<String?>(
                            context: context,
                            builder: (_) =>
                                _InstituteSheet(current: _instituteFilter),
                          );
                          if (picked != null) {
                            setState(
                              () => _instituteFilter =
                                  picked.isEmpty ? null : picked,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                AppPrimaryButton(
                  onPressed: () => setState(() => _searched = true),
                  label: 'Найти аудитории',
                  icon: Icons.search_rounded,
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
                        onPressed: () =>
                            ref.read(backgroundLoaderProvider.notifier).run(),
                        icon: const Icon(Icons.cloud_download_rounded,
                            size: AppSizes.iconSm),
                        label: Text(
                          'Загрузить расписание',
                          style: theme.textTheme.bodySmall,
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme.colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.mdBr,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (!_searched) {
      return const EmptyView(
        text: 'Выберите параметры\nи нажмите «Найти»',
        icon: Icons.search,
      );
    }
    final key = (
      date: _date,
      fromHour: _from.hour,
      fromMinute: _from.minute,
      toHour: _to.hour,
      toMinute: _to.minute,
      minDurationMinutes: _minDurationMinutes,
      buildingFilter: '',
      instituteFilter: _instituteFilter ?? '',
    );
    final asyncValue = ref.watch(freeRoomsProvider(key));
    return asyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(error: e),
      data: (rooms) {
        if (rooms.isEmpty) {
          return const EmptyView(
            text:
                'Свободных аудиторий не найдено.\n'
                'Попробуйте изменить параметры поиска.',
            icon: Icons.meeting_room_outlined,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.only(
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            top: AppSpacing.md,
            bottom: 80,
          ),
          itemCount: rooms.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (_, i) => _RoomCard(room: rooms[i]),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------

class _LoadingBanner extends StatelessWidget {
  const _LoadingBanner({required this.loader});
  final BackgroundLoaderState loader;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = loader.progress ?? 0;

    return Container(
      width: double.infinity,
      color: theme.colorScheme.secondaryContainer,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: AppSizes.iconMd,
                height: AppSizes.iconMd,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Загрузка расписания...',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
              Text(
                '${loader.loaded}/${loader.total}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSecondaryContainer,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: AppRadius.xsBr,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 3,
              backgroundColor:
                  theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.15),
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _MinDurationSheet extends StatelessWidget {
  const _MinDurationSheet({required this.current});
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

class _InstituteSheet extends StatelessWidget {
  const _InstituteSheet({required this.current});
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

class _RoomCard extends StatelessWidget {
  const _RoomCard({required this.room});
  final ClassroomAvailability room;

  String _durationText() {
    final h = room.freeDuration.inHours;
    final m = room.freeDuration.inMinutes.remainder(60);
    if (h > 0 && m > 0) return '$h ч $m мин';
    if (h > 0) return '$h ч';
    return '$m мин';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fmt = DateFormat('HH:mm');
    final isStandard = ClassroomUtils.isStandardRoomNumber(room.classroom);
    final roomInfo = FloorUtils.getRoomLocationInfo(room.classroom);
    final formattedFloor =
        roomInfo.floor != null ? FloorUtils.formatFloor(roomInfo.floor!) : null;

    return Card(
      margin: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left: room number + floor
            Container(
              width: isStandard
                  ? AppSizes.roomNumberColumnWidth
                  : AppSizes.roomNumberColumnWidthWide,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.lg),
                  bottomLeft: Radius.circular(AppRadius.lg),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.lg,
                horizontal: AppSpacing.sm,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    room.classroom,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: isStandard ? 17 : 12,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (formattedFloor != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: AppSpacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: AppRadius.xsBr,
                      ),
                      child: Text(
                        formattedFloor,
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                          letterSpacing: 0.1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Right: time, institute, duration
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${fmt.format(room.freeFrom)} — ${fmt.format(room.freeUntil)}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    if (roomInfo.institute != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        roomInfo.institute!,
                        style: theme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    AvailabilityBadge(text: '${_durationText()} свободно'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
