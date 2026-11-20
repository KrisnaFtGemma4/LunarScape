import 'package:material_ui/material_ui.dart';

import '../../shared/widgets/feature_placeholder.dart';

/// Page for notes and quick capture.
class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      title: 'Notes',
      description: 'Capture ideas before they drift away.',
      icon: Icons.sticky_note_2_outlined,
    );
  }
}
