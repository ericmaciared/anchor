import 'package:flutter/material.dart';

class TasksScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAddTask;

  const TasksScreenAppBar({super.key, required this.onAddTask});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0.0,
      title: Text('tasks'),
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
