import 'package:flutter/material.dart';

class FooterActions extends StatelessWidget {
  final bool isEdit;
  final VoidCallback onDelete;
  final VoidCallback onSave;

  const FooterActions({
    super.key,
    required this.isEdit,
    required this.onDelete,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isEdit)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: onDelete,
              child: Text('Delete',
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          ),
        Expanded(
          child: ElevatedButton(
            onPressed: onSave,
            child: Text(isEdit ? 'Update' : 'Create'),
          ),
        ),
      ],
    );
  }
}
