// lib/features/shared/main/floating_navbar.dart

import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

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
      child: LiquidGlass(
        glassContainsChild: false,
        settings: LiquidGlassSettings(
          ambientStrength: 0.5,
          blur: 3,
        ),
        shape: LiquidRoundedSuperellipse(borderRadius: Radius.circular(56)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
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
    final duration = const Duration(milliseconds: 200);
    final colorScheme = Theme.of(context).colorScheme;
    final activeColor = colorScheme.onSurface;
    final inactiveColor = colorScheme.onSurface.withAlpha(150);
    final activeBackgroundColor = colorScheme.surfaceContainerHighest.withAlpha(100);

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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: isActive ? activeBackgroundColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AnimatedSwitcher(
                duration: duration,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: Icon(
                  icon,
                  key: ValueKey<bool>(isActive),
                  color: isActive ? activeColor : inactiveColor,
                  size: 24,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
