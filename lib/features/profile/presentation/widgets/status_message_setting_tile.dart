import 'package:anchor/features/shared/settings/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusMessageSettingTile extends ConsumerWidget {
  final bool isEnabled;

  const StatusMessageSettingTile({super.key, required this.isEnabled});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      activeColor: Theme.of(context).colorScheme.primary,
      secondary: Icon(Icons.message_outlined,
          color: Theme.of(context).colorScheme.primaryContainer),
      title: const Text('Show Status Message', style: TextStyle(fontSize: 14)),
      value: isEnabled,
      onChanged: (bool value) {
        ref.read(settingsProvider.notifier).updateStatusMessageEnabled(value);
      },
    );
  }
}
