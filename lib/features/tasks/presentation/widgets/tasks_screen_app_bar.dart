import 'package:anchor/core/theme/spacing_sizes.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_button_widget.dart';
import 'package:flutter/material.dart';

class TasksScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAddTask;
  final VoidCallback onTodayPressed;

  const TasksScreenAppBar({super.key, required this.onAddTask, required this.onTodayPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('tasks', style: context.textStyles.titleMedium?.copyWith(fontSize: TextSizes.xl)),
            Row(
              children: [
                AdaptiveButtonWidget(
                  height: 36,
                  width: 36,
                  onPressed: onTodayPressed,
                  child: const Icon(Icons.today),
                ),
                const SizedBox(width: SpacingSizes.m),
                AdaptiveButtonWidget(
                  height: 36,
                  width: 36,
                  onPressed: onAddTask,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
