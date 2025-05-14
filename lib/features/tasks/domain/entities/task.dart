import 'dart:ui';

class Task {
  final String id;
  final String title;
  final bool isDone;
  final DateTime day;
  final DateTime? startTime;
  final Duration? duration;
  final Color color;

  Task({
    required this.id,
    required this.title,
    required this.isDone,
    required this.day,
    this.startTime,
    this.duration,
    required this.color,
  });

  Task copyWith({
    String? id,
    String? title,
    bool? isDone,
    DateTime? day,
    DateTime? startTime,
    Duration? duration,
    Color? color,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      day: day ?? this.day,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      color: color ?? this.color,
    );
  }
}
