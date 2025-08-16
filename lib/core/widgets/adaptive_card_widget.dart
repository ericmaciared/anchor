import 'package:anchor/core/widgets/animated_fade_in_widget.dart';
import 'package:anchor/core/widgets/regular_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import 'liquid_glass_card_widget.dart';

class AdaptiveCardWidget extends StatelessWidget {
  const AdaptiveCardWidget({
    super.key,
    required this.child,
    this.borderRadius = 8.0,
    this.primaryColor,
    this.shadowColor,
    this.effectIntensity = 5.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.customShape,
    this.useBackdropFilter = true,
  });

  final Widget child;
  final Color? primaryColor;
  final Color? shadowColor;
  final double borderRadius;
  final double effectIntensity;
  final EdgeInsetsGeometry padding;
  final LiquidRoundedSuperellipse? customShape;
  final bool useBackdropFilter;

  bool get _useLiquidGlass => true;

  @override
  Widget build(BuildContext context) {
    if (_useLiquidGlass) {
      return LiquidGlassCardWidget(
        borderRadius: borderRadius,
        blur: effectIntensity,
        glassColor: primaryColor,
        padding: padding,
        customShape: customShape,
        child: child,
      );
    } else {
      return AnimatedFadeInWidget(
        child: RegularCardWidget(
          borderRadius: borderRadius,
          elevation: effectIntensity / 2.5,
          color: primaryColor,
          padding: padding,
          shadowColor: shadowColor,
          useBackdropFilter: useBackdropFilter,
          backdropBlur: effectIntensity * 2,
          child: child,
        ),
      );
    }
  }
}
