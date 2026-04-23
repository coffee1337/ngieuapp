// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  themeMode:
      $enumDecodeNullable(_$AppThemeModeEnumMap, json['themeMode']) ??
      AppThemeMode.system,
  fontScale:
      $enumDecodeNullable(_$AppFontScaleEnumMap, json['fontScale']) ??
      AppFontScale.normal,
  showChanges: json['showChanges'] as bool? ?? true,
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'themeMode': _$AppThemeModeEnumMap[instance.themeMode]!,
      'fontScale': _$AppFontScaleEnumMap[instance.fontScale]!,
      'showChanges': instance.showChanges,
    };

const _$AppThemeModeEnumMap = {
  AppThemeMode.system: 'system',
  AppThemeMode.light: 'light',
  AppThemeMode.dark: 'dark',
};

const _$AppFontScaleEnumMap = {
  AppFontScale.small: 'small',
  AppFontScale.normal: 'normal',
  AppFontScale.large: 'large',
  AppFontScale.huge: 'huge',
};
