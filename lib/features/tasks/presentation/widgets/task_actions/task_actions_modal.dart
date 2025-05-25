import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:anchor/features/tasks/presentation/models/subtask_form_model.dart';
import 'package:anchor/features/tasks/presentation/models/task_form_model.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/color_picker.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/duration_selector.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/footer_actions.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/icon_and_title.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/suggested_tasks_list.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/time_picker.dart';
import 'package:flutter/material.dart';

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
  late TaskFormModel _form;
  final List<SubtaskFormModel> _subtasks = [];

  @override
  void initState() {
    super.initState();
    _form = widget.initialTask != null
        ? TaskFormModel.fromTask(widget.initialTask!)
        : TaskFormModel.empty();
  }

  void _submit() {
    if (!_form.isValid) return;

    // Submit parent task
    final mainTask = _form.toTask();
    widget.onSubmit(mainTask);

    // Submit subtasks with parentTaskId
    for (final subtaskForm in _subtasks.where((s) => s.isValid)) {
      final subtask = subtaskForm.toTask(mainTask.id);
      widget.onSubmit(subtask);
    }

    Navigator.of(context).pop();
  }

  void _addSubtask() {
    setState(() {
      _subtasks.add(SubtaskFormModel());
    });
  }

  Widget _buildSubtaskFields(SubtaskFormModel subtask, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Subtask title',
              ),
              onChanged: (val) => setState(() => subtask.title = val),
            ),
          ),
          const SizedBox(width: 8),
          Checkbox(
            value: subtask.isDone,
            onChanged: (val) => setState(() => subtask.isDone = val ?? false),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => setState(() => _subtasks.removeAt(index)),
          ),
        ],
      ),
    );
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
                        title: _form.title,
                        selectedIcon: _form.icon,
                        onTitleChanged: (text) =>
                            setState(() => _form.title = text),
                        onIconChanged: (icon) =>
                            setState(() => _form.icon = icon),
                      ),
                      const SizedBox(height: 36),
                      if (!_form.isValid && !isEdit)
                        SuggestedTasksList(
                          onTap: (task) {
                            setState(() {
                              _form.title = task.title;
                              _form.icon = task.icon;
                              _form.color = task.color;
                              _form.selectedTime = task.startTime != null
                                  ? TimeOfDay.fromDateTime(task.startTime!)
                                  : null;
                              _form.durationMinutes = task.duration?.inMinutes;
                            });
                          },
                        ),
                      if (_form.isValid || isEdit) ...[
                        ColorPickerWidget(
                          selectedColor: _form.color,
                          onColorSelected: (color) =>
                              setState(() => _form.color = color),
                        ),
                        const SizedBox(height: 36),
                        TimePicker(
                          selectedTime: _form.selectedTime,
                          onPick: (time) =>
                              setState(() => _form.selectedTime = time),
                        ),
                        const SizedBox(height: 24),
                        DurationSelector(
                          duration: _form.durationMinutes,
                          onChanged: (min) =>
                              setState(() => _form.durationMinutes = min),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtasks',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          TextButton.icon(
                            onPressed: _addSubtask,
                            icon: const Icon(Icons.add),
                            label: const Text('Add'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ..._subtasks
                          .asMap()
                          .entries
                          .map((e) => _buildSubtaskFields(e.value, e.key)),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                FooterActions(
                  isEdit: isEdit,
                  isSaveEnabled: _form.isValid,
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
