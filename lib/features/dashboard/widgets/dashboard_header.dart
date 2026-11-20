import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../../core/settings/clock_format.dart';
import '../../../shared/widgets/cosmic_card.dart';
import '../data/dashboard_quotes.dart';

/// Formatted clock text plus the optional AM/PM marker.
typedef ClockLabel = ({String time, String period});

/// Returns the greeting for [hour], where [hour] uses the 0–23 range.
String greetingForHour(int hour) {
  assert(hour >= 0 && hour <= 23, 'hour must be between 0 and 23');

  if (hour >= 5 && hour < 12) {
    return 'Good morning';
  }
  if (hour >= 12 && hour < 17) {
    return 'Good afternoon';
  }
  if (hour >= 17 && hour < 22) {
    return 'Good evening';
  }
  return 'Good night';
}

/// Formats [time] for display.
///
/// Set [use24Hour] from the platform preference. Times always include seconds
/// and use tabular figures in the UI so the width stays stable while ticking.
ClockLabel formatClock(DateTime time, {required bool use24Hour}) {
  String twoDigits(int value) => value.toString().padLeft(2, '0');

  final seconds = twoDigits(time.second);

  if (use24Hour) {
    final hours = twoDigits(time.hour);
    final minutes = twoDigits(time.minute);
    return (time: '$hours:$minutes:$seconds', period: '');
  }

  final hours = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final minutes = twoDigits(time.minute);
  final period = time.hour < 12 ? 'AM' : 'PM';
  return (time: '$hours:$minutes:$seconds', period: period);
}

/// Welcome panel for the dashboard.
///
/// Shows the greeting, date, live clock, and today's quote. Owns the single
/// timer that keeps the time-related content in sync.
class DashboardHeader extends StatefulWidget {
  const DashboardHeader({
    required this.quote,
    required this.clockFormat,
    super.key,
  });

  /// Quote selected for today, shown at the bottom of the panel.
  final DashboardQuote quote;

  /// Clock format preference, with `system` following the platform.
  final ClockFormat clockFormat;

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  static const Duration _tickInterval = Duration(seconds: 1);
  static const double _wideLayoutBreakpoint = 700;

  late DateTime _now;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(_tickInterval, (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final use24Hour = widget.clockFormat.resolveUse24Hour(
      MediaQuery.alwaysUse24HourFormatOf(context),
    );
    final dateLabel = MaterialLocalizations.of(context).formatFullDate(_now);

    final greeting = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(greetingForHour(_now.hour), style: theme.textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          dateLabel,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );

    final clock = _ClockDisplay(time: _now, use24Hour: use24Hour);

    return CosmicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < _wideLayoutBreakpoint) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [greeting, const SizedBox(height: 20), clock],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: greeting),
                  const SizedBox(width: 24),
                  clock,
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          Divider(
            height: 1,
            thickness: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            '“${widget.quote.text}”',
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 6),
          Text(
            '— ${widget.quote.author}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClockDisplay extends StatelessWidget {
  const _ClockDisplay({required this.time, required this.use24Hour});

  final DateTime time;
  final bool use24Hour;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = formatClock(time, use24Hour: use24Hour);

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            label.time,
            style: theme.textTheme.displaySmall?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          if (label.period.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              label.period,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
