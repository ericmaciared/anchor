class Task {
  final String id;
  final String title;
  final bool isDone;
  final DateTime? startTime;
  final Duration? duration;

  Task({
    required this.id,
    required this.title,
    required this.isDone,
    this.startTime,
    this.duration,
  });

  Task copyWith({
    String? id,
    String? title,
    bool? isDone,
    DateTime? startTime,
    Duration? duration,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
    );
  }
}
