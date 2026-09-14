import 'package:flutter/foundation.dart';

/// Platform integrations must not run on browsers emulating a mobile OS.
abstract final class AppPlatform {
  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  static bool get isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  static bool get supportsMobileIntegrations => isAndroid || isIOS;
}
