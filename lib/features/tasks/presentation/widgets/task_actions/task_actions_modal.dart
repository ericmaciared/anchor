import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/icon_and_title.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'color_picker.dart';
import 'duration_selector.dart';
import 'footer_actions.dart';
import 'suggested_tasks_list.dart';
import 'time_picker.dart';

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
  String _title = '';
  TimeOfDay? _selectedTime;
  int? _durationMinutes;
  Color _selectedColor = Colors.blue;
  IconData _selectedIcon = Icons.check_circle_outline;

  bool get _isTitleEntered => _title.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    final task = widget.initialTask;
    if (task != null) {
      _title = task.title;
      _selectedTime = task.startTime != null
          ? TimeOfDay.fromDateTime(task.startTime!)
          : null;
      _durationMinutes = task.duration?.inMinutes;
      _selectedColor = task.color;
      _selectedIcon = task.icon;
    }
  }

  void _submit() {
    final title = _title.trim();
    if (title.isEmpty) return;

    final now = DateTime.now();
    final startTime = _selectedTime != null
        ? DateTime(now.year, now.month, now.day, _selectedTime!.hour,
            _selectedTime!.minute)
        : null;

    final task = Task(
      id: widget.initialTask?.id ?? const Uuid().v4(),
      title: title,
      isDone: widget.initialTask?.isDone ?? false,
      day: now,
      startTime: startTime,
      duration: _durationMinutes != null
          ? Duration(minutes: _durationMinutes!)
          : null,
      color: _selectedColor,
      icon: _selectedIcon,
    );

    widget.onSubmit(task);
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
                      Text(isEdit ? 'edit task' : 'new task',
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 24),
                      IconAndTitle(
                        title: _title,
                        selectedIcon: _selectedIcon,
                        onTitleChanged: (text) => setState(() => _title = text),
                        onIconChanged: (icon) =>
                            setState(() => _selectedIcon = icon),
                      ),
                      const SizedBox(height: 36),
                      if (!_isTitleEntered)
                        SuggestedTasksList(
                          onTap: (task) {
                            setState(() {
                              _title = task.title;
                              _selectedIcon = task.icon;
                              _selectedColor = task.color;
                              _selectedTime = task.startTime != null
                                  ? TimeOfDay.fromDateTime(task.startTime!)
                                  : null;
                              _durationMinutes = task.duration?.inMinutes;
                            });
                          },
                        ),
                      if (_isTitleEntered) ...[
                        ColorPickerWidget(
                          selectedColor: _selectedColor,
                          onColorSelected: (color) =>
                              setState(() => _selectedColor = color),
                        ),
                        const SizedBox(height: 36),
                        TimePicker(
                          selectedTime: _selectedTime,
                          onPick: (time) =>
                              setState(() => _selectedTime = time),
                        ),
                        const SizedBox(height: 24),
                        DurationSelector(
                          duration: _durationMinutes,
                          onChanged: (min) =>
                              setState(() => _durationMinutes = min),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                FooterActions(
                  isEdit: isEdit,
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
