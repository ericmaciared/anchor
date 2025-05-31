class Subtask {
  final String id;
  final String taskId;
  final String title;
  final bool isDone;

  Subtask({
    required this.id,
    required this.taskId,
    required this.title,
    required this.isDone,
  });

  Subtask copyWith({
    String? id,
    String? taskId,
    String? title,
    bool? isDone,
  }) {
    return Subtask(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}
