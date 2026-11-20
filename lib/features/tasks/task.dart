/// A single task shown on the Tasks page.
class Task {
  const Task({required this.id, required this.title, this.isDone = false});

  /// Stable identifier used for updates and deletions.
  final int id;

  /// Short description of the work.
  final String title;

  /// Whether the task has been completed.
  final bool isDone;

  /// Returns a copy with the completion state replaced.
  Task copyWith({bool? isDone}) {
    return Task(id: id, title: title, isDone: isDone ?? this.isDone);
  }
}
