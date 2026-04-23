import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/date_ext.dart';
import '../../../shared/widgets/app_gradient_bar.dart';
import '../../../shared/widgets/empty_view.dart';
import '../../../shared/widgets/error_view.dart';
import '../data/schedule_providers.dart';
import '../domain/classroom_availability.dart';

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

  bool _isLoadingAll = false;
  int _loadedCount = 0;
  int _totalCount = 0;

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

  Future<void> _loadAllSchedules() async {
    if (_isLoadingAll) return;

    final groups = await ref.read(studentGroupsProvider.future);
    setState(() {
      _isLoadingAll = true;
      _totalCount = groups.length;
      _loadedCount = 0;
    });

    final repo = ref.read(scheduleRepositoryProvider);
    final weekStart = DateTime.now().startOfWeek;

    for (final g in groups) {
      if (!mounted) break;
      try {
        // Подписываемся на стрим и берём первое значение — это триггерит сетевой запрос и кэш
        await repo.watchWeek(g.id, weekStart).first.timeout(
              const Duration(seconds: 20),
              onTimeout: () => const <dynamic>[] as dynamic,
            );
      } catch (_) {
        // игнорируем, чтобы не прерывать процесс
      }
      if (mounted) {
        setState(() => _loadedCount++);
      }
    }

    if (mounted) {
      setState(() => _isLoadingAll = false);
      // Переснимаем результаты
      ref.invalidate(freeRoomsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('EEEE, d MMMM', 'ru_RU');

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
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      setState(() => _searched = true);
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Найти'),
                  ),
                ),
                const SizedBox(height: 8),
                _LoadAllBanner(
                  isLoading: _isLoadingAll,
                  loaded: _loadedCount,
                  total: _totalCount,
                  onTap: _loadAllSchedules,
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
        text: 'Выберите дату и время,\nнажмите «Найти»',
        icon: Icons.search,
      );
    }
    final key = (
      date: _date,
      fromHour: _from.hour,
      fromMinute: _from.minute,
      toHour: _to.hour,
      toMinute: _to.minute,
    );
    final asyncValue = ref.watch(freeRoomsProvider(key));
    return asyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(error: e),
      data: (rooms) {
        if (rooms.isEmpty) {
          return const EmptyView(
            text:
                'Свободных аудиторий не найдено.\nВозможно, нужно загрузить\nрасписание всех групп выше.',
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

class _LoadAllBanner extends StatelessWidget {
  const _LoadAllBanner({
    required this.isLoading,
    required this.loaded,
    required this.total,
    required this.onTap,
  });

  final bool isLoading;
  final int loaded;
  final int total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isLoading
                ? 'Загружаю расписание: $loaded / $total групп'
                : 'Для точного поиска загрузите расписание всех групп',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 6),
          if (isLoading)
            LinearProgressIndicator(
              value: total == 0 ? null : loaded / total,
              minHeight: 4,
            )
          else
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.cloud_download_outlined, size: 18),
                label: const Text('Загрузить все группы'),
              ),
            ),
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
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(label, overflow: TextOverflow.ellipsis),
              ),
              const Icon(Icons.arrow_drop_down),
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
    final fmt = DateFormat('HH:mm');
    return Card(
      margin: EdgeInsets.zero,
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${fmt.format(room.freeFrom)} — ${fmt.format(room.freeUntil)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}