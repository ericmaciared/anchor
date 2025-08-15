import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/color_picker.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/icon_picker.dart';
import 'package:flutter/material.dart';

class TaskColorIconSection extends StatelessWidget {
  final TaskModel task;
  final ValueChanged<TaskModel> onTaskChanged;

  const TaskColorIconSection({
    super.key,
    required this.task,
    required this.onTaskChanged,
  });

  void _showIconPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => IconPicker(
        selectedIcon: task.icon,
        onIconSelected: (icon) {
          onTaskChanged(task.copyWith(icon: icon));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ColorPickerWidget(
            selectedColor: task.color,
            onColorSelected: (color) {
              onTaskChanged(task.copyWith(color: color));
            },
          ),
        ),
        const SizedBox(width: 16),
        Column(
          children: [
            Text(
              'Icon',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
                  ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showIconPicker(context),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: task.color.withAlpha(50),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: task.color.withAlpha(120)),
                ),
                child: Icon(task.icon, color: task.color, size: 28),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
