import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart' as rive;

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Stack(children: [
              rive.RiveAnimation.asset(
                'assets/animations/welcome.riv',
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 250, sigmaY: 250),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ]),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (isDarkMode)
                    Image.asset(
                      'assets/icon/app_logo_white.png',
                      width: 100,
                      height: 100,
                    ),
                  if (!isDarkMode)
                    Image.asset(
                      'assets/icon/app_logo_black.png',
                      width: 100,
                      height: 100,
                    ),
                  Text(
                    'anchor.',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black.withAlpha(50),
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      context.go('/tasks');
                    },
                    child: Text(
                      'Start',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
