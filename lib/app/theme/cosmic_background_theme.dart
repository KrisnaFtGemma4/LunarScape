import 'package:material_ui/material_ui.dart';

/// Theme-level configuration for the application background.
///
/// Keeping this in the theme lets widgets resolve the correct artwork and
/// overlay for the active [Brightness] without hard-coding feature pages.
@immutable
class CosmicBackgroundTheme extends ThemeExtension<CosmicBackgroundTheme> {
  const CosmicBackgroundTheme({
    required this.lightAsset,
    required this.darkAsset,
    required this.lightOverlayColor,
    required this.darkOverlayColor,
  });

  /// Asset used when the active theme is light.
  final String lightAsset;

  /// Asset used when the active theme is dark.
  final String darkAsset;

  /// Readability scrim applied over [lightAsset].
  final Color lightOverlayColor;

  /// Readability scrim applied over [darkAsset].
  final Color darkOverlayColor;

  String assetFor(Brightness brightness) {
    return brightness == Brightness.light ? lightAsset : darkAsset;
  }

  Color overlayFor(Brightness brightness) {
    return brightness == Brightness.light
        ? lightOverlayColor
        : darkOverlayColor;
  }

  @override
  CosmicBackgroundTheme copyWith({
    String? lightAsset,
    String? darkAsset,
    Color? lightOverlayColor,
    Color? darkOverlayColor,
  }) {
    return CosmicBackgroundTheme(
      lightAsset: lightAsset ?? this.lightAsset,
      darkAsset: darkAsset ?? this.darkAsset,
      lightOverlayColor: lightOverlayColor ?? this.lightOverlayColor,
      darkOverlayColor: darkOverlayColor ?? this.darkOverlayColor,
    );
  }

  @override
  CosmicBackgroundTheme lerp(
    ThemeExtension<CosmicBackgroundTheme>? other,
    double t,
  ) {
    if (other is! CosmicBackgroundTheme) {
      return this;
    }

    return CosmicBackgroundTheme(
      // Asset names cannot be interpolated; switch at the midpoint.
      lightAsset: t < 0.5 ? lightAsset : other.lightAsset,
      darkAsset: t < 0.5 ? darkAsset : other.darkAsset,
      lightOverlayColor: Color.lerp(
        lightOverlayColor,
        other.lightOverlayColor,
        t,
      )!,
      darkOverlayColor: Color.lerp(
        darkOverlayColor,
        other.darkOverlayColor,
        t,
      )!,
    );
  }
}
