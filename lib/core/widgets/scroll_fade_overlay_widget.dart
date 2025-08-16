import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ScrollFadeOverlayWidget extends StatefulWidget {
  /// The scrollable content widget
  final Widget child;

  /// The widget that should be overlaid on top (e.g., app bar)
  final Widget overlay;

  /// The height of the fade gradient overlay
  final double fadeHeight;

  /// The scroll offset at which fade starts appearing
  final double fadeStartOffset;

  /// The scroll offset at which fade reaches maximum opacity
  final double fadeEndOffset;

  /// The base color for the fade gradient (usually surface or background color)
  final Color? fadeColor;

  /// Custom gradient stops for the fade effect
  final List<double>? gradientStops;

  /// Custom alpha values for the gradient colors (0-255)
  final List<int>? gradientAlphas;

  /// Duration of the fade animation
  final Duration animationDuration;

  /// Whether the fade should be at the top (true) or bottom (false)
  final bool fadeFromTop;

  const ScrollFadeOverlayWidget({
    super.key,
    required this.child,
    required this.overlay,
    this.fadeHeight = 120,
    this.fadeStartOffset = 20.0,
    this.fadeEndOffset = 60.0,
    this.fadeColor,
    this.gradientStops,
    this.gradientAlphas,
    this.animationDuration = const Duration(milliseconds: 150),
    this.fadeFromTop = true,
  }) : assert(fadeEndOffset > fadeStartOffset, 'fadeEndOffset must be greater than fadeStartOffset');

  @override
  State<ScrollFadeOverlayWidget> createState() => _ScrollFadeOverlayWidgetState();
}

class _ScrollFadeOverlayWidgetState extends State<ScrollFadeOverlayWidget> {
  double _scrollOffset = 0.0;
  bool _isBuilding = false;

  double get _fadeOpacity {
    if (_scrollOffset <= widget.fadeStartOffset) return 0.0;
    if (_scrollOffset >= widget.fadeEndOffset) return 1.0;

    return (_scrollOffset - widget.fadeStartOffset) / (widget.fadeEndOffset - widget.fadeStartOffset);
  }

  void _updateScrollOffset(double newOffset) {
    if (_scrollOffset != newOffset) {
      if (_isBuilding) {
        // Schedule the update for after the current build phase
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _scrollOffset = newOffset;
            });
          }
        });
      } else {
        setState(() {
          _scrollOffset = newOffset;
        });
      }
    }
  }

  bool _isVerticalScroll(ScrollNotification notification) {
    final scrollDirection = notification.metrics.axis;
    return scrollDirection == Axis.vertical;
  }

  @override
  Widget build(BuildContext context) {
    _isBuilding = true;

    // Schedule to reset the building flag after this build completes
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _isBuilding = false;
    });

    return Stack(
      children: [
        // Scrollable content with listener
        NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollUpdateNotification && _isVerticalScroll(notification)) {
              _updateScrollOffset(notification.metrics.pixels);
            }
            return false;
          },
          child: widget.child,
        ),

        // Fade overlay
        _buildFadeOverlay(context),

        // Top overlay content
        widget.overlay,
      ],
    );
  }

  Widget _buildFadeOverlay(BuildContext context) {
    final effectiveFadeColor = widget.fadeColor ?? Theme.of(context).colorScheme.surface;

    final gradientStops = widget.gradientStops ?? [0.0, 0.3, 0.7, 1.0];
    final gradientAlphas = widget.gradientAlphas ?? [242, 204, 102, 0];

    final colors = gradientAlphas.map((alpha) => effectiveFadeColor.withAlpha(alpha)).toList();

    return Positioned(
      top: widget.fadeFromTop ? 0 : null,
      bottom: widget.fadeFromTop ? null : 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: AnimatedOpacity(
          duration: widget.animationDuration,
          opacity: _fadeOpacity,
          child: Container(
            height: widget.fadeHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: widget.fadeFromTop ? Alignment.topCenter : Alignment.bottomCenter,
                end: widget.fadeFromTop ? Alignment.bottomCenter : Alignment.topCenter,
                colors: widget.fadeFromTop ? colors : colors.reversed.toList(),
                stops: widget.fadeFromTop ? gradientStops : gradientStops.reversed.toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Extension to provide common presets for ScrollFadeOverlayWidget
extension ScrollFadeOverlayPresets on ScrollFadeOverlayWidget {
  /// Creates a scroll fade overlay optimized for app bars
  static ScrollFadeOverlayWidget appBar({
    Key? key,
    required Widget child,
    required Widget appBar,
    Color? fadeColor,
    double fadeHeight = 184,
  }) {
    return ScrollFadeOverlayWidget(
      key: key,
      overlay: Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: SafeArea(child: appBar),
      ),
      fadeHeight: fadeHeight,
      fadeStartOffset: 12.0,
      fadeEndOffset: 64.0,
      fadeColor: fadeColor,
      child: child,
    );
  }

  /// Creates a scroll fade overlay for bottom navigation or input areas
  static ScrollFadeOverlayWidget bottomBar({
    Key? key,
    required Widget child,
    required Widget bottomBar,
    Color? fadeColor,
    double fadeHeight = 80,
  }) {
    return ScrollFadeOverlayWidget(
      key: key,
      overlay: Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: SafeArea(child: bottomBar),
      ),
      fadeHeight: fadeHeight,
      fadeStartOffset: 15.0,
      fadeEndOffset: 45.0,
      fadeColor: fadeColor,
      fadeFromTop: false,
      child: child,
    );
  }

  /// Creates a minimal scroll fade overlay with subtle effect
  static ScrollFadeOverlayWidget subtle({
    Key? key,
    required Widget child,
    required Widget overlay,
    Color? fadeColor,
  }) {
    return ScrollFadeOverlayWidget(
      key: key,
      overlay: overlay,
      fadeHeight: 60,
      fadeStartOffset: 10.0,
      fadeEndOffset: 30.0,
      fadeColor: fadeColor,
      gradientAlphas: [180, 120, 60, 0],
      child: child, // More subtle fade
    );
  }
}
