import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:flutter/material.dart';

class FooterActions extends StatelessWidget {
  final bool isEdit;
  final VoidCallback onDelete;
  final VoidCallback onSave;
  final bool isSaveEnabled;

  const FooterActions({
    super.key,
    required this.isEdit,
    required this.onDelete,
    required this.onSave,
    required this.isSaveEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isEdit)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: () {
                HapticService.heavy(); // Heavy feedback for delete action
                onDelete();
              },
              child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          ),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isSaveEnabled ? null : Theme.of(context).colorScheme.onSurface.withAlpha(100),
            ),
            onPressed: isSaveEnabled
                ? () {
                    HapticService.success(); // Success feedback for save action
                    onSave();
                  }
                : null,
            child: Text(isEdit ? 'Save Changes' : 'Create Task'),
          ),
        ),
      ],
    );
  }
}
