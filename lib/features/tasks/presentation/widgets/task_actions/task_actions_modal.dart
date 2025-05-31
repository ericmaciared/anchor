import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/color_picker.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/duration_selector.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/footer_actions.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/icon_and_title.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/subtask_editor.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/suggested_tasks_list.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TaskActionsModal extends StatefulWidget {
  final Task? initialTask;
  final void Function(Task task) onSubmit;
  final void Function(Task task)? onDelete;

  const TaskActionsModal({
    super.key,
    this.initialTask,
    required this.onSubmit,
    this.onDelete,
  });

  @override
  State<TaskActionsModal> createState() => _TaskActionsModalState();
}

class _TaskActionsModalState extends State<TaskActionsModal> {
  late Task _task;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _task = widget.initialTask ??
        Task(
          id: const Uuid().v4(),
          title: '',
          isDone: false,
          day: DateTime(now.year, now.month, now.day),
          startTime: null,
          duration: null,
          color: Colors.blue,
          icon: Icons.check_circle_outline,
          subtasks: [],
        );
  }

  void _submit() {
    if (_task.title.trim().isEmpty) return;
    widget.onSubmit(_task);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialTask != null;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(
              top: 24,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: controller,
                    children: [
                      Text(
                        isEdit ? 'edit task' : 'new task',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 24),
                      IconAndTitle(
                        title: _task.title,
                        selectedIcon: _task.icon,
                        onTitleChanged: (text) =>
                            setState(() => _task = _task.copyWith(title: text)),
                        onIconChanged: (icon) =>
                            setState(() => _task = _task.copyWith(icon: icon)),
                      ),
                      const SizedBox(height: 36),
                      if (_task.title.trim().isEmpty && !isEdit)
                        SuggestedTasksList(
                          onTap: (suggested) {
                            setState(() {
                              _task = _task.copyWith(
                                title: suggested.title,
                                icon: suggested.icon,
                                color: suggested.color,
                                startTime: suggested.startTime,
                                duration: suggested.duration,
                              );
                            });
                          },
                        ),
                      if (_task.title.trim().isNotEmpty || isEdit) ...[
                        ColorPickerWidget(
                          selectedColor: _task.color,
                          onColorSelected: (color) => setState(
                              () => _task = _task.copyWith(color: color)),
                        ),
                        const SizedBox(height: 36),
                        TimePicker(
                          selectedTime: _task.startTime != null
                              ? TimeOfDay.fromDateTime(_task.startTime!)
                              : null,
                          onPick: (time) {
                            setState(() => _task = _task.copyWith(
                                startTime: time != null
                                    ? DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day,
                                        time.hour,
                                        time.minute,
                                      )
                                    : null));
                          },
                        ),
                        const SizedBox(height: 24),
                        DurationSelector(
                          duration: _task.duration?.inMinutes,
                          onChanged: (min) => setState(() => _task =
                              _task.copyWith(
                                  duration: min != null
                                      ? Duration(minutes: min)
                                      : null)),
                        ),
                        const SizedBox(height: 24),
                        SubtaskEditor(
                          subtasks: _task.subtasks,
                          onChanged: (subtasks) => setState(() {
                            _task = _task.copyWith(subtasks: subtasks);
                          }),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                FooterActions(
                  isEdit: isEdit,
                  isSaveEnabled: _task.title.trim().isNotEmpty,
                  onDelete: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: const Text(
                            'Are you sure you want to delete this task?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true &&
                        widget.onDelete != null &&
                        context.mounted) {
                      widget.onDelete!(widget.initialTask!);
                      Navigator.of(context).pop();
                    }
                  },
                  onSave: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
