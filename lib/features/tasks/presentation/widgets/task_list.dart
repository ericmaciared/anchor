import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/features/shared/settings/settings_provider.dart';
import 'package:anchor/features/tasks/domain/entities/subtask_model.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_card/minimal_task_card.dart'; // Still need this import
import 'package:anchor/features/tasks/presentation/widgets/task_card/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef TaskCallback = void Function(TaskModel task);

class TaskList extends ConsumerWidget {
  final List<TaskModel> tasks;
  final String? label;
  final void Function(TaskModel task) onToggleTaskCompletion;
  final void Function(SubtaskModel subtask) onToggleSubtaskCompletion;
  final TaskCallback onLongPress;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onToggleTaskCompletion,
    required this.onToggleSubtaskCompletion,
    required this.onLongPress,
    this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsyncValue = ref.watch(settingsProvider);

    String displayDensity = 'Normal';

    settingsAsyncValue.when(
      data: (settings) {
        displayDensity = settings.displayDensity;
      },
      loading: () {},
      error: (err, stack) {
        debugPrint('Error loading settings for TaskList: $err');
      },
    );

    if (tasks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              label!,
              style: context.textStyles.titleMedium,
            ),
          ),
        ...tasks.map(
          (task) => displayDensity == 'Compact'
              ? MinimalTaskCard(
                  task: task,
                  onToggleTaskCompletion: () => onToggleTaskCompletion(task),
                  onLongPress: () => onLongPress(task),
                  onToggleSubtaskCompletion: (subtask) => onToggleSubtaskCompletion(subtask),
                )
              : TaskCard(
                  task: task,
                  onToggleTaskCompletion: () => onToggleTaskCompletion(task),
                  onLongPress: () => onLongPress(task),
                  onToggleSubtaskCompletion: (subtask) => onToggleSubtaskCompletion(subtask),
                ),
        ),
      ],
    );
  }
}
