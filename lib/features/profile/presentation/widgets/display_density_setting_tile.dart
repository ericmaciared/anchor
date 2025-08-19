import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/widgets/adaptive_button_widget.dart';
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
    final options = [
      _DensityOption(
        value: 'Compact',
        label: 'Compact',
        icon: Icons.view_headline,
      ),
      _DensityOption(
        value: 'Spacious',
        label: 'Spacious',
        icon: Icons.view_comfortable,
      ),
    ];

    return ListTile(
      leading: Icon(Icons.density_medium, color: Theme.of(context).colorScheme.primary),
      title: const Text('Display Density', style: TextStyle(fontSize: 14)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Row(
          children: options.map((option) {
            final isSelected = option.value == currentDensity;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: option.value == options.first.value ? 8.0 : 0.0,
                  left: option.value == options.last.value ? 8.0 : 0.0,
                ),
                child: AdaptiveButtonWidget(
                  height: 64,
                  borderRadius: 16,
                  enableHaptics: false,
                  // We'll handle haptics manually
                  primaryColor: isSelected ? Theme.of(context).colorScheme.primary.withAlpha(30) : null,
                  border: isSelected
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        )
                      : null,
                  onPressed: () {
                    HapticService.selection();
                    ref.read(settingsProvider.notifier).updateDisplayDensity(option.value);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        option.icon,
                        size: 20,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface.withAlpha(150),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        option.label,
                        style: TextStyle(
                          fontSize: TextSizes.S,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
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

class _DensityOption {
  final String value;
  final String label;
  final IconData icon;

  const _DensityOption({
    required this.value,
    required this.label,
    required this.icon,
  });
}
