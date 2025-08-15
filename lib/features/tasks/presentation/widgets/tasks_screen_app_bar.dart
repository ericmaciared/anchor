import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/widgets/regular_button_widget.dart';
import 'package:flutter/material.dart';

class TasksScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAddTask;

  const TasksScreenAppBar({super.key, required this.onAddTask});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('tasks', style: TextStyle(fontSize: TextSizes.XL)),
            RegularButtonWidget(
              height: 36,
              width: 36,
              onPressed: onAddTask,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
