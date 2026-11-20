import 'package:flutter_test/flutter_test.dart';
import 'package:lunarscape/app/routing/app_destination.dart';
import 'package:lunarscape/app/theme/app_theme.dart';
import 'package:lunarscape/features/dashboard/widgets/quick_links.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows a tile for every non-dashboard destination', (
    tester,
  ) async {
    await tester.pumpWidget(_host(onOpenDestination: (_) {}));

    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Notes'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('reports the tapped destination', (tester) async {
    AppDestination? selected;
    await tester.pumpWidget(
      _host(onOpenDestination: (destination) => selected = destination),
    );

    await tester.tap(find.text('Notes'));
    await tester.pump();

    expect(selected, AppDestination.notes);
  });
}

Widget _host({required ValueChanged<AppDestination> onOpenDestination}) {
  return MaterialApp(
    theme: AppTheme.dark,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: QuickLinks(onOpenDestination: onOpenDestination),
      ),
    ),
  );
}
