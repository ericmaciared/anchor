import 'dart:ui';

import 'package:anchor/core/utils/context_extensions.dart';
import 'package:flutter/material.dart';

class RegularCardWidget extends StatelessWidget {
  const RegularCardWidget({
    super.key,
    required this.child,
    this.borderRadius = 8.0,
    this.elevation = 2.0,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.shadowColor,
    this.useBackdropFilter = true,
    this.backdropBlur = 10.0,
  });

  final Widget child;
  final Color? color;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final Color? shadowColor;
  final bool useBackdropFilter;
  final double backdropBlur;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.colors.surfaceContainerHighest;

    final cardWidget = Card(
      margin: EdgeInsets.zero,
      elevation: elevation,
      clipBehavior: Clip.antiAlias,
      color: effectiveColor,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    if (useBackdropFilter) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: backdropBlur, sigmaY: backdropBlur),
          child: cardWidget,
        ),
      );
    }

    return cardWidget;
  }
}
