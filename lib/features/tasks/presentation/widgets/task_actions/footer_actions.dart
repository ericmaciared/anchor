import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/color_opacities.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_button_widget.dart';
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
      mainAxisAlignment: isEdit ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
      children: [
        if (isEdit)
          AdaptiveButtonWidget(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            height: 48,
            onPressed: () {
              HapticService.heavy(); // Heavy feedback for delete action
              onDelete();
            },
            child: Text('Delete', style: context.textStyles.bodyMedium?.copyWith(color: context.colors.error)),
          ),
        AdaptiveButtonWidget(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          height: 48,
          onPressed: isSaveEnabled
              ? () {
                  HapticService.success(); // Success feedback for save action
                  onSave();
                }
              : null,
          enabled: isSaveEnabled,
          child: Text(
            isEdit ? 'Save Changes' : 'Create Task',
            style: context.textStyles.bodyMedium?.copyWith(
              color: isSaveEnabled
                  ? context.colors.onSurface
                  : context.colors.onSurface.withAlpha(ColorOpacities.opacity40),
            ),
          ),
        ),
      ],
    );
  }
}
