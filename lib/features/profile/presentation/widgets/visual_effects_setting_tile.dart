import 'package:anchor/features/shared/settings/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VisualEffectsSettingTile extends ConsumerWidget {
  final bool isEnabled;

  const VisualEffectsSettingTile({
    super.key,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      activeThumbColor: Theme.of(context).colorScheme.primary,
      secondary: Icon(Icons.star_half, color: Theme.of(context).colorScheme.primary),
      title: const Text('Enable Visual Effects', style: TextStyle(fontSize: 14)),
      value: isEnabled,
      onChanged: (bool value) {
        ref.read(settingsProvider.notifier).updateVisualEffectsEnabled(value);
      },
    );
  }
}
