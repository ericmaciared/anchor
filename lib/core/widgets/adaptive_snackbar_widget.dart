// lib/core/widgets/adaptive_snackbar_widget.dart
import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/color_opacities.dart';
import 'package:anchor/core/theme/spacing_sizes.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_button_widget.dart';
import 'package:anchor/core/widgets/adaptive_card_widget.dart';
import 'package:flutter/material.dart';

enum SnackbarType {
  success,
  error,
  warning,
  info,
  custom,
}

class AdaptiveSnackbar extends StatelessWidget {
  final String message;
  final SnackbarType type;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;
  final Duration? duration;
  final bool showCloseButton;
  final EdgeInsetsGeometry? margin;
  final Widget? leading;
  final Widget? trailing;

  const AdaptiveSnackbar({
    super.key,
    required this.message,
    this.type = SnackbarType.info,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
    this.duration,
    this.showCloseButton = false,
    this.margin,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final typeConfig = _getTypeConfiguration(context);

    return AdaptiveCardWidget(
      primaryColor: backgroundColor ?? typeConfig.backgroundColor,
      borderRadius: 16,
      effectIntensity: 8,
      padding: const EdgeInsets.all(SpacingSizes.m),
      child: Row(
        children: [
          // Leading icon or custom widget
          if (leading != null)
            leading!
          else if (icon != null || typeConfig.icon != null)
            Container(
              padding: const EdgeInsets.all(SpacingSizes.s),
              decoration: BoxDecoration(
                color: (iconColor ?? typeConfig.iconColor).withAlpha(ColorOpacities.opacity10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon ?? typeConfig.icon,
                size: 20,
                color: iconColor ?? typeConfig.iconColor,
              ),
            ),

          if (leading != null || icon != null || typeConfig.icon != null) const SizedBox(width: SpacingSizes.s),

          // Message
          Expanded(
            child: Text(
              message,
              style: context.textStyles.bodyMedium?.copyWith(
                fontSize: TextSizes.m,
                fontWeight: FontWeight.w500,
                color: textColor ?? typeConfig.textColor,
                height: 1.3,
              ),
            ),
          ),

          // Action button
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(width: SpacingSizes.s),
            AdaptiveButtonWidget(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              borderRadius: 12,
              primaryColor: typeConfig.actionColor.withAlpha(ColorOpacities.opacity10),
              enableHaptics: false,
              onPressed: () {
                HapticService.medium();
                onAction!();
              },
              child: Text(
                actionLabel!,
                style: context.textStyles.bodyMedium?.copyWith(
                  fontSize: TextSizes.s,
                  fontWeight: FontWeight.w600,
                  color: typeConfig.actionColor,
                ),
              ),
            ),
          ],

          // Close button
          if (showCloseButton) ...[
            const SizedBox(width: SpacingSizes.s),
            AdaptiveButtonWidget(
              width: 32,
              height: 32,
              borderRadius: 16,
              primaryColor: typeConfig.iconColor.withAlpha(ColorOpacities.opacity10),
              enableHaptics: false,
              onPressed: () {
                HapticService.light();
                onDismiss?.call();
              },
              child: Icon(
                Icons.close,
                size: 16,
                color: typeConfig.iconColor.withAlpha(ColorOpacities.opacity60),
              ),
            ),
          ],

          // Trailing widget
          if (trailing != null) ...[
            const SizedBox(width: SpacingSizes.s),
            trailing!,
          ],
        ],
      ),
    );
  }

  _SnackbarTypeConfig _getTypeConfiguration(BuildContext context) {
    switch (type) {
      case SnackbarType.success:
        return _SnackbarTypeConfig(
          icon: Icons.check_circle_outline,
          iconColor: Colors.green,
          backgroundColor: Colors.green.withAlpha(ColorOpacities.opacity30),
          textColor: context.colors.onSurface,
          actionColor: Colors.green,
        );
      case SnackbarType.error:
        return _SnackbarTypeConfig(
          icon: Icons.error_outline,
          iconColor: context.colors.error,
          backgroundColor: context.colors.error.withAlpha(ColorOpacities.opacity10),
          textColor: context.colors.onSurface,
          actionColor: context.colors.error,
        );
      case SnackbarType.warning:
        return _SnackbarTypeConfig(
          icon: Icons.warning_amber_outlined,
          iconColor: Colors.orange,
          backgroundColor: Colors.orange.withAlpha(ColorOpacities.opacity10),
          textColor: context.colors.onSurface,
          actionColor: Colors.orange,
        );
      case SnackbarType.info:
        return _SnackbarTypeConfig(
          icon: Icons.info_outline,
          iconColor: context.colors.primary,
          backgroundColor: context.colors.primary.withAlpha(ColorOpacities.opacity10),
          textColor: context.colors.onSurface,
          actionColor: context.colors.primary,
        );
      case SnackbarType.custom:
        return _SnackbarTypeConfig(
          icon: null,
          iconColor: context.colors.onSurface,
          backgroundColor: context.colors.surfaceContainerHighest,
          textColor: context.colors.onSurface,
          actionColor: context.colors.primary,
        );
    }
  }
}

class _SnackbarTypeConfig {
  final IconData? icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color textColor;
  final Color actionColor;

  const _SnackbarTypeConfig({
    this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.textColor,
    required this.actionColor,
  });
}

/// Utility class for showing snackbars with consistent styling
class SnackbarHelper {
  // Default spacing for floating nav bar
  static const double _defaultBottomSpacing = 84.0;

  static void show({
    required BuildContext context,
    required String message,
    SnackbarType type = SnackbarType.info,
    IconData? icon,
    Color? backgroundColor,
    Color? textColor,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
    bool showCloseButton = false,
    EdgeInsetsGeometry? margin,
    Widget? leading,
    Widget? trailing,
    double? bottomSpacing, // Custom bottom spacing
  }) {
    // Remove any existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    // Calculate margin to position above floating nav bar
    final effectiveBottomSpacing = bottomSpacing ?? _defaultBottomSpacing;
    final defaultMargin = margin ??
        EdgeInsets.fromLTRB(
          SpacingSizes.m, // left
          SpacingSizes.m, // top
          SpacingSizes.m, // right
          effectiveBottomSpacing, // bottom - space for floating nav bar
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AdaptiveSnackbar(
          message: message,
          type: type,
          icon: icon,
          backgroundColor: backgroundColor,
          textColor: textColor,
          actionLabel: actionLabel,
          onAction: onAction,
          onDismiss: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          showCloseButton: showCloseButton,
          leading: leading,
          trailing: trailing,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        padding: EdgeInsets.zero,
        margin: defaultMargin,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show a success snackbar
  static void showSuccess({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: SnackbarType.success,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  /// Show an error snackbar
  static void showError({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 5),
  }) {
    show(
      context: context,
      message: message,
      type: SnackbarType.error,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      showCloseButton: true,
    );
  }

  /// Show a warning snackbar
  static void showWarning({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      message: message,
      type: SnackbarType.warning,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  /// Show an info snackbar
  static void showInfo({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: SnackbarType.info,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  /// Show an undo snackbar (typically after deletions)
  static void showUndo({
    required BuildContext context,
    required String message,
    required VoidCallback onUndo,
    Duration duration = const Duration(seconds: 5),
  }) {
    show(
      context: context,
      message: message,
      type: SnackbarType.info,
      actionLabel: 'Undo',
      onAction: () {
        // Dismiss the snackbar first, then execute undo
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        onUndo();
      },
      duration: duration,
      showCloseButton: true,
    );
  }

  /// Show a loading snackbar with custom widget
  static void showLoading({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 10),
  }) {
    show(
      context: context,
      message: message,
      type: SnackbarType.custom,
      leading: Container(
        padding: const EdgeInsets.all(SpacingSizes.s),
        child: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
      duration: duration,
      showCloseButton: true,
    );
  }

  /// Show a custom snackbar with progress indicator
  static void showProgress({
    required BuildContext context,
    required String message,
    required double progress, // 0.0 to 1.0
    Duration duration = const Duration(seconds: 8),
    double? bottomSpacing,
  }) {
    show(
      context: context,
      message: message,
      type: SnackbarType.custom,
      bottomSpacing: bottomSpacing,
      trailing: SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: progress,
              strokeWidth: 3,
              backgroundColor: context.colors.outline.withAlpha(ColorOpacities.opacity20),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: context.textStyles.bodyMedium?.copyWith(
                fontSize: TextSizes.xs,
                fontWeight: FontWeight.w600,
                color: context.colors.primary,
              ),
            ),
          ],
        ),
      ),
      duration: duration,
      showCloseButton: true,
    );
  }

  /// Show a snackbar with an avatar (for user actions)
  static void showWithAvatar({
    required BuildContext context,
    required String message,
    required Widget avatar,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      message: message,
      type: SnackbarType.custom,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 32,
          height: 32,
          child: avatar,
        ),
      ),
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }
}

/// Extension to make snackbar usage even easier
extension SnackbarExtension on BuildContext {
  void showSnackbar({
    required String message,
    SnackbarType type = SnackbarType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    SnackbarHelper.show(
      context: this,
      message: message,
      type: type,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  void showSuccessSnackbar(String message, {String? actionLabel, VoidCallback? onAction}) {
    SnackbarHelper.showSuccess(
      context: this,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  void showErrorSnackbar(String message, {String? actionLabel, VoidCallback? onAction}) {
    SnackbarHelper.showError(
      context: this,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  void showWarningSnackbar(String message, {String? actionLabel, VoidCallback? onAction}) {
    SnackbarHelper.showWarning(
      context: this,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  void showInfoSnackbar(String message, {String? actionLabel, VoidCallback? onAction}) {
    SnackbarHelper.showInfo(
      context: this,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  void showUndoSnackbar(String message, VoidCallback onUndo) {
    SnackbarHelper.showUndo(
      context: this,
      message: message,
      onUndo: onUndo,
    );
  }

  void showLoadingSnackbar(String message) {
    SnackbarHelper.showLoading(
      context: this,
      message: message,
    );
  }

  /// Show snackbar with custom bottom spacing (useful for different nav bar heights)
  void showSnackbarWithSpacing({
    required String message,
    required double bottomSpacing,
    SnackbarType type = SnackbarType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    SnackbarHelper.show(
      context: this,
      message: message,
      type: type,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      bottomSpacing: bottomSpacing,
    );
  }

  /// Show snackbar positioned higher (for screens with bottom sheets or keyboards)
  void showHighSnackbar({
    required String message,
    SnackbarType type = SnackbarType.info,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    SnackbarHelper.show(
      context: this,
      message: message,
      type: type,
      actionLabel: actionLabel,
      onAction: onAction,
      bottomSpacing: 200, // Higher positioning
    );
  }

  /// Show snackbar at standard position (no floating nav bar)
  void showStandardSnackbar({
    required String message,
    SnackbarType type = SnackbarType.info,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    SnackbarHelper.show(
      context: this,
      message: message,
      type: type,
      actionLabel: actionLabel,
      onAction: onAction,
      bottomSpacing: SpacingSizes.m, // Standard bottom margin
    );
  }
}
