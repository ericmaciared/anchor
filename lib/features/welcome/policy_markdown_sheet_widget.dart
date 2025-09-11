import 'package:anchor/core/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

class TermsOfServiceModalWidget extends StatelessWidget {
  const TermsOfServiceModalWidget({super.key, required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return PolicyMarkdownSheetWidget(
      title: 'Terms of Service',
      assetPath: assetPath,
    );
  }
}

class PrivacyPolicyModalWidget extends StatelessWidget {
  const PrivacyPolicyModalWidget({super.key, required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return PolicyMarkdownSheetWidget(
      title: 'Privacy Policy',
      assetPath: assetPath,
    );
  }
}

/// Reusable sheet with draggable height + Markdown rendering
class PolicyMarkdownSheetWidget extends StatelessWidget {
  const PolicyMarkdownSheetWidget({
    super.key,
    required this.title,
    required this.assetPath,
  });

  final String title;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Grab handle + title row
            const SizedBox(height: 16),
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: context.colors.outlineVariant,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: context.textStyles.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ],
              ),
            ),

            // Markdown content
            Expanded(
              child: FutureBuilder<String>(
                future: rootBundle.loadString(assetPath),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Failed to load policy.\n${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: context.textStyles.bodyMedium?.copyWith(
                            color: context.colors.error,
                          ),
                        ),
                      ),
                    );
                  }

                  final data = snapshot.data ?? '';
                  return Markdown(
                    controller: scrollController,
                    selectable: true,
                    data: data,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                      a: context.textStyles.bodyMedium?.copyWith(
                        color: context.colors.primary,
                        decoration: TextDecoration.underline,
                      ),
                      h1: context.textStyles.headlineSmall,
                      h2: context.textStyles.titleLarge,
                      h3: context.textStyles.titleMedium,
                      blockquoteDecoration: BoxDecoration(
                        color: context.colors.surfaceContainerHighest.withAlpha(80),
                        border: Border(
                          left: BorderSide(
                            color: context.colors.primary,
                            width: 4,
                          ),
                        ),
                      ),
                      blockquotePadding: const EdgeInsets.all(12),
                      code: context.textStyles.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        backgroundColor: context.colors.surfaceContainerHighest.withAlpha(60),
                      ),
                    ),
                    onTapLink: (text, href, title) {
                      // TODO: open external links if desired
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        );
      },
    );
  }
}
