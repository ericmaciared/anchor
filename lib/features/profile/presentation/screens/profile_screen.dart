import 'package:anchor/features/profile/presentation/widgets/daily_quotes_setting.dart';
import 'package:anchor/features/profile/presentation/widgets/display_density_setting_tile.dart';
import 'package:anchor/features/profile/presentation/widgets/profile_avatar_section.dart';
import 'package:anchor/features/profile/presentation/widgets/profile_name_section.dart';
import 'package:anchor/features/profile/presentation/widgets/time_setting_tile.dart';
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
      appBar: AppBar(title: const Text('profile')),
      body: settingsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Error loading settings: $err')),
        data: (settings) {
          // Destructure settings for easier access
          final profileName = settings.profileName;
          final wakeUpTime = settings.wakeUpTime;
          final bedTime = settings.bedTime;
          final displayDensity = settings.displayDensity;
          final dailyQuotesEnabled = settings.dailyQuotesEnabled;
          final int storedProfileColor = settings.profileColor;

          // Use the stored color directly
          final Color profileBackgroundColor = Color(storedProfileColor);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileAvatarSection(
                  profileName: profileName,
                  profileColor: profileBackgroundColor,
                  onPrimaryColor: colorScheme.onPrimary,
                ),
                const SizedBox(height: 16),
                // Use the new ProfileNameSection widget
                ProfileNameSection(
                  profileName: profileName,
                  onSurfaceColor: colorScheme.onSurface,
                ),
                const SizedBox(height: 32),
                Column(
                  children: [
                    // Use the new TimeSettingTile for Wake-up Time
                    TimeSettingTile(
                      icon: Icons.wb_sunny_outlined,
                      iconColor: colorScheme.secondary,
                      title: 'Wake-up Time',
                      currentTime: wakeUpTime,
                      updateFunction: (newTime) => ref
                          .read(settingsProvider.notifier)
                          .updateWakeUpTime(newTime),
                    ),
                    // Use the new TimeSettingTile for Bedtime
                    TimeSettingTile(
                      icon: Icons.nights_stay_outlined,
                      iconColor: colorScheme.tertiary,
                      title: 'Bedtime',
                      currentTime: bedTime,
                      updateFunction: (newTime) => ref
                          .read(settingsProvider.notifier)
                          .updateBedTime(newTime),
                    ),
                    // Use the new DisplayDensitySettingTile
                    DisplayDensitySettingTile(
                      currentDensity: displayDensity,
                      iconColor: colorScheme.secondaryContainer,
                    ),
                    // Use the new DailyQuotesSettingTile
                    DailyQuotesSettingTile(
                      isEnabled: dailyQuotesEnabled,
                      activeColor: colorScheme.primary,
                      iconColor: colorScheme.tertiaryContainer,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
