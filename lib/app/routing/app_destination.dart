import 'package:material_ui/material_ui.dart';

/// Top-level destinations available from the application shell.
///
/// The desktop shell uses these destinations for its navigation rail. Add new
/// feature areas here as the application grows.
enum AppDestination {
  dashboard(
    label: 'Dashboard',
    icon: Icons.space_dashboard_outlined,
    selectedIcon: Icons.space_dashboard,
  ),
  tasks(
    label: 'Tasks',
    icon: Icons.check_circle_outline,
    selectedIcon: Icons.check_circle,
  ),
  notes(
    label: 'Notes',
    icon: Icons.sticky_note_2_outlined,
    selectedIcon: Icons.sticky_note_2,
  ),
  settings(
    label: 'Settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  );

  const AppDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
