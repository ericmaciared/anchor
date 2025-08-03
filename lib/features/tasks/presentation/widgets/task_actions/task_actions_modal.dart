import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/features/shared/widgets/duration_input.dart';
import 'package:anchor/features/shared/widgets/text_input.dart';
import 'package:anchor/features/shared/widgets/time_input.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/footer_actions.dart';
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

  bool _showTimePicker = false;
  bool _showDurationSelector = false;

  // Add more booleans for other options if you plan to implement them

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

    // Initialize visibility based on existing task data
    _showTimePicker = _task.startTime != null;
    _showDurationSelector = _task.duration != null;
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
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontSize: TextSizes.XXL,
                              ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Today, I will ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: TextSizes.L),
                        ),
                        SizedBox(
                          width: _task.title.isEmpty
                              ? 140
                              : (_task.title.length + 2) * 12,
                          child: TextInput(
                            text: _task.title,
                            label: 'task name',
                            onTextChanged: (text) => setState(
                                () => _task = _task.copyWith(title: text)),
                          ),
                        ),
                        if (_showTimePicker) ...[
                          Text(
                            'at ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: TextSizes.L),
                          ),
                          TimeInput(
                            time: _task.startTime != null
                                ? TimeOfDay(
                                    hour: _task.startTime!.hour,
                                    minute: _task.startTime!.minute)
                                : TimeOfDay.now(),
                            onTimeChanged: (time) {
                              setState(() => _task = _task.copyWith(
                                  startTime: time != null
                                      ? DateTime(
                                          widget.taskDay.year,
                                          widget.taskDay.month,
                                          widget.taskDay.day,
                                          time.hour,
                                          time.minute,
                                        )
                                      : null));
                            },
                          ),
                        ],
                        if (_showDurationSelector) ...[
                          Text(
                            'for ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: TextSizes.L),
                          ),
                          DurationInput(
                              duration: _task.duration != null
                                  ? _task.duration!.inMinutes
                                  : const Duration(minutes: 15).inMinutes,
                              onDurationChanged: (min) => setState(() => _task =
                                  _task.copyWith(
                                      duration: min != null
                                          ? Duration(minutes: min)
                                          : null)))
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        label: Text(_showTimePicker
                            ? 'Remove Start Time'
                            : 'Add Start Time'),
                        onPressed: () {
                          setState(() {
                            _showTimePicker = !_showTimePicker;
                            if (!_showTimePicker) {
                              _task = _task.copyWith(startTime: null);
                            }
                          });
                        },
                      ),
                      ActionChip(
                        label: Text(_showDurationSelector
                            ? 'Remove Duration'
                            : 'Add Duration'),
                        onPressed: () {
                          setState(() {
                            _showDurationSelector = !_showDurationSelector;
                            if (!_showDurationSelector) {
                              // If toggled off, also clear the value
                              _task = _task.copyWith(duration: null);
                            }
                          });
                        },
                      ),
                      ActionChip(
                        label: const Text('Add Color'),
                        onPressed: () {
                          // Implement toggle logic for color picker
                        },
                      ),
                      ActionChip(
                        label: const Text('Add Subtasks'),
                        onPressed: () {
                          // Implement toggle logic for subtask editor
                        },
                      ),
                      ActionChip(
                        label: const Text('Add Notifications'),
                        onPressed: () {
                          // Implement toggle logic for notifications
                        },
                      ),
                    ],
                  ),
                ),
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
                        title: Text('Confirm Deletion',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: TextSizes.XL)),
                        content: Text(
                            'Are you sure you want to delete this task?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: TextSizes.M)),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(false),
                            child: Text(
                              'Cancel',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: TextSizes.M,
                                  ),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(true),
                            child: Text(
                              'Delete',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: TextSizes.M,
                                      color:
                                          Theme.of(context).colorScheme.error),
                            ),
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
