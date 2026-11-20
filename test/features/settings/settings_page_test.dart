import 'package:flutter_test/flutter_test.dart';
import 'package:lunarscape/app/theme/app_theme.dart';
import 'package:lunarscape/core/settings/clock_format.dart';
import 'package:lunarscape/features/settings/settings_page.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('renders appearance and clock sections', (tester) async {
    await tester.pumpWidget(_host());

    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Clock'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('24-hour'), findsOneWidget);
  });

  testWidgets('reports a selected theme mode', (tester) async {
    ThemeMode? selected;
    await tester.pumpWidget(
      _host(onThemeModeChanged: (mode) => selected = mode),
    );

    await tester.tap(find.text('Dark'));
    await tester.pump();

    expect(selected, ThemeMode.dark);
  });

  testWidgets('reports a selected clock format', (tester) async {
    ClockFormat? selected;
    await tester.pumpWidget(
      _host(onClockFormatChanged: (format) => selected = format),
    );

    await tester.tap(find.text('24-hour'));
    await tester.pump();

    expect(selected, ClockFormat.twentyFourHour);
  });
}

Widget _host({
  ThemeMode themeMode = ThemeMode.system,
  ClockFormat clockFormat = ClockFormat.system,
  ValueChanged<ThemeMode>? onThemeModeChanged,
  ValueChanged<ClockFormat>? onClockFormatChanged,
}) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(
      body: SettingsPage(
        themeMode: themeMode,
        clockFormat: clockFormat,
        onThemeModeChanged: onThemeModeChanged ?? (_) {},
        onClockFormatChanged: onClockFormatChanged ?? (_) {},
      ),
    ),
  );
}
