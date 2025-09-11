import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/color_opacities.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_button_widget.dart';
import 'package:anchor/features/shared/settings/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeSettingTile extends ConsumerWidget {
  final String currentThemeMode;

  const ThemeModeSettingTile({
    super.key,
    required this.currentThemeMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = [
      _ThemeModeOption(
        value: 'Light',
        label: 'Light',
        icon: Icons.light_mode,
      ),
      _ThemeModeOption(
        value: 'Dark',
        label: 'Dark',
        icon: Icons.dark_mode,
      ),
      _ThemeModeOption(
        value: 'System',
        label: 'System',
        icon: Icons.brightness_4,
      ),
    ];

    return ListTile(
      leading: Icon(Icons.palette, color: context.colors.primary),
      title: const Text('Theme Mode', style: TextStyle(fontSize: TextSizes.m)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Row(
          children: options.map((option) {
            final isSelected = option.value == currentThemeMode;

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
                  primaryColor: isSelected ? context.colors.primary.withAlpha(ColorOpacities.opacity10) : null,
                  border: isSelected
                      ? Border.all(
                          color: context.colors.primary,
                          width: 1.5,
                        )
                      : null,
                  onPressed: () {
                    HapticService.selection();
                    ref.read(settingsProvider.notifier).updateThemeMode(option.value);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        option.icon,
                        size: 20,
                        color: isSelected
                            ? context.colors.primary
                            : context.colors.onSurface.withAlpha(ColorOpacities.opacity60),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        option.label,
                        style: TextStyle(
                          fontSize: TextSizes.s,
                          color: isSelected ? context.colors.primary : context.colors.onSurface,
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

class _ThemeModeOption {
  final String value;
  final String label;
  final IconData icon;

  const _ThemeModeOption({
    required this.value,
    required this.label,
    required this.icon,
  });
}
