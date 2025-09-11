import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/features/shared/settings/settings_provider.dart'; // Adjust path as needed
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LiquidGlassSettingTile extends ConsumerWidget {
  final bool isEnabled;

  const LiquidGlassSettingTile({
    super.key,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      activeThumbColor: context.colors.primary,
      secondary: Icon(Icons.opacity, color: context.colors.primary),
      title: const Text('Use Liquid Glass (beta)', style: TextStyle(fontSize: TextSizes.m)),
      value: isEnabled,
      onChanged: (bool value) {
        ref.read(settingsProvider.notifier).updateLiquidGlassEnabled(value);
      },
    );
  }
}
