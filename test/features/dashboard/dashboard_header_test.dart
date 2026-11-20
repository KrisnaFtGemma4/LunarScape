import 'package:flutter_test/flutter_test.dart';
import 'package:lunarscape/app/theme/app_theme.dart';
import 'package:lunarscape/core/settings/clock_format.dart';
import 'package:lunarscape/features/dashboard/data/dashboard_quotes.dart';
import 'package:lunarscape/features/dashboard/widgets/dashboard_header.dart';
import 'package:material_ui/material_ui.dart';

const DashboardQuote _testQuote = DashboardQuote(
  text: 'Small steps compound.',
  author: 'Krisna',
);

void main() {
  group('greetingForHour', () {
    test('uses the night greeting before 5 in the morning', () {
      expect(greetingForHour(0), 'Good night');
      expect(greetingForHour(4), 'Good night');
    });

    test('uses the morning greeting from 5 up to 12', () {
      expect(greetingForHour(5), 'Good morning');
      expect(greetingForHour(11), 'Good morning');
    });

    test('uses the afternoon greeting from 12 up to 17', () {
      expect(greetingForHour(12), 'Good afternoon');
      expect(greetingForHour(16), 'Good afternoon');
    });

    test('uses the evening greeting from 17 up to 22', () {
      expect(greetingForHour(17), 'Good evening');
      expect(greetingForHour(21), 'Good evening');
    });

    test('uses the night greeting from 22 onward', () {
      expect(greetingForHour(22), 'Good night');
      expect(greetingForHour(23), 'Good night');
    });
  });

  group('formatClock', () {
    test('formats 24-hour time with zero padding', () {
      expect(formatClock(DateTime(2026, 1, 1), use24Hour: true), (
        time: '00:00:00',
        period: '',
      ));
      expect(formatClock(DateTime(2026, 1, 1, 19, 42, 7), use24Hour: true), (
        time: '19:42:07',
        period: '',
      ));
    });

    test('formats 12-hour time with an AM or PM marker', () {
      expect(formatClock(DateTime(2026, 1, 1, 0, 5, 9), use24Hour: false), (
        time: '12:05:09',
        period: 'AM',
      ));
      expect(formatClock(DateTime(2026, 1, 1, 7, 5, 9), use24Hour: false), (
        time: '7:05:09',
        period: 'AM',
      ));
      expect(formatClock(DateTime(2026, 1, 1, 12), use24Hour: false), (
        time: '12:00:00',
        period: 'PM',
      ));
      expect(formatClock(DateTime(2026, 1, 1, 23, 59, 59), use24Hour: false), (
        time: '11:59:59',
        period: 'PM',
      ));
    });
  });

  testWidgets('header shows a greeting, live clock, and quote', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const Scaffold(
          body: DashboardHeader(
            quote: _testQuote,
            clockFormat: ClockFormat.system,
          ),
        ),
      ),
    );

    expect(
      find.textContaining(RegExp(r'^Good (morning|afternoon|evening|night)$')),
      findsOneWidget,
    );
    expect(find.textContaining('Small steps compound.'), findsOneWidget);
    expect(find.text('— Krisna'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(DashboardHeader), findsOneWidget);
  });

  testWidgets('header follows the 24-hour platform preference', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(alwaysUse24HourFormat: true),
              child: const Scaffold(
                body: DashboardHeader(
                  quote: _testQuote,
                  clockFormat: ClockFormat.system,
                ),
              ),
            );
          },
        ),
      ),
    );

    expect(find.textContaining(RegExp(r'^\d{2}:\d{2}:\d{2}$')), findsOneWidget);
  });

  testWidgets('explicit clock format overrides the platform preference', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const Scaffold(
          body: DashboardHeader(
            quote: _testQuote,
            clockFormat: ClockFormat.twelveHour,
          ),
        ),
      ),
    );

    expect(
      find.textContaining(RegExp(r'^\d{1,2}:\d{2}:\d{2}$')),
      findsOneWidget,
    );
    expect(find.textContaining(RegExp(r'^\d{2}:\d{2}:\d{2}$')), findsNothing);
    expect(find.textContaining(RegExp(r'^(AM|PM)$')), findsOneWidget);
  });
}
