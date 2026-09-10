import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ngieuapp/app/features/notifications/notification_sync_provider.dart';
import 'package:ngieuapp/app/features/settings/data/settings_providers.dart';
import 'package:ngieuapp/app/features/settings/data/visual_style_providers.dart';
import 'package:ngieuapp/app/features/settings/domain/app_settings.dart';
import 'package:ngieuapp/app/features/widget/home_widget_sync_provider.dart';
import 'package:ngieuapp/app/router.dart';
import 'package:ngieuapp/app/shared/widgets/app_launch_splash.dart';
import 'package:ngieuapp/app/theme/app_theme.dart';
import 'package:ngieuapp/app/theme/app_visual_style.dart';

class NgieuApp extends ConsumerWidget {
  const NgieuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(appSettingsProvider);
    final visualStyle = ref.watch(visualStyleProvider);
    ref.watch(notificationSyncProvider);
    ref.watch(homeWidgetSyncProvider);

    final themeMode = visualStyle == AppVisualStyle.amoled
        ? ThemeMode.dark
        : switch (settings.themeMode) {
            AppThemeMode.system => ThemeMode.system,
            AppThemeMode.light => ThemeMode.light,
            AppThemeMode.dark => ThemeMode.dark,
          };

    return MaterialApp.router(
      title: 'НГИЭУ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(style: visualStyle),
      darkTheme: AppTheme.dark(style: visualStyle),
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) {
        // Применяем пользовательский масштаб шрифта
        final mq = MediaQuery.of(context);
        return AppLaunchSplash(
          child: MediaQuery(
            data: mq.copyWith(
              textScaler: TextScaler.linear(settings.fontScale.value),
            ),
            child: child!,
          ),
        );
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ru'), Locale('en')],
      locale: const Locale('ru'),
    );
  }
}
