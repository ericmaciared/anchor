import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/regular_button_widget.dart';
import 'package:anchor/features/shared/gradients/dynamic_gradient.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: DynamicGradient(
        duration: const Duration(seconds: 5),
        child: Stack(
          children: [
            Positioned.fill(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (isDarkMode)
                        Image.asset(
                          'assets/icon/app_logo_white.png',
                          width: 80,
                          height: 80,
                        ),
                      if (!isDarkMode)
                        Image.asset(
                          'assets/icon/app_logo_black.png',
                          width: 80,
                          height: 80,
                        ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Become better, daily.',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              shadows: [
                                Shadow(
                                  blurRadius: 4.0,
                                  color: Colors.black.withAlpha(50),
                                  offset: const Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'anchor.',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              shadows: [
                                Shadow(
                                  blurRadius: 4.0,
                                  color: Colors.black.withAlpha(50),
                                  offset: const Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Terms section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'by continuing, you agree to our',
                                style: context.textStyles.bodyMedium?.copyWith(
                                  color: context.colors.onSurface,
                                ),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                    ),
                                    child: Text(
                                      'terms of service',
                                      style: context.textStyles.bodySmall?.copyWith(
                                        color: context.colors.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                    ),
                                    child: Text(
                                      'privacy policy',
                                      style: context.textStyles.bodySmall?.copyWith(
                                        color: context.colors.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Login button
                          RegularButtonWidget(
                            onPressed: () {
                              context.go('/tasks');
                            },
                            height: 56,
                            width: 56,
                            borderRadius: 28,
                            child: Icon(Icons.arrow_forward),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
