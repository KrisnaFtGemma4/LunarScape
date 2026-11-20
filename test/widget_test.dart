import 'package:flutter_test/flutter_test.dart';
import 'package:lunarscape/app/app.dart';
import 'package:lunarscape/app/routing/app_destination.dart';
import 'package:lunarscape/app/theme/app_theme.dart';
import 'package:lunarscape/features/dashboard/widgets/quick_links.dart';
import 'package:lunarscape/shared/widgets/cosmic_background.dart';
import 'package:material_ui/material_ui.dart';

const String _lightBackground = 'assets/images/background/bg-light.jpg';
const String _darkBackground = 'assets/images/background/bg-dark.jpg';

void main() {
  testWidgets('application shell renders every destination', (tester) async {
    await tester.pumpWidget(const LunarScapeApp());

    expect(find.text('LunarScape'), findsOneWidget);
    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Tasks'), findsWidgets);
    expect(find.text('Notes'), findsWidgets);
    expect(find.text('Settings'), findsWidgets);
    expect(
      find.textContaining(RegExp(r'^Good (morning|afternoon|evening|night)$')),
      findsOneWidget,
    );
    expect(find.textContaining('— '), findsOneWidget);
  });

  testWidgets('quick link switches the shell destination', (tester) async {
    await tester.pumpWidget(const LunarScapeApp());

    await tester.tap(
      find.descendant(
        of: find.byType(QuickLinks),
        matching: find.text('Tasks'),
      ),
    );
    await tester.pump();

    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.selectedIndex, AppDestination.tasks.index);
    expect(find.text('Plan and track the work that matters.'), findsOneWidget);
  });

  testWidgets('settings update the app theme and clock format', (tester) async {
    await tester.pumpWidget(const LunarScapeApp());

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationRail),
        matching: find.text('Settings'),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Dark'));
    await tester.pump();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);

    await tester.tap(find.text('24-hour'));
    await tester.pump();

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationRail),
        matching: find.text('Dashboard'),
      ),
    );
    await tester.pump();

    expect(find.textContaining(RegExp(r'^\d{2}:\d{2}:\d{2}$')), findsOneWidget);
  });

  testWidgets('dashboard lays out without overflow at the minimum size', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LunarScapeApp());

    expect(find.byType(QuickLinks), findsOneWidget);
    expect(find.textContaining('— '), findsOneWidget);
    expect(find.text('Window too small'), findsNothing);
  });

  testWidgets('shows a guard instead of the shell when the window is tiny', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(500, 400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LunarScapeApp());

    expect(find.text('Window too small'), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byType(QuickLinks), findsNothing);
  });

  testWidgets('light theme uses the light cosmic background', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: CosmicBackground()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey(_lightBackground)), findsOneWidget);
    expect(find.byKey(const ValueKey(_darkBackground)), findsNothing);
  });

  testWidgets('dark theme uses the dark cosmic background', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const Scaffold(body: CosmicBackground()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey(_darkBackground)), findsOneWidget);
    expect(find.byKey(const ValueKey(_lightBackground)), findsNothing);
  });
}
