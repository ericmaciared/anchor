// lib/features/shared/main/floating_navbar.dart

import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/color_opacities.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_card_widget.dart';
import 'package:flutter/material.dart';

class FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: AdaptiveCardWidget(
        effectIntensity: 2,
        borderRadius: 32,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            _IconNavItem(
              icon: Icons.check_circle_outline,
              isActive: currentIndex == 0,
              onTap: () {
                HapticService.navigation(); // Navigation feedback
                onTap(0);
              },
            ),
            _IconNavItem(
              icon: Icons.anchor,
              isActive: currentIndex == 1,
              onTap: () {
                HapticService.navigation(); // Navigation feedback
                onTap(1);
              },
            ),
            _IconNavItem(
              icon: Icons.account_circle_outlined,
              isActive: currentIndex == 2,
              onTap: () {
                HapticService.navigation(); // Navigation feedback
                onTap(2);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _IconNavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _IconNavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 200);
    final activeColor = context.colors.onSurface;
    final inactiveColor = context.colors.onSurface.withAlpha(ColorOpacities.opacity60);
    final activeBackgroundColor = context.colors.surfaceContainerHigh.withAlpha(ColorOpacities.opacity80);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1.0, end: isActive ? 1.2 : 1.0),
        duration: duration,
        curve: Curves.ease,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: AnimatedContainer(
              duration: duration,
              curve: Curves.ease,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: isActive ? activeBackgroundColor : activeBackgroundColor.withAlpha(0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: isActive ? activeColor : inactiveColor,
                size: 24,
              ),
            ),
          );
        },
      ),
    );
  }
}
