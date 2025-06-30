import 'package:anchor/features/shared/settings/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayDensitySettingTile extends ConsumerWidget {
  final String currentDensity;
  final Color iconColor;

  const DisplayDensitySettingTile({
    super.key,
    required this.currentDensity,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(Icons.density_medium, color: iconColor),
      title: const Text('Display Density', style: TextStyle(fontSize: 12)),
      trailing: DropdownButton<String>(
        value: currentDensity,
        onChanged: (String? newValue) {
          if (newValue != null) {
            ref.read(settingsProvider.notifier).updateDisplayDensity(newValue);
          }
        },
        items: <String>['Compact', 'Normal', 'Spacious']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(fontSize: 12)),
          );
        }).toList(),
      ),
    );
  }
}
