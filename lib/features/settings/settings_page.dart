import 'package:material_ui/material_ui.dart';

import '../../core/settings/clock_format.dart';
import '../../shared/widgets/cosmic_card.dart';

/// Page for application preferences.
class SettingsPage extends StatelessWidget {
  const SettingsPage({
    required this.themeMode,
    required this.clockFormat,
    required this.onThemeModeChanged,
    required this.onClockFormatChanged,
    super.key,
  });

  /// Currently selected application theme.
  final ThemeMode themeMode;

  /// Currently selected dashboard clock format.
  final ClockFormat clockFormat;

  /// Called when the user picks a different theme mode.
  final ValueChanged<ThemeMode> onThemeModeChanged;

  /// Called when the user picks a different clock format.
  final ValueChanged<ClockFormat> onClockFormatChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Settings', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Shape LunarScape around the way you work.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              _SettingsSection(
                title: 'Appearance',
                description:
                    'Choose how LunarScape looks. System follows your '
                    'Windows theme.',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final mode in ThemeMode.values)
                      ChoiceChip(
                        label: Text(_themeModeLabel(mode)),
                        selected: mode == themeMode,
                        onSelected: (_) => onThemeModeChanged(mode),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _SettingsSection(
                title: 'Clock',
                description:
                    'Choose the dashboard clock format. System follows your '
                    'Windows setting.',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final format in ClockFormat.values)
                      ChoiceChip(
                        label: Text(format.label),
                        selected: format == clockFormat,
                        onSelected: (_) => onClockFormatChanged(format),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _themeModeLabel(ThemeMode mode) {
  return switch (mode) {
    ThemeMode.system => 'System',
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
  };
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CosmicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
