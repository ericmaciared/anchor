import 'package:anchor/core/widgets/adaptive_dialog_widget.dart'; // Add this import
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/footer_actions.dart';
import 'package:flutter/material.dart';

class TaskModalFooter extends StatelessWidget {
  final TaskModel task;
  final bool isEdit;
  final VoidCallback onSave;
  final VoidCallback? onDelete;

  const TaskModalFooter({
    super.key,
    required this.task,
    required this.isEdit,
    required this.onSave,
    this.onDelete,
  });

  Future<void> _handleDelete(BuildContext context) async {
    if (onDelete == null) return;

    final confirmed = await DialogHelper.showDeleteConfirmation(
      context: context,
      itemName: task.title.isNotEmpty ? task.title : 'this task',
    );

    if (confirmed) {
      onDelete!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FooterActions(
        isEdit: isEdit,
        isSaveEnabled: task.title.trim().isNotEmpty,
        onDelete: () => _handleDelete(context),
        onSave: onSave,
      ),
    );
  }
}
