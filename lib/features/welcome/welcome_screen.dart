import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
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
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.go('/tasks');
                },
                child: Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
