import 'package:flutter/material.dart';

class DynamicGradient extends StatefulWidget {
  final Widget? child;
  final Duration duration;
  final List<Color> accentColors;

  const DynamicGradient({
    super.key,
    this.child,
    this.duration = const Duration(seconds: 120),
    this.accentColors = const [
      Color(0xFFF0C27B),
      Color(0xFF4B1248),
      Color(0xFFE94057),
      Color(0xFFF27121),
      Color(0xFFFDC830),
      Color(0xFFA8FF78),
      Color(0xFF78FFD6),
      Color(0xFF36D1DC),
      Color(0xFF5B86E5),
      Color(0xFF4568DC),
      Color(0xFFB06AB3),
    ],
  });

  @override
  State<DynamicGradient> createState() => _DynamicGradientState();
}

class _DynamicGradientState extends State<DynamicGradient>
    with TickerProviderStateMixin {
  late AnimationController _angleController;
  late AnimationController _colorController;
  late AnimationController _centerController;
  late Animation<double> _angleAnimation;
  late Animation<double> _colorAnimation;
  late Animation<Alignment> _centerAnimation;

  int _currentColorIndex = 0;

  @override
  void initState() {
    super.initState();

    _angleController = AnimationController(
      duration: widget.duration * 2,
      vsync: this,
    );

    _angleAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(
      parent: _angleController,
      curve: Curves.linear,
    ));

    _colorController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _colorAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    ));

    _centerController = AnimationController(
      duration: widget.duration * 3,
      vsync: this,
    );

    _centerAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.center,
          end: Alignment.topRight,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.topLeft,
          end: Alignment.center,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
    ]).animate(_centerController);

    _angleController.repeat();
    _centerController.repeat();
    _startColorCycle();
  }

  void _startColorCycle() {
    _colorController.forward().then((_) {
      setState(() {
        _currentColorIndex =
            (_currentColorIndex + 1) % widget.accentColors.length;
      });
      _colorController.reset();
      _startColorCycle();
    });
  }

  @override
  void dispose() {
    _angleController.dispose();
    _colorController.dispose();
    _centerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(
          [_angleAnimation, _colorAnimation, _centerAnimation]),
      builder: (context, child) {
        final currentAccentColor = widget.accentColors[_currentColorIndex];
        final nextAccentColor = widget.accentColors[
            (_currentColorIndex + 1) % widget.accentColors.length];

        final animatedAccentColor = Color.lerp(
          currentAccentColor,
          nextAccentColor,
          _colorAnimation.value,
        )!;

        final surfaceColor = Theme.of(context).colorScheme.surface;
        final subtleAccentColor = Color.lerp(
          surfaceColor,
          animatedAccentColor,
          0.2,
        )!;

        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: _centerAnimation.value,
              radius: 1.5,
              colors: [
                subtleAccentColor,
                surfaceColor,
              ],
              stops: const [0.0, 1.0],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
