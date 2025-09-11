import 'package:anchor/core/theme/color_opacities.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/animated_fade_in_widget.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class LiquidGlassCardWidget extends StatelessWidget {
  const LiquidGlassCardWidget({
    super.key,
    required this.child,
    this.borderRadius = 8.0,
    this.blur = 5.0,
    this.glassColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.customShape,
  });

  final Widget child;
  final Color? glassColor;
  final double borderRadius;
  final double blur;
  final EdgeInsetsGeometry padding;
  final LiquidRoundedSuperellipse? customShape;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.theme.brightness == Brightness.dark;

    // Enhanced glass color for better visibility in light mode
    final effectiveGlassColor = glassColor ??
        (isDarkMode ? Colors.white.withAlpha(ColorOpacities.opacity10) : _getLightModeGlassColor(context));

    final shape = customShape ??
        LiquidRoundedSuperellipse(
          borderRadius: Radius.circular(borderRadius),
        );

    return LiquidGlass(
      shape: shape,
      glassContainsChild: false,
      settings: LiquidGlassSettings(
        blur: blur,
        glassColor: effectiveGlassColor,
      ),
      child: Padding(
        padding: padding,
        child: AnimatedFadeInWidget(child: child),
      ),
    );
  }

  /// Creates an enhanced glass effect for light mode
  /// Uses a combination of white and subtle theme color for better visibility
  Color _getLightModeGlassColor(BuildContext context) {
    // Get the primary color for a subtle tint
    final primaryColor = context.colors.primary;

    // Create a base color with higher opacity for better visibility
    final baseWhite = Colors.black.withAlpha(ColorOpacities.opacity10);

    // Create a more noticeable tinted version by blending with primary color
    final tintedColor = Color.lerp(baseWhite, primaryColor.withAlpha(ColorOpacities.opacity20), 0.25);

    return tintedColor ?? baseWhite;
  }
}
