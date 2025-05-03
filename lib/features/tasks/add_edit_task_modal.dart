import 'package:flutter/material.dart';

import 'models/task_model.dart';

class AddEditTaskModal extends StatefulWidget {
  final Task? existingTask;
  final void Function(Task task) onSubmit;
  final void Function()? onDelete;

  const AddEditTaskModal({
    super.key,
    this.existingTask,
    required this.onSubmit,
    this.onDelete,
  });

  @override
  State<AddEditTaskModal> createState() => _AddEditTaskModalState();
}

class _AddEditTaskModalState extends State<AddEditTaskModal> {
  late final TextEditingController _titleController;
  late final TextEditingController _categoryController;
  TimeOfDay _startTime = TimeOfDay.now();
  Duration _duration = const Duration(hours: 1);

  @override
  void initState() {
    super.initState();
    final task = widget.existingTask;
    _titleController = TextEditingController(text: task?.title ?? '');
    _categoryController = TextEditingController(text: task?.category ?? '');
    if (task != null) {
      _startTime = task.startTime;
      _duration = task.duration;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _submit() {
    final task = Task(
      id: widget.existingTask?.id ?? DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text,
      category: _categoryController.text,
      startTime: _startTime,
      duration: _duration,
      completed: widget.existingTask?.completed ?? false,
    );
    widget.onSubmit(task);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title')),
          TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category')),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _submit,
            child:
                Text(widget.existingTask == null ? 'Add Task' : 'Save Changes'),
          ),
          if (widget.existingTask != null && widget.onDelete != null)
            TextButton(
              onPressed: () {
                widget.onDelete!();
                Navigator.of(context).pop();
              },
              child: const Text('Delete Task',
                  style: TextStyle(color: Colors.red)),
            )
        ],
      ),
    );
  }
}
