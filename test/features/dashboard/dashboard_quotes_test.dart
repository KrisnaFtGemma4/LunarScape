import 'package:flutter_test/flutter_test.dart';
import 'package:lunarscape/features/dashboard/data/dashboard_quotes.dart';

void main() {
  group('dashboardQuotes', () {
    test('contains 20 quotes with unique text', () {
      expect(dashboardQuotes, hasLength(20));
      expect(
        dashboardQuotes.map((quote) => quote.text).toSet(),
        hasLength(dashboardQuotes.length),
      );
    });

    test('every quote has text and an author', () {
      for (final quote in dashboardQuotes) {
        expect(quote.text.trim(), isNotEmpty);
        expect(quote.author.trim(), isNotEmpty);
      }
    });
  });

  group('quoteForDate', () {
    test('returns the same quote for the whole day', () {
      final morning = DateTime(2026, 11, 19, 6, 30);
      final evening = DateTime(2026, 11, 19, 23, 59);

      expect(quoteForDate(morning), quoteForDate(evening));
    });

    test('moves to another quote the next day', () {
      final today = quoteForDate(DateTime(2026, 11, 19));
      final tomorrow = quoteForDate(DateTime(2026, 11, 20));

      expect(today, isNot(tomorrow));
    });

    test('cycles through every quote over consecutive days', () {
      final seen = <DashboardQuote>{
        for (var day = 1; day <= dashboardQuotes.length; day++)
          quoteForDate(DateTime(2026, 1, day)),
      };

      expect(seen, hasLength(dashboardQuotes.length));
    });

    test('resets the rotation at the start of a new year', () {
      expect(quoteForDate(DateTime(2027, 1, 1)), dashboardQuotes.first);
      expect(
        quoteForDate(DateTime(2026, 12, 31)),
        isNot(dashboardQuotes.first),
      );
    });
  });
}
