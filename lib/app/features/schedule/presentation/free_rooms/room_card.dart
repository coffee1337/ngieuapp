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
    final isStandard = ClassroomUtils.isStandardRoomNumber(room.classroom);
    final roomInfo = FloorUtils.getRoomLocationInfo(room.classroom);
    final formattedFloor = roomInfo.floor != null
        ? FloorUtils.formatFloor(roomInfo.floor!)
        : null;

    return Card(
      margin: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
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
