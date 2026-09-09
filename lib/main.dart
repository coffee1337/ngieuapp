import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:ngieuapp/app/app.dart';
import 'package:ngieuapp/app/features/notifications/notifications_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force Skia rendering on Android for crisper text (Impeller can be blurry on some devices)
  // This is overridden by AndroidManifest EnableImpeller flag

  await initializeDateFormatting('ru_RU');
  await Hive.initFlutter();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const ProviderScope(child: NgieuApp()));

  // Notifications are an optional platform integration. Some Android OEMs
  // can reject exact-alarm or notification initialization on first launch.
  // Starting it after runApp keeps the application usable even when that
  // integration is unavailable and lets the user fix permissions later.
  unawaited(_initializeOptionalServices());
}

Future<void> _initializeOptionalServices() async {
  try {
    await NotificationsService.instance.init();
  } catch (error, stackTrace) {
    debugPrint('Notifications initialization failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}
