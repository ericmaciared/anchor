import 'package:anchor/features/shared/quotes/presentation/providers/quotes_provider.dart';
import 'package:anchor/features/shared/settings/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailyQuoteCard extends ConsumerWidget {
  const DailyQuoteCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsyncValue = ref.watch(settingsProvider);

    return settingsAsyncValue.when(
      loading: () => const SizedBox(
          height: 48,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
      error: (err, stack) => const SizedBox.shrink(),
      data: (settings) {
        if (!settings.dailyQuotesEnabled) {
          return SizedBox(
            width: double.infinity,
            child: Icon(
              Icons.anchor,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
              size: 24,
            ),
          );
        }

        final dailyQuoteGetter = ref.watch(dailyQuoteProvider);

        return dailyQuoteGetter.when(
          loading: () => const SizedBox(
              height: 48,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
          error: (err, stack) => const SizedBox.shrink(),
          data: (quote) => Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 6.0),
            // Added horizontal padding from EmptyTaskState
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.format_quote,
                    size: 20,
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(100)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quote.text,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              fontSize: 13,
                              height: 1.3,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Today\'s quote by ${quote.author.isEmpty ? 'someone' : quote.author}.',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha(100),
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
