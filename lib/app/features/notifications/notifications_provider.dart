import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngieuapp/app/features/notifications/notifications_service.dart';

final notificationsServiceProvider = Provider<NotificationsService>((ref) {
  return NotificationsService.instance;
});
