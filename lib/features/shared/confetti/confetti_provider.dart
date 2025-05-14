import 'package:confetti/confetti.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final confettiProvider = Provider<ConfettiController>((ref) {
  final controller =
      ConfettiController(duration: const Duration(milliseconds: 300));
  ref.onDispose(() => controller.dispose());
  return controller;
});
