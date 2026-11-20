/// Preferred clock format for the dashboard.
enum ClockFormat {
  system(label: 'System'),
  twelveHour(label: '12-hour'),
  twentyFourHour(label: '24-hour');

  const ClockFormat({required this.label});

  /// Human-readable name shown in settings.
  final String label;

  /// Resolves the effective 24-hour preference.
  ///
  /// [systemUses24Hour] comes from `MediaQuery.alwaysUse24HourFormatOf`.
  bool resolveUse24Hour(bool systemUses24Hour) {
    return switch (this) {
      ClockFormat.system => systemUses24Hour,
      ClockFormat.twelveHour => false,
      ClockFormat.twentyFourHour => true,
    };
  }
}
