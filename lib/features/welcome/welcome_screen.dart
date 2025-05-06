import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.anchor,
                size: 120,
                color: Theme.of(context).colorScheme.primary,
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
