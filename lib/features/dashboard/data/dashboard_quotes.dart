/// A short piece of inspiration shown on the dashboard.
class DashboardQuote {
  const DashboardQuote({required this.text, required this.author});

  /// The quote itself, without surrounding quotation marks.
  final String text;

  /// The person the quote is attributed to.
  final String author;
}

/// Curated quotes used by the dashboard.
///
/// Keep this list short and intentional; it is read by people, not scraped.
const List<DashboardQuote> dashboardQuotes = [
  DashboardQuote(
    text: 'Simplicity is the ultimate sophistication.',
    author: 'Leonardo da Vinci',
  ),
  DashboardQuote(
    text:
        'It is not that we have a short time to live, but that we waste a lot '
        'of it.',
    author: 'Seneca',
  ),
  DashboardQuote(
    text:
        'You do not rise to the level of your goals. You fall to the level of '
        'your systems.',
    author: 'James Clear',
  ),
  DashboardQuote(text: 'Focusing is about saying no.', author: 'Steve Jobs'),
  DashboardQuote(
    text:
        'Amateurs sit and wait for inspiration, the rest of us just get up '
        'and go to work.',
    author: 'Stephen King',
  ),
  DashboardQuote(
    text: 'The journey of a thousand miles begins with a single step.',
    author: 'Lao Tzu',
  ),
  DashboardQuote(
    text:
        'We are what we repeatedly do. Excellence, then, is not an act, but '
        'a habit.',
    author: 'Will Durant',
  ),
  DashboardQuote(
    text: 'How we spend our days is, of course, how we spend our lives.',
    author: 'Annie Dillard',
  ),
  DashboardQuote(
    text: 'It always seems impossible until it is done.',
    author: 'Nelson Mandela',
  ),
  DashboardQuote(
    text: 'Do what you can, with what you have, where you are.',
    author: 'Theodore Roosevelt',
  ),
  DashboardQuote(
    text:
        'You have power over your mind — not outside events. Realize this, '
        'and you will find strength.',
    author: 'Marcus Aurelius',
  ),
  DashboardQuote(
    text:
        'Nothing is so fatiguing as the eternal hanging on of an uncompleted '
        'task.',
    author: 'William James',
  ),
  DashboardQuote(text: 'The only way out is through.', author: 'Robert Frost'),
  DashboardQuote(
    text:
        'Almost everything will work again if you unplug it for a few '
        'minutes, including you.',
    author: 'Anne Lamott',
  ),
  DashboardQuote(
    text: 'There is nothing either good or bad, but thinking makes it so.',
    author: 'William Shakespeare',
  ),
  DashboardQuote(
    text: 'What we fear doing most is usually what we most need to do.',
    author: 'Tim Ferriss',
  ),
  DashboardQuote(
    text:
        'To be yourself in a world that is constantly trying to make you '
        'something else is the greatest accomplishment.',
    author: 'Ralph Waldo Emerson',
  ),
  DashboardQuote(
    text: 'The unexamined life is not worth living.',
    author: 'Socrates',
  ),
  DashboardQuote(
    text: "Shoot for the moon. Even if you miss, you'll land among the stars.",
    author: 'Norman Vincent Peale',
  ),
  DashboardQuote(
    text: 'The moon is a friend for the lonesome to talk to.',
    author: 'Carl Sandburg',
  ),
];

/// Returns the quote for [date], stable for that local calendar day.
///
/// The day index is computed in UTC so daylight-saving transitions cannot
/// skip or repeat a quote. The quote only changes when the date changes.
DashboardQuote quoteForDate(DateTime date) {
  final dayIndex = DateTime.utc(
    date.year,
    date.month,
    date.day,
  ).difference(DateTime.utc(date.year)).inDays;

  return dashboardQuotes[dayIndex % dashboardQuotes.length];
}
