import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TaskActionsDialog extends StatefulWidget {
  final Task? initialTask;
  final void Function(Task task) onSubmit;
  final void Function(Task task)? onDelete;

  const TaskActionsDialog({
    super.key,
    this.initialTask,
    required this.onSubmit,
    this.onDelete,
  });

  @override
  State<TaskActionsDialog> createState() => _TaskActionsDialogState();
}

class _TaskActionsDialogState extends State<TaskActionsDialog> {
  final _titleController = TextEditingController();
  TimeOfDay? _selectedTime;
  int? _durationMinutes;

  @override
  void initState() {
    super.initState();
    final task = widget.initialTask;
    if (task != null) {
      _titleController.text = task.title;
      if (task.startTime != null) {
        _selectedTime = TimeOfDay.fromDateTime(task.startTime!);
      }
      _durationMinutes = task.duration?.inMinutes;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final now = DateTime.now();
    final DateTime? startTime = _selectedTime != null
        ? DateTime(now.year, now.month, now.day, _selectedTime!.hour,
            _selectedTime!.minute)
        : null;

    final newTask = Task(
      id: widget.initialTask?.id ?? const Uuid().v4(),
      title: title,
      isDone: widget.initialTask?.isDone ?? false,
      startTime: startTime,
      duration: _durationMinutes != null
          ? Duration(minutes: _durationMinutes!)
          : null,
    );

    widget.onSubmit(newTask);
    Navigator.of(context).pop();
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // close confirmation
              Navigator.of(context).pop(); // close main dialog
              if (widget.initialTask != null && widget.onDelete != null) {
                widget.onDelete!(widget.initialTask!);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialTask != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit Task' : 'New Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectedTime == null
                      ? 'Start time: Not set'
                      : 'Start time: ${_selectedTime!.format(context)}',
                ),
              ),
              TextButton(
                onPressed: _pickTime,
                child: const Text('Pick Time'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Duration:'),
              const SizedBox(width: 12),
              DropdownButton<int>(
                value: _durationMinutes,
                hint: const Text('Select'),
                items: [15, 30, 45, 60, 90, 120]
                    .map((min) => DropdownMenuItem(
                          value: min,
                          child: Text('$min min'),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _durationMinutes = value),
              ),
            ],
          ),
        ],
      ),
      actions: [
        if (isEdit)
          TextButton(
            onPressed: _confirmDelete,
            child: const Text('Delete'),
          ),
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
