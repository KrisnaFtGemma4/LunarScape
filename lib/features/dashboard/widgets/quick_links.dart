import 'package:material_ui/material_ui.dart';

import '../../../app/routing/app_destination.dart';
import '../../../shared/widgets/cosmic_card.dart';

/// Quick navigation tiles for the dashboard.
class QuickLinks extends StatelessWidget {
  const QuickLinks({required this.onOpenDestination, super.key});

  /// Called when the user activates a destination tile.
  final ValueChanged<AppDestination> onOpenDestination;

  static const double _tileWidth = 260;
  static const double _narrowBreakpoint = 560;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick links', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final tileWidth = constraints.maxWidth < _narrowBreakpoint
                ? constraints.maxWidth
                : _tileWidth;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                for (final destination in AppDestination.values.skip(1))
                  SizedBox(
                    width: tileWidth,
                    child: _QuickLinkTile(
                      destination: destination,
                      onTap: () => onOpenDestination(destination),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Short descriptions shown on the dashboard tiles.
String _descriptionFor(AppDestination destination) {
  return switch (destination) {
    AppDestination.dashboard => 'A calm overview of your day.',
    AppDestination.tasks => 'Plan and track the work that matters.',
    AppDestination.notes => 'Capture ideas before they drift away.',
    AppDestination.settings => 'Shape LunarScape around the way you work.',
  };
}

class _QuickLinkTile extends StatelessWidget {
  const _QuickLinkTile({required this.destination, required this.onTap});

  final AppDestination destination;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CosmicCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              destination.selectedIcon,
              size: 24,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(destination.label, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  _descriptionFor(destination),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
