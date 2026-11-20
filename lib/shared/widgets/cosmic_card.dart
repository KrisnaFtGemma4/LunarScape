import 'package:material_ui/material_ui.dart';

/// Translucent surface shared by feature panels.
///
/// Matches the navigation rail's surface treatment so the cosmic background
/// stays visible behind content in both light and dark themes.
class CosmicCard extends StatelessWidget {
  const CosmicCard({
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.onTap,
    super.key,
  });

  /// Content placed inside the panel.
  final Widget child;

  /// Inner spacing between the panel edge and [child].
  final EdgeInsetsGeometry padding;

  /// Makes the whole panel interactive, including padding and rounded corners.
  final VoidCallback? onTap;

  static const BorderRadius _borderRadius = BorderRadius.all(
    Radius.circular(20),
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surface.withValues(alpha: 0.55),
      shape: RoundedRectangleBorder(
        borderRadius: _borderRadius,
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: _borderRadius,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
