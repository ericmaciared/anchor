import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/color_opacities.dart';
import 'package:anchor/core/theme/spacing_sizes.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_button_widget.dart';
import 'package:flutter/material.dart';

class AdaptiveDialogWidget extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? contentWidget;
  final String? primaryActionText;
  final String? secondaryActionText;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;
  final Color? primaryActionColor;
  final bool isDangerous;
  final bool barrierDismissible;

  const AdaptiveDialogWidget({
    super.key,
    required this.title,
    this.content,
    this.contentWidget,
    this.primaryActionText,
    this.secondaryActionText,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.primaryActionColor,
    this.isDangerous = false,
    this.barrierDismissible = true,
  }) : assert(
          content != null || contentWidget != null,
          'Either content or contentWidget must be provided',
        );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(SpacingSizes.m),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(ColorOpacities.opacity10),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                children: [
                  // Title
                  Text(
                    title,
                    style: context.textStyles.headlineMedium?.copyWith(
                      fontSize: TextSizes.xl,
                      fontWeight: FontWeight.w600,
                      color: isDangerous ? context.colors.error : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Content
            if (content != null || contentWidget != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: contentWidget ??
                    Text(
                      content!,
                      style: context.textStyles.bodyMedium?.copyWith(
                        fontSize: TextSizes.m,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
              ),

            // Actions
            if (primaryActionText != null || secondaryActionText != null)
              Container(
                padding: const EdgeInsets.all(SpacingSizes.l),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: context.colors.outline.withAlpha(ColorOpacities.opacity20),
                    ),
                  ),
                ),
                child: _buildActions(context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final hasSecondary = secondaryActionText != null;

    if (!hasSecondary && primaryActionText != null) {
      // Single action - full width
      return SizedBox(
        width: double.infinity,
        child: AdaptiveButtonWidget(
          height: 48,
          borderRadius: 24,
          enableHaptics: false,
          primaryColor: _getPrimaryActionColor(context),
          onPressed: () {
            if (isDangerous) {
              HapticService.heavy();
            } else {
              HapticService.medium();
            }
            onPrimaryAction?.call();
          },
          child: Text(
            primaryActionText!,
            style: context.textStyles.bodyMedium?.copyWith(
              fontSize: TextSizes.m,
              fontWeight: FontWeight.w600,
              color: _getPrimaryActionTextColor(context),
            ),
          ),
        ),
      );
    }

    // Two actions - side by side
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (secondaryActionText != null)
          AdaptiveButtonWidget(
            height: 48,
            borderRadius: 24,
            padding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 16),
            enableHaptics: false,
            onPressed: () {
              HapticService.light();
              onSecondaryAction?.call();
            },
            child: Text(
              secondaryActionText!,
              style: context.textStyles.bodyMedium?.copyWith(
                fontSize: TextSizes.m,
                color: context.colors.onSurface.withAlpha(ColorOpacities.opacity60),
              ),
            ),
          ),
        if (hasSecondary && primaryActionText != null) const SizedBox(width: SpacingSizes.s),
        if (primaryActionText != null)
          AdaptiveButtonWidget(
            height: 48,
            borderRadius: 24,
            padding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 16),
            enableHaptics: false,
            primaryColor: _getPrimaryActionColor(context),
            onPressed: () {
              if (isDangerous) {
                HapticService.heavy();
              } else {
                HapticService.medium();
              }
              onPrimaryAction?.call();
            },
            child: Text(
              primaryActionText!,
              style: context.textStyles.bodyMedium?.copyWith(
                fontSize: TextSizes.m,
                fontWeight: FontWeight.w600,
                color: _getPrimaryActionTextColor(context),
              ),
            ),
          ),
      ],
    );
  }

  Color? _getPrimaryActionColor(BuildContext context) {
    if (primaryActionColor != null) return primaryActionColor;
    if (isDangerous) return context.colors.error.withAlpha(ColorOpacities.opacity10);
    return context.colors.primary.withAlpha(ColorOpacities.opacity10);
  }

  Color _getPrimaryActionTextColor(BuildContext context) {
    if (isDangerous) return context.colors.error;
    return context.colors.primary;
  }
}

/// Utility class to show common dialog types with consistent styling
class DialogHelper {
  /// Show a confirmation dialog (typically for destructive actions)
  static Future<bool> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AdaptiveDialogWidget(
        title: title,
        content: message,
        primaryActionText: confirmText,
        secondaryActionText: cancelText,
        isDangerous: isDangerous,
        onPrimaryAction: () => Navigator.of(context).pop(true),
        onSecondaryAction: () => Navigator.of(context).pop(false),
      ),
    );
    return result ?? false;
  }

  /// Show a deletion confirmation dialog
  static Future<bool> showDeleteConfirmation({
    required BuildContext context,
    required String itemName,
    String? customMessage,
  }) async {
    return showConfirmation(
      context: context,
      title: 'Confirm Deletion',
      message: customMessage ?? 'Are you sure you want to delete "$itemName"?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      isDangerous: true,
    );
  }

  /// Show an undo confirmation dialog
  static Future<bool> showUndoConfirmation({
    required BuildContext context,
    required String action,
    String? customMessage,
  }) async {
    return showConfirmation(
      context: context,
      title: 'Undo $action',
      message: customMessage ?? 'Are you sure you want to undo this $action?',
      confirmText: 'Undo',
      cancelText: 'Cancel',
      isDangerous: false,
    );
  }

  /// Show an info dialog with a single OK action
  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    required String message,
    String okText = 'OK',
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AdaptiveDialogWidget(
        title: title,
        content: message,
        primaryActionText: okText,
        onPrimaryAction: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// Show an error dialog
  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String message,
    String okText = 'OK',
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AdaptiveDialogWidget(
        title: title,
        content: message,
        primaryActionText: okText,
        isDangerous: true,
        onPrimaryAction: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// Show a custom dialog with widget content
  static Future<T?> showCustom<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    String? primaryActionText,
    String? secondaryActionText,
    VoidCallback? onPrimaryAction,
    VoidCallback? onSecondaryAction,
    bool isDangerous = false,
    bool barrierDismissible = true,
  }) async {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AdaptiveDialogWidget(
        title: title,
        contentWidget: content,
        primaryActionText: primaryActionText,
        secondaryActionText: secondaryActionText,
        isDangerous: isDangerous,
        onPrimaryAction: onPrimaryAction,
        onSecondaryAction: onSecondaryAction,
      ),
    );
  }
}
