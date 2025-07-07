import 'package:anchor/features/shared/widgets/icon_and_title.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/color_picker.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/duration_selector.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/footer_actions.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/notification_configurator.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/subtask_editor.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/suggested_tasks_chips.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TaskActionsModal extends StatefulWidget {
  final DateTime taskDay;
  final TaskModel? initialTask;
  final void Function(TaskModel task) onSubmit;
  final void Function(TaskModel task)? onDelete;

  const TaskActionsModal({
    super.key,
    required this.taskDay,
    this.initialTask,
    required this.onSubmit,
    this.onDelete,
  });

  @override
  State<TaskActionsModal> createState() => _TaskActionsModalState();
}

class _TaskActionsModalState extends State<TaskActionsModal> {
  late TaskModel _task;

  @override
  void initState() {
    super.initState();
    final day = widget.initialTask?.startTime ?? widget.taskDay;
    _task = widget.initialTask ??
        TaskModel(
          id: const Uuid().v4(),
          title: '',
          isDone: false,
          day: DateTime(day.year, day.month, day.day),
          startTime: null,
          duration: null,
          color: Colors.blue,
          icon: Icons.check_circle_outline,
          subtasks: [],
          notifications: [],
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
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.only(
                    top: 24,
                    left: 16,
                    right: 16,
                  ),
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
                    ColorPickerWidget(
                      selectedColor: _task.color,
                      onColorSelected: (color) =>
                          setState(() => _task = _task.copyWith(color: color)),
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
                      onChanged: (min) => setState(() => _task = _task.copyWith(
                          duration:
                              min != null ? Duration(minutes: min) : null)),
                    ),
                    const SizedBox(height: 24),
                    SubtaskEditor(
                      subtasks: _task.subtasks,
                      onChanged: (subtasks) => setState(() {
                        _task = _task.copyWith(subtasks: subtasks);
                      }),
                    ),
                    const SizedBox(height: 24),
                    NotificationConfigurator(
                      notifications: _task.notifications,
                      taskStartTime: _task.startTime,
                      onChanged: (notifications) => setState(
                        () {
                          _task = _task.copyWith(notifications: notifications);
                        },
                      ),
                    )
                  ],
                ),
              ),
              if (!isEdit && _task.title.trim().isEmpty)
                SuggestedTasksChips(
                  onSuggestionSelected: (suggested) {
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FooterActions(
                  isEdit: isEdit,
                  isSaveEnabled: _task.title.trim().isNotEmpty,
                  onDelete: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: const Text(
                            'Are you sure you want to delete this task?'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if ((confirmed ?? false) && widget.onDelete != null) {
                      widget.onDelete!(widget.initialTask!);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  onSave: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
