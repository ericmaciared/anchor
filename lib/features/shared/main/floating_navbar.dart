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
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(56),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 6,
                offset: Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              _IconNavItem(
                icon: Icons.check_circle_outline,
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _IconNavItem(
                icon: Icons.anchor,
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
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
    final inactiveColor = colorScheme.onSurface.withAlpha(50);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 1.0, end: isActive ? 1.2 : 1.0),
          duration: duration,
          curve: Curves.ease,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
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
            );
          },
        ),
      ),
    );
  }
}
