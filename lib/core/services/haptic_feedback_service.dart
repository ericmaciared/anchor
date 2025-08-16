import 'package:flutter/services.dart';

/// Centralized haptic feedback service for the app
class HapticService {
  static const HapticService _instance = HapticService._internal();

  factory HapticService() => _instance;

  const HapticService._internal();

  /// Light haptic feedback for subtle interactions
  /// Use for: hover effects, minor selections, input field focus
  static Future<void> light() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium haptic feedback for standard interactions
  /// Use for: button taps, toggle switches, card selections
  static Future<void> medium() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy haptic feedback for important interactions
  /// Use for: confirmations, deletions, task completions
  static Future<void> heavy() async {
    await HapticFeedback.heavyImpact();
  }

  /// Selection feedback for picker interactions
  /// Use for: dropdown selections, picker wheels, segmented controls
  static Future<void> selection() async {
    await HapticFeedback.selectionClick();
  }

  /// Vibrate pattern for errors or warnings
  /// Use for: form validation errors, failed operations
  static Future<void> error() async {
    await HapticFeedback.vibrate();
  }

  /// Success pattern (double light tap)
  /// Use for: successful task completion, save operations
  static Future<void> success() async {
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.lightImpact();
  }

  /// Long press feedback
  /// Use for: context menu triggers, drag start
  static Future<void> longPress() async {
    await HapticFeedback.mediumImpact();
  }

  /// Navigation feedback
  /// Use for: tab switches, page transitions
  static Future<void> navigation() async {
    await HapticFeedback.lightImpact();
  }
}
