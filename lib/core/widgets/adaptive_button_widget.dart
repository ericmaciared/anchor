import 'package:anchor/core/widgets/regular_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import 'liquid_glass_button_widget.dart';

class AdaptiveButtonWidget extends StatelessWidget {
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
  });

  bool get _useLiquidGlass => true;

  @override
  Widget build(BuildContext context) {
    if (_useLiquidGlass) {
      return LiquidGlassButtonWidget(
        onPressed: onPressed,
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
      return RegularButtonWidget(
        onPressed: onPressed,
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
      );
    }
  }
}
