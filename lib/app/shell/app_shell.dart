import 'package:material_ui/material_ui.dart';

import '../../core/constants/app_constants.dart';
import '../../core/settings/clock_format.dart';
import '../../features/dashboard/dashboard_page.dart';
import '../../features/notes/notes_page.dart';
import '../../features/settings/settings_page.dart';
import '../../features/tasks/tasks_page.dart';
import '../routing/app_destination.dart';

/// Desktop application shell with persistent navigation.
class AppShell extends StatefulWidget {
  const AppShell({
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
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppDestination _destination = AppDestination.dashboard;

  /// Below these logical sizes the shell would not fit its fixed elements.
  ///
  /// The Windows runner enforces a larger native minimum; this guard keeps
  /// other targets (or unusual DPI setups) from overflowing.
  static const double _minShellWidth = 600;
  static const double _minShellHeight = 420;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < _minShellWidth ||
                constraints.maxHeight < _minShellHeight) {
              return const _WindowTooSmall();
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NavigationRail(
                  extended: true,
                  minExtendedWidth: 220,
                  backgroundColor: colorScheme.surface.withValues(alpha: 0.55),
                  selectedIndex: _destination.index,
                  onDestinationSelected: (index) {
                    setState(() {
                      _destination = AppDestination.values[index];
                    });
                  },
                  leading: const _RailHeader(),
                  destinations: [
                    for (final destination in AppDestination.values)
                      NavigationRailDestination(
                        icon: Icon(destination.icon),
                        selectedIcon: Icon(destination.selectedIcon),
                        label: Text(destination.label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: IndexedStack(
                    index: _destination.index,
                    children: [
                      for (final destination in AppDestination.values)
                        _pageFor(destination),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _pageFor(AppDestination destination) {
    return switch (destination) {
      AppDestination.dashboard => DashboardPage(
        clockFormat: widget.clockFormat,
        onOpenDestination: _openDestination,
      ),
      AppDestination.tasks => const TasksPage(),
      AppDestination.notes => const NotesPage(),
      AppDestination.settings => SettingsPage(
        themeMode: widget.themeMode,
        clockFormat: widget.clockFormat,
        onThemeModeChanged: widget.onThemeModeChanged,
        onClockFormatChanged: widget.onClockFormatChanged,
      ),
    };
  }

  void _openDestination(AppDestination destination) {
    setState(() {
      _destination = destination;
    });
  }
}

class _RailHeader extends StatelessWidget {
  const _RailHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      child: Row(
        children: [
          Icon(
            Icons.nightlight_round,
            color: theme.colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            AppConstants.appName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown when the available window area is too small for the shell.
class _WindowTooSmall extends StatelessWidget {
  const _WindowTooSmall();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.open_in_full,
              size: 40,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('Window too small', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Make the window larger to continue.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
