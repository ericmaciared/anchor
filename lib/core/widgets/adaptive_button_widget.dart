import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/widgets/animated_fade_in_widget.dart';
import 'package:anchor/core/widgets/regular_button_widget.dart';
import 'package:anchor/features/shared/settings/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import 'liquid_glass_button_widget.dart';

class AdaptiveButtonWidget extends ConsumerWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? primaryColor;
  final Color? secondaryColor;
  final double effectIntensity;
  final bool enabled;
  final BorderRadius? customBorderRadius;
  final LiquidRoundedSuperellipse? customShape;
  final Border? border;
  final bool enableHaptics;

  const AdaptiveButtonWidget({
    super.key,
    required this.child,
    this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = 24,
    this.primaryColor,
    this.secondaryColor,
    this.effectIntensity = 5,
    this.enabled = true,
    this.customBorderRadius,
    this.customShape,
    this.border,
    this.enableHaptics = true,
  });

  void _handlePress() {
    if (onPressed != null && enabled) {
      if (enableHaptics) {
        HapticService.medium(); // Standard button press feedback
      }
      onPressed!();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsyncValue = ref.watch(settingsProvider);

    // Default to liquid glass if settings are loading or failed to load
    bool useLiquidGlass = true;

    settingsAsyncValue.whenData((settings) {
      useLiquidGlass = settings.liquidGlassEnabled;
    });

    if (useLiquidGlass) {
      return LiquidGlassButtonWidget(
        onPressed: _handlePress,
        width: width,
        height: height,
        padding: padding,
        borderRadius: borderRadius,
        glassColor: primaryColor,
        blur: effectIntensity,
        enabled: enabled,
        customBorderRadius: customBorderRadius,
        customShape: customShape,
        child: child,
      );
    } else {
      return AnimatedFadeInWidget(
        child: RegularButtonWidget(
          onPressed: _handlePress,
          width: width,
          height: height,
          padding: padding,
          borderRadius: borderRadius,
          backgroundColor: primaryColor,
          shadowColor: secondaryColor,
          shadowBlur: effectIntensity * 2.4,
          enabled: enabled,
          customBorderRadius: customBorderRadius,
          border: border,
          child: child,
        ),
      );
    }
  }
}
