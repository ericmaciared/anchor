import 'package:flutter/material.dart';

class ExpandableSection extends StatelessWidget {
  final bool isExpanded;
  final Widget child;
  final Duration animationDuration;
  final Curve animationCurve;

  const ExpandableSection({
    super.key,
    required this.isExpanded,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: animationDuration,
      curve: animationCurve,
      child: isExpanded
          ? Padding(
              padding: const EdgeInsets.only(top: 16),
              child: child,
            )
          : const SizedBox.shrink(),
    );
  }
}
