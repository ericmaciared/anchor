import 'package:flutter/material.dart';

mixin SafeAnimationMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  final List<AnimationController> _controllers = [];
  bool _isDisposed = false;

  /// Create and register an animation controller
  AnimationController createController({
    required Duration duration,
    Duration? reverseDuration,
    String? debugLabel,
    double lowerBound = 0.0,
    double upperBound = 1.0,
    AnimationBehavior animationBehavior = AnimationBehavior.normal,
  }) {
    if (_isDisposed) {
      throw StateError('Cannot create controller after widget is disposed');
    }

    final controller = AnimationController(
      duration: duration,
      reverseDuration: reverseDuration,
      debugLabel: debugLabel,
      lowerBound: lowerBound,
      upperBound: upperBound,
      vsync: this,
      animationBehavior: animationBehavior,
    );

    _controllers.add(controller);
    return controller;
  }

  /// Safely execute animation with disposal check
  Future<void> safeAnimate(
    AnimationController controller,
    Future<void> Function() animation,
  ) async {
    if (_isDisposed || !mounted) return;

    try {
      await animation();
    } catch (e) {
      debugPrint('Animation error: $e');
    }
  }

  /// Safe setState that checks if widget is still mounted
  void safSetState(VoidCallback fn) {
    if (!_isDisposed && mounted) {
      setState(fn);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
    super.dispose();
  }
}
