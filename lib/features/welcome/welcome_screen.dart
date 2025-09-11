import 'package:anchor/core/theme/spacing_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_button_widget.dart';
import 'package:anchor/features/shared/gradients/dynamic_gradient.dart';
import 'package:anchor/features/welcome/policy_markdown_sheet_widget.dart';
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
                      if (isDarkMode) Image.asset('assets/icon/app_logo_white.png', width: 80, height: 80),
                      if (!isDarkMode) Image.asset('assets/icon/app_logo_black.png', width: 80, height: 80),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Become better, daily.', style: context.textStyles.headlineSmall),
                          Text('anchor.', style: context.textStyles.displayMedium),
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
                                    onPressed: () => _showTermsOfService(context),
                                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                                    child: Text(
                                      'terms of service',
                                      style: context.textStyles.bodySmall?.copyWith(
                                        color: context.colors.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: SpacingSizes.m),
                                  TextButton(
                                    onPressed: () => _showPrivacyPolicy(context),
                                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
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

                          // Login button - Updated to show tutorial after navigation
                          AdaptiveButtonWidget(
                            onPressed: () => context.go('/tasks'),
                            height: 56,
                            width: 56,
                            borderRadius: 28,
                            child: const Icon(Icons.arrow_forward),
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

  Future<void> _showTermsOfService(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const TermsOfServiceModalWidget(
        assetPath: 'assets/policies/terms_of_service.md',
      ),
    );
  }

  Future<void> _showPrivacyPolicy(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const PrivacyPolicyModalWidget(
        assetPath: 'assets/policies/privacy_policy.md',
      ),
    );
  }
}
