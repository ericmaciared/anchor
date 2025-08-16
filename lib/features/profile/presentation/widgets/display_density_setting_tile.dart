import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/text_sizes.dart';
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
    final options = ['Compact', 'Spacious'];

    return ListTile(
      leading: Icon(Icons.density_medium, color: Theme.of(context).colorScheme.primary),
      title: const Text('Display Density', style: TextStyle(fontSize: 14)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: options.map((option) {
            final isSelected = option == currentDensity;

            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: GestureDetector(
                onTap: () {
                  HapticService.selection();
                  ref.read(settingsProvider.notifier).updateDisplayDensity(option);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary.withAlpha(20)
                        : Theme.of(context).colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected ? Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5) : null,
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: TextSizes.S,
                      color:
                          isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
