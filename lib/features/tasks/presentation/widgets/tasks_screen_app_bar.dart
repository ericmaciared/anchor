import 'package:flutter/material.dart';

class TasksScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAddTask;

  const TasksScreenAppBar({super.key, required this.onAddTask});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'good morning.';
    } else if (hour < 18) {
      return 'good afternoon.';
    } else {
      return 'good evening.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(_getGreeting()),
      actions: [
        IconButton(
          onPressed: onAddTask,
          tooltip: 'Add Task',
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
