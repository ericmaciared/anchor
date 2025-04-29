import 'package:flutter/material.dart';

class UndoConfirmationDialog extends StatelessWidget {
  const UndoConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Undo Completion'),
      content: const Text('Do you want to undo the completion of this task?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Undo'),
        ),
      ],
    );
  }
}
