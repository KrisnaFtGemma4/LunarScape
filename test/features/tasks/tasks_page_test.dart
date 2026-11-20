import 'package:flutter_test/flutter_test.dart';
import 'package:lunarscape/app/theme/app_theme.dart';
import 'package:lunarscape/features/tasks/tasks_page.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows an empty state before any task exists', (tester) async {
    await tester.pumpWidget(_host());

    expect(find.text('No tasks yet'), findsOneWidget);
    expect(find.byType(Checkbox), findsNothing);
  });

  testWidgets('adds a task and clears the input', (tester) async {
    await tester.pumpWidget(_host());

    await tester.enterText(find.byType(TextField), 'Write dashboard tests');
    await tester.tap(find.text('Add'));
    await tester.pump();

    expect(find.text('Write dashboard tests'), findsOneWidget);
    expect(find.text('No tasks yet'), findsNothing);

    final field = tester.widget<EditableText>(find.byType(EditableText));
    expect(field.controller.text, isEmpty);
  });

  testWidgets('ignores whitespace-only input', (tester) async {
    await tester.pumpWidget(_host());

    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.text('Add'));
    await tester.pump();

    expect(find.text('No tasks yet'), findsOneWidget);
    expect(find.byType(Checkbox), findsNothing);
  });

  testWidgets('toggles a task as done', (tester) async {
    await tester.pumpWidget(_host());

    await tester.enterText(find.byType(TextField), 'Finish increment six');
    await tester.tap(find.text('Add'));
    await tester.pump();

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
    expect(checkbox.value, isTrue);

    final title = tester.widget<Text>(find.text('Finish increment six'));
    expect(title.style?.decoration, TextDecoration.lineThrough);
  });

  testWidgets('deletes a task', (tester) async {
    await tester.pumpWidget(_host());

    await tester.enterText(find.byType(TextField), 'Temporary task');
    await tester.tap(find.text('Add'));
    await tester.pump();

    await tester.tap(find.byTooltip('Delete task'));
    await tester.pump();

    expect(find.text('Temporary task'), findsNothing);
    expect(find.text('No tasks yet'), findsOneWidget);
  });
}

Widget _host() {
  return MaterialApp(
    theme: AppTheme.dark,
    home: const Scaffold(body: TasksPage()),
  );
}
