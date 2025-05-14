import 'package:flutter/material.dart';

class EmptyTaskState extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyTaskState({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No tasks for this day.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onAdd,
            child: const Text('Try adding one!'),
          ),
        ],
      ),
    );
  }
}
