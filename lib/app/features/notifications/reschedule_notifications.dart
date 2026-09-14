import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ngieuapp/app/features/notifications/notification_sync_provider.dart';

Future<void> rescheduleNotifications(WidgetRef ref) async {
  final refresh = ref.refresh(notificationSyncProvider.future);
  await refresh;
}
