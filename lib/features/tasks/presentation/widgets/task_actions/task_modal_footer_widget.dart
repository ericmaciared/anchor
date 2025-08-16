import 'package:anchor/core/theme/text_sizes.dart';
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

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Confirm Deletion',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: TextSizes.XL,
                  ),
            ),
            content: Text(
              'Are you sure you want to delete this task?',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: TextSizes.M,
                  ),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: TextSizes.M,
                      ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Delete',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: TextSizes.M,
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _handleDelete(BuildContext context) async {
    if (onDelete == null) return;

    final confirmed = await _showDeleteConfirmation(context);
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
