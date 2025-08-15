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
    final theme = Theme.of(context);

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
                color: theme.colorScheme.outlineVariant,
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
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
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
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
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
                    styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                      a: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                      h1: theme.textTheme.headlineSmall,
                      h2: theme.textTheme.titleLarge,
                      h3: theme.textTheme.titleMedium,
                      blockquoteDecoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
                        border: Border(
                          left: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 4,
                          ),
                        ),
                      ),
                      blockquotePadding: const EdgeInsets.all(12),
                      code: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        backgroundColor: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
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
