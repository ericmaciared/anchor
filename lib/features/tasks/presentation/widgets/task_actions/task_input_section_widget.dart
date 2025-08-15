import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/features/shared/widgets/duration_input.dart';
import 'package:anchor/features/shared/widgets/text_input.dart';
import 'package:anchor/features/shared/widgets/time_input.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:flutter/material.dart';

class TaskInputSection extends StatelessWidget {
  final TaskModel task;
  final DateTime taskDay;
  final bool showTimePicker;
  final bool showDurationSelector;
  final ValueChanged<TaskModel> onTaskChanged;

  const TaskInputSection({
    super.key,
    required this.task,
    required this.taskDay,
    required this.showTimePicker,
    required this.showDurationSelector,
    required this.onTaskChanged,
  });

  void _updateTask(TaskModel updatedTask) {
    onTaskChanged(updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colors.outline.withAlpha(50),
        ),
      ),
      child: Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'Today, I will ',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: TextSizes.L,
                ),
          ),
          SizedBox(
            width: task.title.isEmpty ? 140 : (task.title.length + 2) * 12,
            child: TextInput(
              text: task.title,
              label: 'task name',
              onTextChanged: (text) {
                _updateTask(task.copyWith(title: text));
              },
            ),
          ),
          if (showTimePicker) ...[
            Text(
              'at ',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: TextSizes.L,
                  ),
            ),
            TimeInput(
              time: task.startTime != null
                  ? TimeOfDay(
                      hour: task.startTime!.hour,
                      minute: task.startTime!.minute,
                    )
                  : TimeOfDay.now(),
              onTimeChanged: (time) {
                if (time != null) {
                  _updateTask(task.copyWith(
                    startTime: DateTime(
                      taskDay.year,
                      taskDay.month,
                      taskDay.day,
                      time.hour,
                      time.minute,
                    ),
                  ));
                }
              },
            ),
          ],
          if (showDurationSelector) ...[
            Text(
              'for ',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: TextSizes.L,
                  ),
            ),
            DurationInput(
              duration: task.duration?.inMinutes ?? 30,
              onDurationChanged: (minutes) {
                _updateTask(task.copyWith(
                  duration: minutes != null ? Duration(minutes: minutes) : null,
                ));
              },
            ),
          ],
        ],
      ),
    );
  }
}
