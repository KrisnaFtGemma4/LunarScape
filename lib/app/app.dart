import 'package:material_ui/material_ui.dart';

import '../core/constants/app_constants.dart';
import '../core/settings/clock_format.dart';
import '../shared/widgets/cosmic_background.dart';
import 'shell/app_shell.dart';
import 'theme/app_theme.dart';

/// Root widget for LunarScape.
class LunarScapeApp extends StatefulWidget {
  const LunarScapeApp({super.key});

  @override
  State<LunarScapeApp> createState() => _LunarScapeAppState();
}

class _LunarScapeAppState extends State<LunarScapeApp> {
  ThemeMode _themeMode = ThemeMode.system;
  ClockFormat _clockFormat = ClockFormat.system;

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  void _setClockFormat(ClockFormat format) {
    setState(() {
      _clockFormat = format;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      builder: (context, child) {
        return CosmicBackground(child: child);
      },
      home: AppShell(
        themeMode: _themeMode,
        clockFormat: _clockFormat,
        onThemeModeChanged: _setThemeMode,
        onClockFormatChanged: _setClockFormat,
      ),
    );
  }
}
