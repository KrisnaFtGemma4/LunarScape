import 'package:material_ui/material_ui.dart';

import '../../shared/widgets/cosmic_card.dart';
import 'task.dart';

/// Page for task management.
///
/// Tasks are kept in memory for the current session; persistence arrives in a
/// later increment.
class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Task> _tasks = [];
  int _nextId = 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _controller.text.trim();
    if (title.isEmpty) {
      return;
    }

    setState(() {
      _tasks.add(Task(id: _nextId, title: title));
      _nextId += 1;
      _controller.clear();
    });
  }

  void _toggleTask(int id) {
    setState(() {
      for (var index = 0; index < _tasks.length; index++) {
        final task = _tasks[index];
        if (task.id == id) {
          _tasks[index] = task.copyWith(isDone: !task.isDone);
          return;
        }
      }
    });
  }

  void _deleteTask(int id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Tasks', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Plan and track the work that matters.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              CosmicCard(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _addTask(),
                        decoration: const InputDecoration(
                          hintText: 'What needs doing?',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: _addTask,
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (_tasks.isEmpty)
                CosmicCard(
                  child: Column(
                    children: [
                      Icon(
                        Icons.task_alt,
                        size: 44,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text('No tasks yet', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        'Add your first task above to get started.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              else
                for (final task in _tasks)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _TaskTile(
                      task: task,
                      onToggle: () => _toggleTask(task.id),
                      onDelete: () => _deleteTask(task.id),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CosmicCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: Checkbox(value: task.isDone, onChanged: (_) => onToggle()),
        title: Text(
          task.title,
          style: task.isDone
              ? theme.textTheme.bodyLarge?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: theme.colorScheme.onSurfaceVariant,
                )
              : theme.textTheme.bodyLarge,
        ),
        trailing: IconButton(
          tooltip: 'Delete task',
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
