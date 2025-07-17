import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/features/shared/settings/settings_provider.dart'; // Adjust path as needed
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailyQuotesSettingTile extends ConsumerWidget {
  final bool isEnabled;

  const DailyQuotesSettingTile({
    super.key,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      activeColor: Theme.of(context).colorScheme.primary,
      secondary: Icon(Icons.format_quote,
          color: Theme.of(context).colorScheme.primaryContainer),
      title: const Text('Show Daily Quotes',
          style: TextStyle(fontSize: TextSizes.M)),
      value: isEnabled,
      onChanged: (bool value) {
        ref.read(settingsProvider.notifier).updateDailyQuotesEnabled(value);
      },
    );
  }
}
