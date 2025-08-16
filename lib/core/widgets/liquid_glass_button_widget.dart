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
    final effectiveGlassColor = glassColor ?? (isDarkMode ? Colors.white.withAlpha(20) : Colors.white.withAlpha(60));

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
}
