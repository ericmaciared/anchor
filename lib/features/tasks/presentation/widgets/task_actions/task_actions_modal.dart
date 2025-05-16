import 'package:anchor/features/tasks/domain/entities/task.dart';
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
  final _titleController = TextEditingController();
  TimeOfDay? _selectedTime;
  int? _durationMinutes;
  Color _selectedColor = Colors.blue;
  IconData _selectedIcon = Icons.check_circle_outline;

  final _availableIcons = [
    Icons.work,
    Icons.fitness_center,
    Icons.book,
    Icons.shopping_cart,
    Icons.music_note,
    Icons.pets,
  ];

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
      _selectedColor = task.color;
      _selectedIcon = task.icon;
    }
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final now = DateTime.now();
    final startTime = _selectedTime != null
        ? DateTime(now.year, now.month, now.day, _selectedTime!.hour,
            _selectedTime!.minute)
        : null;

    final newTask = Task(
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

    widget.onSubmit(newTask);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialTask != null;
    final mediaQuery = MediaQuery.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        padding: EdgeInsets.only(
          top: 24,
          left: 20,
          right: 20,
          bottom: mediaQuery.viewInsets.bottom + 20,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          controller: controller,
          children: [
            Text(
              isEdit ? 'Edit Task' : 'New Task',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => Wrap(
                        children: _availableIcons.map((icon) {
                          return IconButton(
                            icon: Icon(icon),
                            onPressed: () {
                              setState(() => _selectedIcon = icon);
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                  icon: Icon(_selectedIcon, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Task Name',
                    ),
                  ),
                ),
              ],
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
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime ?? TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setState(() => _selectedTime = picked);
                    }
                  },
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
                  onChanged: (value) =>
                      setState(() => _durationMinutes = value),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Color:'),
                const SizedBox(width: 12),
                ...[
                  Colors.blue,
                  Colors.green,
                  Colors.orange,
                  Colors.red,
                  Colors.purple,
                  Colors.teal,
                ].map((color) {
                  final isSelected = _selectedColor == color;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isSelected ? 30 : 24,
                      height: isSelected ? 30 : 24,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.black, width: 2)
                            : null,
                      ),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isEdit)
                  TextButton(
                    onPressed: () async {
                      final confirmed = await showDialog(
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
                    child: const Text('Delete'),
                  ),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
