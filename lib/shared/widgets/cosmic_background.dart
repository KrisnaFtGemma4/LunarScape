import 'package:material_ui/material_ui.dart';

import '../../app/theme/cosmic_background_theme.dart';

/// Theme-aware cosmic background used behind the entire application.
///
/// The artwork is configured through [CosmicBackgroundTheme] so feature pages
/// never need to know which image or overlay is active. Both layers ignore
/// pointer events, keeping navigation and content fully interactive.
class CosmicBackground extends StatelessWidget {
  const CosmicBackground({this.child, super.key});

  /// Content displayed above the background.
  final Widget? child;

  static const Duration _transitionDuration = Duration(milliseconds: 450);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundTheme = theme.extension<CosmicBackgroundTheme>();

    assert(
      backgroundTheme != null,
      'CosmicBackgroundTheme must be registered in ThemeData.extensions.',
    );

    if (backgroundTheme == null) {
      return child ?? const SizedBox.shrink();
    }

    final asset = backgroundTheme.assetFor(theme.brightness);
    final overlayColor = backgroundTheme.overlayFor(theme.brightness);

    return Stack(
      fit: StackFit.expand,
      children: [
        IgnorePointer(
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedSwitcher(
                duration: _transitionDuration,
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                layoutBuilder: (currentChild, previousChildren) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [...previousChildren, ?currentChild],
                  );
                },
                child: Image.asset(
                  asset,
                  key: ValueKey(asset),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  gaplessPlayback: true,
                  excludeFromSemantics: true,
                ),
              ),
              AnimatedContainer(
                duration: _transitionDuration,
                curve: Curves.easeInOut,
                color: overlayColor,
              ),
            ],
          ),
        ),
        ?child,
      ],
    );
  }
}
