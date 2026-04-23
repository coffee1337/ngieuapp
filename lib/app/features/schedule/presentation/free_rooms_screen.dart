import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/app_gradient_bar.dart';
import '../../../shared/widgets/empty_view.dart';
import '../../../shared/widgets/error_view.dart';
import '../data/schedule_providers.dart';
import '../domain/classroom_availability.dart';

/// Глобальный лоадер — выживает между открытиями экрана.
class BackgroundLoaderState {
  const BackgroundLoaderState({
    required this.isLoading,
    required this.loaded,
    required this.total,
  });
  final bool isLoading;
  final int loaded;
  final int total;

  double? get progress => total == 0 ? null : loaded / total;
}

class BackgroundLoaderNotifier extends StateNotifier<BackgroundLoaderState> {
  BackgroundLoaderNotifier(this._ref)
      : super(const BackgroundLoaderState(
          isLoading: false,
          loaded: 0,
          total: 0,
        ));

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
    );

    final apiDs = _ref.read(scheduleApiDataSourceProvider);
    final dbDs = _ref.read(scheduleDbDataSourceProvider);

    const batchSize = 5;
    for (var i = 0; i < groups.length; i += batchSize) {
      final batch = groups.skip(i).take(batchSize).toList();
      await Future.wait(batch.map((g) async {
        try {
          final lessons = await apiDs
              .fetchSchedule(g.id)
              .timeout(const Duration(seconds: 15));
          await dbDs.replaceForActor(g.id, lessons);
        } catch (_) {
          // skip
        }
        state = BackgroundLoaderState(
          isLoading: true,
          loaded: state.loaded + 1,
          total: state.total,
        );
      }));
    }

    state = BackgroundLoaderState(
      isLoading: false,
      loaded: state.loaded,
      total: state.total,
    );
    _ref.invalidate(freeRoomsProvider);
    _completer?.complete();
  }
}

final backgroundLoaderProvider =
    StateNotifierProvider<BackgroundLoaderNotifier, BackgroundLoaderState>(
        (ref) {
  return BackgroundLoaderNotifier(ref);
});

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
  String? _buildingFilter;

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
      setState(() {
        if (isFrom) {
          _from = picked;
        } else {
          _to = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('EEEE, d MMMM', 'ru_RU');
    final loader = ref.watch(backgroundLoaderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Свободные аудитории'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: AppGradientBar(),
        ),
      ),
      body: Column(
        children: [
          // Loading banner - more prominent with animation
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: loader.isLoading
                ? _LoadingBanner(loader: loader)
                : const SizedBox.shrink(),
          ),
          // Parameters card
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _RowButton(
                  icon: Icons.calendar_today_outlined,
                  label: dateFmt.format(_date),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _RowButton(
                        icon: Icons.schedule,
                        label: 'С ${_from.format(context)}',
                        onTap: () => _pickTime(true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _RowButton(
                        icon: Icons.schedule_outlined,
                        label: 'До ${_to.format(context)}',
                        onTap: () => _pickTime(false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Filter chips
                _FilterChips(
                  minDuration: _minDurationMinutes,
                  buildingFilter: _buildingFilter,
                  onMinDurationChanged: (v) =>
                      setState(() => _minDurationMinutes = v),
                  onBuildingChanged: (v) =>
                      setState(() => _buildingFilter = v),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: loader.isLoading
                        ? null
                        : () {
                            setState(() => _searched = true);
                          },
                    icon: const Icon(Icons.search),
                    label: const Text('Найти'),
                  ),
                ),
                if (!loader.isLoading && loader.loaded == 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ref.read(backgroundLoaderProvider.notifier).run();
                        },
                        icon: const Icon(Icons.cloud_download_outlined, size: 18),
                        label: const Text('Загрузить расписание всех групп'),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
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
      buildingFilter: _buildingFilter ?? '',
    );
    final asyncValue = ref.watch(freeRoomsProvider(key));
    return asyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(error: e),
      data: (rooms) {
        if (rooms.isEmpty) {
          return const EmptyView(
            text: 'Свободных аудиторий не найдено.\n'
                'Попробуйте загрузить расписание\n'
                'всех групп кнопкой выше.',
            icon: Icons.meeting_room_outlined,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: rooms.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) => _RoomCard(room: rooms[i]),
        );
      },
    );
  }
}

class _LoadingBanner extends StatelessWidget {
  const _LoadingBanner({required this.loader});
  final BackgroundLoaderState loader;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.tertiaryContainer.withValues(alpha: 0.5)
            : theme.colorScheme.tertiaryContainer,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: theme.colorScheme.onTertiaryContainer,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Загрузка расписания: ${loader.loaded} из ${loader.total} групп',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onTertiaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: loader.progress,
              minHeight: 6,
              backgroundColor:
                  theme.colorScheme.onTertiaryContainer.withValues(alpha: 0.15),
              color: theme.colorScheme.onTertiaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Данные загружаются в фоне. Вы можете искать аудитории\nпосле завершения загрузки для более точных результатов.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onTertiaryContainer.withValues(alpha: 0.7),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.minDuration,
    required this.buildingFilter,
    required this.onMinDurationChanged,
    required this.onBuildingChanged,
  });

  final int minDuration;
  final String? buildingFilter;
  final ValueChanged<int> onMinDurationChanged;
  final ValueChanged<String?> onBuildingChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chip(
            context,
            label: 'От $minDuration мин',
            icon: Icons.timer_outlined,
            onTap: () async {
              final picked = await showModalBottomSheet<int>(
                context: context,
                builder: (_) => _MinDurationSheet(current: minDuration),
              );
              if (picked != null) onMinDurationChanged(picked);
            },
          ),
          const SizedBox(width: 8),
          _chip(
            context,
            label: buildingFilter == null
                ? 'Любой корпус'
                : 'Корпус: $buildingFilter',
            icon: Icons.apartment_outlined,
            active: buildingFilter != null,
            onTap: () async {
              final picked = await showModalBottomSheet<String?>(
                context: context,
                builder: (_) => _BuildingSheet(current: buildingFilter),
              );
              // null means "didn't change", empty string = reset
              if (picked != null) {
                onBuildingChanged(picked.isEmpty ? null : picked);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool active = false,
  }) {
    final theme = Theme.of(context);
    final bg = active
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surfaceContainerHighest;
    final fg = active
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurface;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 16, color: fg),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(width: 4),
              Icon(Icons.arrow_drop_down, size: 18, color: fg),
            ],
          ),
        ),
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
            padding: const EdgeInsets.all(16),
            child: Text(
              'Минимальная длительность',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          for (final m in options)
            RadioListTile<int>(
              title: Text('$m мин'),
              value: m,
              groupValue: current,
              onChanged: (v) => Navigator.pop(context, v),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _BuildingSheet extends StatelessWidget {
  const _BuildingSheet({required this.current});
  final String? current;

  @override
  Widget build(BuildContext context) {
    const options = <String>['', 'А', 'Б', 'В', 'Г'];
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Корпус',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          for (final b in options)
            RadioListTile<String>(
              title: Text(b.isEmpty ? 'Любой' : 'Корпус $b'),
              value: b,
              groupValue: current ?? '',
              onChanged: (v) => Navigator.pop(context, v ?? ''),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _RowButton extends StatelessWidget {
  const _RowButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.onSurface),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.arrow_drop_down, color: theme.colorScheme.onSurfaceVariant),
            ],
          ),
        ),
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
    final isDark = theme.brightness == Brightness.dark;
    final fmt = DateFormat('HH:mm');

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: isDark
            ? BorderSide(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
                width: 0.5,
              )
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.meeting_room,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.building.isEmpty
                        ? 'Ауд. ${room.classroom}'
                        : 'Ауд. ${room.classroom} (${room.building})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${fmt.format(room.freeFrom)} — ${fmt.format(room.freeUntil)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _durationText(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
