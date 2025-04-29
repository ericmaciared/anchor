import 'package:flutter/material.dart';

class Task {
  final int id;
  final String title;
  final String category;
  final TimeOfDay startTime;
  final Duration duration;
  final IconData? icon;
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.startTime,
    required this.duration,
    this.icon,
    this.completed = false,
  });
}
