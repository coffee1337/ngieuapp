import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ngieuapp/app/features/schedule/domain/classroom_availability.dart';
import 'package:ngieuapp/app/features/schedule/domain/utils/classroom_utils.dart';
import 'package:ngieuapp/app/features/schedule/domain/utils/floor_utils.dart';
import 'package:ngieuapp/app/shared/widgets/app_components.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({required this.room, super.key});

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
    final roomInfo = FloorUtils.getRoomLocationInfo(room.classroom);
    final floor = room.floor ?? roomInfo.floor;
    final formattedFloor = floor != null ? FloorUtils.formatFloor(floor) : null;
    final institute = room.institute.isNotEmpty
        ? room.institute
        : roomInfo.institute;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 116),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: AppSizes.roomNumberColumnWidthWide,
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.55,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.lg,
                  horizontal: AppSpacing.sm,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.door_front_door_outlined,
                      size: AppSizes.iconMd,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      room.classroom,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize:
                            ClassroomUtils.isStandardRoomNumber(room.classroom)
                            ? 17
                            : 11,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                        height: 1.15,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (formattedFloor != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        formattedFloor,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${fmt.format(room.freeFrom)} — ${fmt.format(room.freeUntil)}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      if (institute != null && institute.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          institute,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
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
      ),
    );
  }
}
