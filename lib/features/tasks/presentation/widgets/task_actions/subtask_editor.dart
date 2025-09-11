import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/color_opacities.dart';
import 'package:anchor/core/theme/spacing_sizes.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_button_widget.dart';
import 'package:anchor/features/shared/widgets/text_input.dart';
import 'package:anchor/features/tasks/domain/entities/subtask_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SubtaskEditor extends StatefulWidget {
  final String taskId;
  final List<SubtaskModel> subtasks;
  final ValueChanged<List<SubtaskModel>> onChanged;

  const SubtaskEditor({
    super.key,
    required this.taskId,
    required this.subtasks,
    required this.onChanged,
  });

  @override
  State<SubtaskEditor> createState() => _SubtaskEditorState();
}

class _SubtaskEditorState extends State<SubtaskEditor> {
  late List<SubtaskModel> _localSubtasks;
  final Map<String, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    _localSubtasks = List.from(widget.subtasks);
    _initializeFocusNodes();
  }

  @override
  void dispose() {
    for (final focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    _focusNodes.clear();
    super.dispose();
  }

  void _initializeFocusNodes() {
    // Create focus nodes for existing subtasks using their IDs as keys
    for (final subtask in _localSubtasks) {
      if (!_focusNodes.containsKey(subtask.id)) {
        _focusNodes[subtask.id] = FocusNode();
      }
    }
  }

  void _notifyChange() {
    // Filter out subtasks with empty or whitespace-only titles
    final validSubtasks = _localSubtasks.where((subtask) => subtask.title.trim().isNotEmpty).toList();

    widget.onChanged(List.unmodifiable(validSubtasks));
  }

// Alternative approach: Update the _updateTitle method to also filter
  void _updateTitle(int index, String title) {
    setState(() {
      _localSubtasks[index] = _localSubtasks[index].copyWith(title: title);
    });
    _notifyChange();
  }

  void _addSubtask() {
    HapticService.light();

    final newSubtask = SubtaskModel(
      id: const Uuid().v4(),
      taskId: widget.taskId,
      title: '',
      isDone: false,
    );

    setState(() {
      _localSubtasks.add(newSubtask);

      // Create focus node for the new subtask
      _focusNodes[newSubtask.id] = FocusNode();

      // Focus the new input after a brief delay
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[newSubtask.id]?.requestFocus();
      });
    });
    _notifyChange();
  }

  void _removeSubtask(int index) {
    HapticService.medium();

    final subtaskToRemove = _localSubtasks[index];

    setState(() {
      _localSubtasks.removeAt(index);

      // Dispose and remove the focus node for the removed subtask
      _focusNodes[subtaskToRemove.id]?.dispose();
      _focusNodes.remove(subtaskToRemove.id);
    });
    _notifyChange();
  }

  void _moveToNextField(int currentIndex) {
    if (currentIndex + 1 < _localSubtasks.length) {
      final nextSubtask = _localSubtasks[currentIndex + 1];
      _focusNodes[nextSubtask.id]?.requestFocus();
    } else {
      // If it's the last field, create a new subtask
      _addSubtask();
    }
  }

  Widget _buildSubtaskItem(int index, SubtaskModel subtask) {
    return Container(
      margin: const EdgeInsets.only(bottom: SpacingSizes.m),
      padding: const EdgeInsets.all(SpacingSizes.m),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colors.outline.withAlpha(ColorOpacities.opacity10),
        ),
      ),
      child: Row(
        children: [
          // Drag handle
          Container(
            padding: const EdgeInsets.all(SpacingSizes.xs),
            child: Icon(
              Icons.drag_handle,
              size: 16,
              color: context.colors.onSurface.withAlpha(ColorOpacities.opacity40),
            ),
          ),

          const SizedBox(width: SpacingSizes.s),

          // Text input
          Expanded(
            child: TextInput(
              key: ValueKey(subtask.id),
              // Add a key to help Flutter track the widget
              text: subtask.title,
              label: 'Subtask ${index + 1}',
              variant: TextInputVariant.secondary,
              textAlign: TextAlign.left,
              focusNode: _focusNodes[subtask.id],
              textInputAction: TextInputAction.next,
              onTextChanged: (value) => _updateTitle(index, value),
              onEditingComplete: () => _moveToNextField(index),
            ),
          ),

          const SizedBox(width: SpacingSizes.s),

          // Delete button
          AdaptiveButtonWidget(
            width: 32,
            height: 32,
            borderRadius: 16,
            enableHaptics: false,
            primaryColor: context.colors.error.withAlpha(ColorOpacities.opacity10),
            onPressed: () => _removeSubtask(index),
            child: Icon(
              Icons.close,
              size: 16,
              color: context.colors.error,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Icon(
              Icons.list_outlined,
              size: 20,
              color: context.colors.primary,
            ),
            const SizedBox(width: SpacingSizes.s),
            Text(
              'Subtasks',
              style: context.textStyles.titleMedium?.copyWith(
                fontSize: TextSizes.l,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            AdaptiveButtonWidget(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              borderRadius: 12,
              primaryColor: context.colors.primary.withAlpha(ColorOpacities.opacity10),
              enableHaptics: false,
              onPressed: _addSubtask,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    size: 16,
                    color: context.colors.primary,
                  ),
                  const SizedBox(width: SpacingSizes.xs),
                  Text(
                    'Add',
                    style: context.textStyles.bodyMedium?.copyWith(
                      fontSize: TextSizes.s,
                      fontWeight: FontWeight.w600,
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: SpacingSizes.m),

        // Subtasks list
        if (_localSubtasks.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(SpacingSizes.l),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHigh.withAlpha(ColorOpacities.opacity40),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.colors.outline.withAlpha(ColorOpacities.opacity10),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.checklist_outlined,
                  size: 32,
                  color: context.colors.onSurface.withAlpha(ColorOpacities.opacity40),
                ),
                const SizedBox(height: SpacingSizes.s),
                Text(
                  'No subtasks yet',
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: context.colors.onSurface.withAlpha(ColorOpacities.opacity60),
                    fontSize: TextSizes.m,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Break down this task into smaller steps',
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.onSurface.withAlpha(ColorOpacities.opacity40),
                    fontSize: TextSizes.s,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ...List.generate(
            _localSubtasks.length,
            (index) => _buildSubtaskItem(index, _localSubtasks[index]),
          ),
      ],
    );
  }
}
