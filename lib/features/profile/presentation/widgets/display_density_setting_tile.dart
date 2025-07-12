import 'package:anchor/features/shared/settings/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayDensitySettingTile extends ConsumerWidget {
  final String currentDensity;

  const DisplayDensitySettingTile({
    super.key,
    required this.currentDensity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(Icons.density_medium,
          color: Theme.of(context).colorScheme.primaryContainer),
      title: const Text('Display Density', style: TextStyle(fontSize: 14)),
      trailing: DropdownButton<String>(
        value: currentDensity,
        onChanged: (String? newValue) {
          if (newValue != null) {
            ref.read(settingsProvider.notifier).updateDisplayDensity(newValue);
          }
        },
        items: <String>['Compact', 'Spacious']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
      ),
    );
  }
}
