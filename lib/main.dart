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
  await NotificationsService.instance.init();

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
}
