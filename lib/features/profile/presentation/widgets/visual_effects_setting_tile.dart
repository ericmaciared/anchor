import 'package:anchor/features/shared/settings/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VisualEffectsSettingTile extends ConsumerWidget {
  final bool isEnabled;
  final Color activeColor;
  final Color iconColor;

  const VisualEffectsSettingTile({
    super.key,
    required this.isEnabled,
    required this.activeColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      activeColor: activeColor,
      secondary: Icon(Icons.star_half, color: iconColor),
      title:
          const Text('Enable Visual Effects', style: TextStyle(fontSize: 12)),
      value: isEnabled,
      onChanged: (bool value) {
        ref.read(settingsProvider.notifier).updateVisualEffectsEnabled(value);
      },
    );
  }
}
