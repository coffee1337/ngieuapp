import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../domain/utils/floor_utils.dart';
import '../domain/utils/classroom_utils.dart';
import '../providers/schedule_provider.dart';

/// Экран свободных кабинетов
class FreeRoomsScreen extends HookConsumerWidget {
  const FreeRoomsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = useState<DateTime>(DateTime.now());
    final selectedTime = useState<TimeOfDay>(TimeOfDay.now());
    final freeRooms = ref.watch(freeRoomsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Свободные кабинеты'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Column(
        children: [
          _buildDateTimeSelector(context, selectedDate, selectedTime),
          Expanded(
            child: freeRooms.when(
              data: (rooms) => _buildRoomsList(context, rooms),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Ошибка: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSelector(
    BuildContext context,
    ValueNotifier<DateTime> selectedDate,
    ValueNotifier<TimeOfDay> selectedTime,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate.value,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (date != null) {
                  selectedDate.value = date;
                }
              },
              child: Text(
                DateFormat('dd.MM.yyyy').format(selectedDate.value),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: selectedTime.value,
                );
                if (time != null) {
                  selectedTime.value = time;
                }
              },
              child: Text(
                '${selectedTime.value.hour.toString().padLeft(2, '0')}:${selectedTime.value.minute.toString().padLeft(2, '0')}',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomsList(BuildContext context, List<FreeRoom> rooms) {
    if (rooms.isEmpty) {
      return const Center(
        child: Text('Свободных кабинетов нет'),
      );
    }

    return ListView.builder(
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        return _buildRoomCard(context, room);
      },
    );
  }

  Widget _buildRoomCard(BuildContext context, FreeRoom room) {
    final theme = Theme.of(context);
    final fmt = DateFormat('HH:mm');
    
    final roomInfo = FloorUtils.getRoomLocationInfo(room.classroom);
    final formattedFloor = roomInfo?.floor != null 
        ? FloorUtils.formatFloor(roomInfo!.floor)
        : null;
    final isStandard = FloorUtils.isStandardClassroom(room.classroom);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: InkWell(
        onTap: () {
          // TODO: Показать детали кабинета
        },
        child: Container(
          height: isStandard ? 100 : 80,
          decoration: BoxDecoration(
            borderRadius: AppRadius.lgBr,
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.surfaceContainerHighest,
                theme.colorScheme.surfaceContainerHigh,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              // Left: room number and floor
              Container(
                width: isStandard ? 80 : 65,
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
                      if (roomInfo?.institute != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          roomInfo!.institute!,
                          style: theme.textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.sm),
                      AvailabilityBadge(text: '${_durationText(room.freeFrom, room.freeUntil)} свободно'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _durationText(DateTime freeFrom, DateTime freeUntil) {
    final duration = freeUntil.difference(freeFrom);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return '${hours}ч ${minutes}мин';
    } else {
      return '${minutes}мин';
    }
  }
}

/// Свободный кабинет
class FreeRoom {
  final String classroom;
  final DateTime freeFrom;
  final DateTime freeUntil;

  const FreeRoom({
    required this.classroom,
    required this.freeFrom,
    required this.freeUntil,
  });
}

/// Бейдж доступности
class AvailabilityBadge extends StatelessWidget {
  final String text;

  const AvailabilityBadge({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: AppRadius.xsBr,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.primary,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
