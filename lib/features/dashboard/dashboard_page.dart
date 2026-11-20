import 'package:material_ui/material_ui.dart';

import '../../app/routing/app_destination.dart';
import '../../core/settings/clock_format.dart';
import 'data/dashboard_quotes.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/quick_links.dart';

/// Landing page for the personal dashboard.
class DashboardPage extends StatelessWidget {
  const DashboardPage({
    required this.clockFormat,
    required this.onOpenDestination,
    super.key,
  });

  /// Clock format preference forwarded to the header.
  final ClockFormat clockFormat;

  /// Called when a quick link requests a different shell destination.
  final ValueChanged<AppDestination> onOpenDestination;

  /// Keeps content readable on wide desktop windows.
  static const double _maxContentWidth = 1100;

  @override
  Widget build(BuildContext context) {
    final quote = quoteForDate(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DashboardHeader(quote: quote, clockFormat: clockFormat),
              const SizedBox(height: 24),
              QuickLinks(onOpenDestination: onOpenDestination),
            ],
          ),
        ),
      ),
    );
  }
}
