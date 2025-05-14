import 'package:anchor/core/router/app_router.dart';
import 'package:anchor/core/theme/app_theme.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/shared/confetti/confetti_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: AnchorApp()));
}

class AnchorApp extends ConsumerWidget {
  const AnchorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final confettiController = ref.watch(confettiProvider);

    return MaterialApp.router(
      title: 'Anchor',
      routerConfig: router,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.only(top: 64.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    numberOfParticles: 40,
                    gravity: 0.5,
                    emissionFrequency: 0.05,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
