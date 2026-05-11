import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

enum AppThemeMode { system, light, dark }

enum AppFontScale {
  small(0.9),
  normal(1),
  large(1.15),
  huge(1.3);

  const AppFontScale(this.value);
  final double value;
}

@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(AppThemeMode.system) AppThemeMode themeMode,
    @Default(AppFontScale.normal) AppFontScale fontScale,
    @Default(true) bool showChanges,
    @Default(false) bool notificationsEnabled,
    @Default(15) int notificationMinutesBefore,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
