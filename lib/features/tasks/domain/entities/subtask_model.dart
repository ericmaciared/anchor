class SubtaskModel {
  final String id;
  final String taskId;
  final String title;
  final bool isDone;

  SubtaskModel({
    required this.id,
    required this.taskId,
    required this.title,
    required this.isDone,
  });

  SubtaskModel copyWith({
    String? id,
    String? taskId,
    String? title,
    bool? isDone,
  }) {
    return SubtaskModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}
