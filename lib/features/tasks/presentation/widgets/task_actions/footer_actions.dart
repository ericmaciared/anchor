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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (isEdit)
          TextButton(onPressed: onDelete, child: const Text('Delete')),
        ElevatedButton(onPressed: onSave, child: const Text('Save')),
      ],
    );
  }
}
