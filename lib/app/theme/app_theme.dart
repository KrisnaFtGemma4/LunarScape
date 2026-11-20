import 'package:material_ui/material_ui.dart';

import 'cosmic_background_theme.dart';

/// Application themes built from a single Material 3 seed color.
///
/// Material 3 is the default in the current Flutter SDK, so no explicit
/// `useMaterial3` flag is required.
abstract final class AppTheme {
  static const Color _seedColor = Color(0xFF6C63FF);

  static const String _lightBackgroundAsset =
      'assets/images/background/bg-light.jpg';
  static const String _darkBackgroundAsset =
      'assets/images/background/bg-dark.jpg';

  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
    );

    return ThemeData(
      colorScheme: colorScheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      extensions: [
        CosmicBackgroundTheme(
          lightAsset: _lightBackgroundAsset,
          darkAsset: _darkBackgroundAsset,
          lightOverlayColor: colorScheme.surface.withValues(alpha: 0.62),
          darkOverlayColor: colorScheme.surface.withValues(alpha: 0.72),
        ),
      ],
    );
  }
}
