import 'package:anchor/features/profile/presentation/widgets/daily_quotes_setting.dart';
import 'package:anchor/features/profile/presentation/widgets/display_density_setting_tile.dart';
import 'package:anchor/features/profile/presentation/widgets/profile_name_section.dart';
import 'package:anchor/features/profile/presentation/widgets/time_setting_tile.dart';
import 'package:anchor/features/profile/presentation/widgets/visual_effects_setting_tile.dart';
import 'package:anchor/features/shared/settings/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsyncValue = ref.watch(settingsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: settingsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Error loading settings: $err')),
        data: (settings) {
          final profileName = settings.profileName;
          final wakeUpTime = settings.wakeUpTime;
          final bedTime = settings.bedTime;
          final displayDensity = settings.displayDensity;
          final dailyQuotesEnabled = settings.dailyQuotesEnabled;
          final visualEffectsEnabled = settings.visualEffectsEnabled;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ProfileNameSection(
                    profileName: profileName,
                    onSurfaceColor: colorScheme.onSurface,
                  ),
                  const SizedBox(height: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TimeSettingTile(
                        icon: Icons.wb_sunny_outlined,
                        iconColor: colorScheme.secondary,
                        title: 'Wake-up Time',
                        currentTime: wakeUpTime,
                        updateFunction: (newTime) => ref
                            .read(settingsProvider.notifier)
                            .updateWakeUpTime(newTime),
                      ),
                      const Divider(indent: 16, endIndent: 16),
                      TimeSettingTile(
                        icon: Icons.nights_stay_outlined,
                        iconColor: colorScheme.tertiary,
                        title: 'Bedtime',
                        currentTime: bedTime,
                        updateFunction: (newTime) => ref
                            .read(settingsProvider.notifier)
                            .updateBedTime(newTime),
                      ),
                      const Divider(indent: 16, endIndent: 16),
                      DisplayDensitySettingTile(
                        currentDensity: displayDensity,
                        iconColor: colorScheme.secondaryContainer,
                      ),
                      const Divider(indent: 16, endIndent: 16),
                      DailyQuotesSettingTile(
                        isEnabled: dailyQuotesEnabled,
                        activeColor: colorScheme.primary,
                        iconColor: colorScheme.tertiaryContainer,
                      ),
                      const Divider(indent: 16, endIndent: 16),
                      VisualEffectsSettingTile(
                        isEnabled: visualEffectsEnabled,
                        activeColor: colorScheme
                            .primary, // Using primary for consistency
                        iconColor: colorScheme
                            .primaryContainer, // Using another color from colorScheme
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
