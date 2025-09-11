import 'package:anchor/core/theme/color_opacities.dart';
import 'package:anchor/core/theme/spacing_sizes.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/features/shared/widgets/text_input.dart';
import 'package:anchor/features/shared/widgets/time_input.dart';
import 'package:anchor/features/shared/widgets/duration_input.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:flutter/material.dart';

class TaskInputSection extends StatelessWidget {
  final TaskModel task;
  final DateTime taskDay;
  final bool showTimePicker;
  final bool showDurationSelector;
  final ValueChanged<TaskModel> onTaskChanged;

  static const int maxTaskTitleLength = 50; // Character limit for tasks

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

  TimeOfDay _getTimeOfDay() {
    if (task.startTime != null) {
      return TimeOfDay(
        hour: task.startTime!.hour,
        minute: task.startTime!.minute,
      );
    }
    // Fallback to current time if no start time is set
    final now = DateTime.now();
    return TimeOfDay(hour: now.hour, minute: now.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main input container
        Container(
          padding: const EdgeInsets.all(SpacingSizes.m),
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.colors.outline.withAlpha(ColorOpacities.opacity20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First row with "Today, I will" text
              Text(
                'Today, I will',
                style: context.textStyles.bodyMedium!.copyWith(
                  fontSize: TextSizes.xxl, // Match the other text sizes
                  fontWeight: FontWeight.w700, // Match the input weight
                  color: context.colors.onSurface,
                ),
              ),
              const SizedBox(height: SpacingSizes.xs),
              // Full width text input
              TextInput(
                text: task.title,
                label: 'task name',
                maxLength: maxTaskTitleLength,
                fontSize: TextSizes.xxl,
                // Explicit font size
                fontWeight: FontWeight.w700,
                // Match other elements
                textAlign: TextAlign.left,
                onTextChanged: (text) {
                  _updateTask(task.copyWith(title: text));
                },
              ),

              // Second row with time and duration (if enabled)
              if (showTimePicker || showDurationSelector) ...[
                const SizedBox(height: SpacingSizes.s), // Reduced spacing
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (showTimePicker) ...[
                      Text(
                        'at ',
                        style: context.textStyles.bodyMedium!.copyWith(
                          fontSize: TextSizes.xxl, // Match other elements
                          fontWeight: FontWeight.w700, // Match other elements
                          color: context.colors.onSurface,
                        ),
                      ),
                      // Use your existing TimeInput widget
                      TimeInput(
                        time: _getTimeOfDay(),
                        onTimeChanged: (time) {
                          if (time != null) {
                            final newStartTime = DateTime(
                              taskDay.year,
                              taskDay.month,
                              taskDay.day,
                              time.hour,
                              time.minute,
                            );
                            _updateTask(task.copyWith(startTime: newStartTime));
                          }
                        },
                      ),
                      if (showDurationSelector) ...[
                        Text(
                          ' for ',
                          style: context.textStyles.bodyMedium!.copyWith(
                            fontSize: TextSizes.xxl,
                            fontWeight: FontWeight.w700,
                            color: context.colors.onSurface,
                          ),
                        ),
                      ],
                    ],
                    if (showDurationSelector) ...[
                      // Use your existing DurationInput widget
                      DurationInput(
                        duration: task.duration?.inMinutes,
                        onDurationChanged: (durationInMinutes) {
                          final duration = durationInMinutes != null ? Duration(minutes: durationInMinutes) : null;
                          _updateTask(task.copyWith(duration: duration));
                        },
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: SpacingSizes.xs),
        // Character count indicator
        _buildCharacterCount(context),
      ],
    );
  }

  Widget _buildCharacterCount(BuildContext context) {
    final currentLength = task.title.length;
    final isNearLimit = currentLength > maxTaskTitleLength * 0.8;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$currentLength/$maxTaskTitleLength',
          style: context.textStyles.bodySmall!.copyWith(
            color: currentLength > maxTaskTitleLength
                ? context.colors.error
                : isNearLimit
                    ? context.colors.secondary
                    : context.colors.onSurface.withAlpha(ColorOpacities.opacity60),
            fontWeight: isNearLimit ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
