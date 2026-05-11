import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ngieuapp/app/core/network/dio_client.dart';

final scheduleApiProvider = Provider<Dio>((ref) {
  return DioClient.createScheduleApi();
});

final newsApiProvider = Provider<Dio>((ref) {
  return DioClient.createNewsClient();
});
