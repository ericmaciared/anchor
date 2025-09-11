import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
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
      activeThumbColor: context.colors.primary,
      secondary: Icon(Icons.star_half, color: context.colors.primary),
      title: Text('Enable Visual Effects', style: context.textStyles.bodyMedium?.copyWith(fontSize: TextSizes.m)),
      value: isEnabled,
      onChanged: (bool value) {
        ref.read(settingsProvider.notifier).updateVisualEffectsEnabled(value);
      },
    );
  }
}
