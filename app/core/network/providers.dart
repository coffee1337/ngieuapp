import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dio_client.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
Dio scheduleApi(ScheduleApiRef ref) => DioClient.createScheduleApi();

@Riverpod(keepAlive: true)
Dio newsApi(NewsApiRef ref) => DioClient.createNewsClient();