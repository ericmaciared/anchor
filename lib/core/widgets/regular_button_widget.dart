import 'package:anchor/core/utils/context_extensions.dart';
import 'package:flutter/material.dart';

class RegularButtonWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? shadowColor;
  final double shadowBlur;
  final Offset shadowOffset;
  final bool enabled;
  final BorderRadius? customBorderRadius;
  final Border? border;

  const RegularButtonWidget({
    super.key,
    required this.child,
    this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = 24,
    this.backgroundColor,
    this.shadowColor,
    this.shadowBlur = 12,
    this.shadowOffset = const Offset(0, -1),
    this.enabled = true,
    this.customBorderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? context.colors.surfaceContainerHighest;

    final effectiveShadowColor = shadowColor ?? Colors.black.withAlpha(0);

    final effectiveBorderRadius = customBorderRadius ?? BorderRadius.circular(borderRadius);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        border: border,
        boxShadow: [
          BoxShadow(
            color: effectiveShadowColor,
            blurRadius: shadowBlur,
            offset: shadowOffset,
          ),
        ],
      ),
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
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
