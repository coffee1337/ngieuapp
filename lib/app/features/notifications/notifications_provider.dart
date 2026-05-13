import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngieuapp/app/features/notifications/notifications_service.dart';
import 'package:ngieuapp/app/features/notifications/schedule_change_notifications_service.dart';
import 'package:ngieuapp/app/features/notifications/sent_schedule_change_notifications_datasource.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_providers.dart';
import 'package:ngieuapp/app/features/schedule/domain/usecases/detect_schedule_change_notifications.dart';

final notificationsServiceProvider = Provider<NotificationsService>((ref) {
  return NotificationsService.instance;
});

final sentScheduleChangeNotificationsDataSourceProvider =
    Provider<SentScheduleChangeNotificationsDataSource>((ref) {
      return SentScheduleChangeNotificationsDataSource(
        ref.watch(appDatabaseProvider),
      );
    });

final detectScheduleChangeNotificationsProvider =
    Provider<DetectScheduleChangeNotifications>((ref) {
      return const DetectScheduleChangeNotifications();
    });

final scheduleChangeNotificationsServiceProvider =
    Provider<ScheduleChangeNotificationsService>((ref) {
      return ScheduleChangeNotificationsService(
        ref.watch(notificationsServiceProvider),
        ref.watch(sentScheduleChangeNotificationsDataSourceProvider),
        ref.watch(detectScheduleChangeNotificationsProvider),
      );
    });
