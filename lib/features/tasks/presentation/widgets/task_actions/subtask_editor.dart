import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_button_widget.dart';
import 'package:anchor/features/tasks/domain/entities/subtask_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SubtaskEditor extends StatefulWidget {
  final List<SubtaskModel> subtasks;
  final ValueChanged<List<SubtaskModel>> onChanged;

  const SubtaskEditor({
    super.key,
    required this.subtasks,
    required this.onChanged,
  });

  @override
  State<SubtaskEditor> createState() => _SubtaskEditorState();
}

class _SubtaskEditorState extends State<SubtaskEditor> {
  late List<SubtaskModel> _localSubtasks;

  @override
  void initState() {
    super.initState();
    _localSubtasks = List.from(widget.subtasks);
  }

  void _notifyChange() {
    widget.onChanged(List.unmodifiable(_localSubtasks));
  }

  void _addSubtask() {
    HapticService.light(); // Light feedback for adding subtask

    setState(() {
      _localSubtasks.add(
        SubtaskModel(
          id: const Uuid().v4(),
          taskId: '',
          title: '',
          isDone: false,
        ),
      );
    });
    _notifyChange();
  }

  void _removeSubtask(int index) {
    HapticService.medium(); // Medium feedback for removing subtask

    setState(() {
      _localSubtasks.removeAt(index);
    });
    _notifyChange();
  }

  void _updateTitle(int index, String title) {
    setState(() {
      _localSubtasks[index] = _localSubtasks[index].copyWith(title: title);
    });
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subtasks',
              style: context.textStyles.titleMedium,
            ),
            AdaptiveButtonWidget(
              onPressed: _addSubtask,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add, size: 16),
                  SizedBox(width: 4),
                  Text('Add'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._localSubtasks.asMap().entries.map((entry) {
          final index = entry.key;
          final subtask = entry.value;

          final controller = TextEditingController(text: subtask.title);
          controller.selection = TextSelection.collapsed(offset: controller.text.length);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'Subtask title'),
                    onChanged: (val) => _updateTitle(index, val),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeSubtask(index),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
