import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/widgets/app_gradient_bar.dart';
import '../../../shared/widgets/empty_view.dart';
import '../../../shared/widgets/error_view.dart';
import '../data/schedule_providers.dart';
import '../domain/classroom_availability.dart';

part 'free_rooms_screen.g.dart';

@riverpod
Future<List<ClassroomAvailability>> freeRooms(
  FreeRoomsRef ref,
  DateTime date,
  ({int hour, int minute}) from,
  ({int hour, int minute}) to,
) {
  final uc = ref.watch(findFreeClassroomsProvider);
  return uc.call(
    date: date,
    from: TimeOfDay(hour: from.hour, minute: from.minute),
    to: TimeOfDay(hour: to.hour, minute: to.minute),
  );
}

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

    Widget buildResults() {
      if (!_searched) {
        return const EmptyView(
          text: 'Выберите дату и время,\nнажмите «Найти»',
          icon: Icons.search,
        );
      }
      final asyncValue = ref.watch(freeRoomsProvider(
        _date,
        (hour: _from.hour, minute: _from.minute),
        (hour: _to.hour, minute: _to.minute),
      ));
      return asyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(error: e),
        data: (rooms) {
          if (rooms.isEmpty) {
            return const EmptyView(
              text: 'Свободных аудиторий\nв этот интервал не найдено',
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
                      ref.invalidate(freeRoomsProvider);
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Найти'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(child: buildResults()),
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