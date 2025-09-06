import 'package:flutter/material.dart';

class TaskProgressBar extends StatelessWidget {
  final Color color;

  const TaskProgressBar({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
