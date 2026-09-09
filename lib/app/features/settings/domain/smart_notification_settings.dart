class SmartNotificationSettings {
  const SmartNotificationSettings({
    this.scheduleChangesEnabled = true,
    this.quietHoursEnabled = true,
    this.quietHoursStart = 22,
    this.quietHoursEnd = 7,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });

  final bool scheduleChangesEnabled;
  final bool quietHoursEnabled;
  final int quietHoursStart;
  final int quietHoursEnd;
  final bool soundEnabled;
  final bool vibrationEnabled;

  bool isQuietTime(DateTime date) {
    if (!quietHoursEnabled) return false;
    if (quietHoursStart == quietHoursEnd) return false;
    if (quietHoursStart < quietHoursEnd) {
      return date.hour >= quietHoursStart && date.hour < quietHoursEnd;
    }
    return date.hour >= quietHoursStart || date.hour < quietHoursEnd;
  }

  SmartNotificationSettings copyWith({
    bool? scheduleChangesEnabled,
    bool? quietHoursEnabled,
    int? quietHoursStart,
    int? quietHoursEnd,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) => SmartNotificationSettings(
    scheduleChangesEnabled:
        scheduleChangesEnabled ?? this.scheduleChangesEnabled,
    quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
    quietHoursStart: quietHoursStart ?? this.quietHoursStart,
    quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    soundEnabled: soundEnabled ?? this.soundEnabled,
    vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
  );

  Map<String, Object> toJson() => {
    'scheduleChangesEnabled': scheduleChangesEnabled,
    'quietHoursEnabled': quietHoursEnabled,
    'quietHoursStart': quietHoursStart,
    'quietHoursEnd': quietHoursEnd,
    'soundEnabled': soundEnabled,
    'vibrationEnabled': vibrationEnabled,
  };

  factory SmartNotificationSettings.fromJson(Map<String, dynamic> json) =>
      SmartNotificationSettings(
        scheduleChangesEnabled: json['scheduleChangesEnabled'] as bool? ?? true,
        quietHoursEnabled: json['quietHoursEnabled'] as bool? ?? true,
        quietHoursStart: (json['quietHoursStart'] as num?)?.toInt() ?? 22,
        quietHoursEnd: (json['quietHoursEnd'] as num?)?.toInt() ?? 7,
        soundEnabled: json['soundEnabled'] as bool? ?? true,
        vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      );
}
