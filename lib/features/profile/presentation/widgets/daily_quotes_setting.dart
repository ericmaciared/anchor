import 'package:anchor/features/shared/settings/settings_provider.dart'; // Adjust path as needed
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailyQuotesSettingTile extends ConsumerWidget {
  final bool isEnabled;
  final Color activeColor;
  final Color iconColor;

  const DailyQuotesSettingTile({
    super.key,
    required this.isEnabled,
    required this.activeColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      activeColor: activeColor,
      secondary: Icon(Icons.format_quote, color: iconColor),
      title: const Text('Show Daily Quotes', style: TextStyle(fontSize: 12)),
      value: isEnabled,
      onChanged: (bool value) {
        ref.read(settingsProvider.notifier).updateDailyQuotesEnabled(value);
      },
    );
  }
}
