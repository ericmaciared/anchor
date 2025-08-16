import 'package:flutter/widgets.dart';

class AnimatedFadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;

  /// Creates an AnimatedFadeIn widget.
  ///
  /// [child] is the widget to display.
  /// [duration] is the animation duration, defaulting to 500 milliseconds.
  const AnimatedFadeInWidget({
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    super.key,
  });

  @override
  State<AnimatedFadeInWidget> createState() => _AnimatedFadeIn();
}

class _AnimatedFadeIn extends State<AnimatedFadeInWidget> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    duration: widget.duration,
    vsync: this,
  );
  late final Animation<double> animation = CurvedAnimation(
    parent: controller,
    curve: Curves.easeOut,
  );

  @override
  void initState() {
    super.initState();
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: animation, child: widget.child);
  }
}
