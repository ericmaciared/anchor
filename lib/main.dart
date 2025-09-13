import 'package:anchor/core/router/app_router.dart';
import 'package:anchor/core/theme/app_theme.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/shared/confetti/confetti_provider.dart';
import 'features/shared/notifications/notification_service.dart';
import 'features/shared/settings/settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  final notificationService = container.read(notificationServiceProvider);
  await notificationService.init();

  runApp(const ProviderScope(child: AnchorApp()));
}

class AnchorApp extends ConsumerWidget {
  const AnchorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final confettiController = ref.watch(confettiProvider);
    final settingsAsyncValue = ref.watch(settingsProvider);

    final themeMode = settingsAsyncValue.when(
      data: (settings) {
        switch (settings.themeMode) {
          case 'Light':
            return ThemeMode.light;
          case 'Dark':
            return ThemeMode.dark;
          case 'System':
          default:
            return ThemeMode.system;
        }
      },
      loading: () => ThemeMode.system,
      error: (_, __) => ThemeMode.system,
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Anchor',
      routerConfig: router,
      themeMode: themeMode,
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
