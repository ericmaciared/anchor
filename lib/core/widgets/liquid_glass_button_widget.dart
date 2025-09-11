import 'package:anchor/core/theme/color_opacities.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/animated_fade_in_widget.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class LiquidGlassButtonWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? glassColor;
  final double blur;
  final bool enabled;
  final BorderRadius? customBorderRadius;
  final LiquidRoundedSuperellipse? customShape;

  const LiquidGlassButtonWidget({
    super.key,
    required this.child,
    this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = 24,
    this.glassColor,
    this.blur = 5,
    this.enabled = true,
    this.customBorderRadius,
    this.customShape,
  });

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

    final effectiveBorderRadius = customBorderRadius ?? BorderRadius.circular(borderRadius);

    return LiquidGlass(
      shape: shape,
      glassContainsChild: false,
      settings: LiquidGlassSettings(
        blur: blur,
        glassColor: effectiveGlassColor,
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: effectiveBorderRadius,
            onTap: enabled ? onPressed : null,
            child: Container(
              padding: padding,
              child: Center(
                child: AnimatedOpacity(
                  opacity: enabled ? 1.0 : 0.6,
                  duration: const Duration(milliseconds: 200),
                  child: AnimatedFadeInWidget(child: child),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Creates an enhanced glass effect for light mode
  /// Uses a combination of white and subtle theme color for better visibility
  Color _getLightModeGlassColor(BuildContext context) {
    // Get the primary color for a subtle tint
    final primaryColor = context.colors.primary;

    // Create a base white color with higher opacity for better visibility
    final baseWhite = Colors.white.withAlpha(ColorOpacities.opacity60);

    // Create a more noticeable tinted version by blending with primary color
    final tintedColor = Color.lerp(baseWhite, primaryColor.withAlpha(ColorOpacities.opacity20), 0.25);

    return tintedColor ?? baseWhite;
  }
}
