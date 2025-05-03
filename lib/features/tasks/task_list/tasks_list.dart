import 'package:anchor/features/tasks/add_edit_task_modal.dart';
import 'package:anchor/features/tasks/tasks_provider.dart';
import 'package:anchor/shared/modals/undo_confirmation_dialog.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task_model.dart';
import 'task_list_view.dart';

class TasksList extends ConsumerStatefulWidget {
  final List<Task> tasks;

  const TasksList({super.key, required this.tasks});

  @override
  ConsumerState<TasksList> createState() => _TasksListState();
}

class _TasksListState extends ConsumerState<TasksList> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _markTaskCompleted(Task task) {
    HapticFeedback.lightImpact();
    setState(() {
      task.completed = true;
    });
    _confettiController.play();
  }

  void _undoTaskCompleted(Task task) {
    HapticFeedback.lightImpact();
    setState(() {
      task.completed = false;
    });
  }

  Future<void> _confirmUndoTask(Task task) async {
    final bool? shouldUndo = await showDialog<bool>(
      context: context,
      builder: (context) => const UndoConfirmationDialog(),
    );

    if (shouldUndo == true) {
      _undoTaskCompleted(task);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tasks.isEmpty) {
      return const Center(child: Text('No tasks for today'));
    }
    return Stack(
      children: [
        TaskListView(
          tasks: widget.tasks,
          onMarkCompleted: _markTaskCompleted,
          onUndoCompleted: _confirmUndoTask,
          onTapTask: (task) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => AddEditTaskModal(
                existingTask: task,
                onSubmit: (updatedTask) async {
                  await ref.read(tasksProvider.notifier).addTask(
                      updatedTask); // replace with updateTask() if added
                },
                onDelete: () async {
                  // TODO: implement deleteTask
                },
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ),
      ],
    );
  }
}
