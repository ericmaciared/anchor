import 'package:anchor/features/profile/presentation/widgets/daily_quotes_setting.dart';
import 'package:anchor/features/profile/presentation/widgets/display_density_setting_tile.dart';
import 'package:anchor/features/profile/presentation/widgets/profile_name_section.dart';
import 'package:anchor/features/profile/presentation/widgets/status_message_setting_tile.dart';
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

    return settingsAsyncValue.when(
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
        final statusMessageEnabled = settings.statusMessageEnabled;

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
                      title: 'Wake-up Time',
                      currentTime: wakeUpTime,
                      updateFunction: (newTime) => ref
                          .read(settingsProvider.notifier)
                          .updateWakeUpTime(newTime),
                    ),
                    const Divider(indent: 16, endIndent: 16),
                    TimeSettingTile(
                      icon: Icons.nights_stay_outlined,
                      title: 'Bedtime',
                      currentTime: bedTime,
                      updateFunction: (newTime) => ref
                          .read(settingsProvider.notifier)
                          .updateBedTime(newTime),
                    ),
                    const Divider(indent: 16, endIndent: 16),
                    DisplayDensitySettingTile(
                      currentDensity: displayDensity,
                    ),
                    const Divider(indent: 16, endIndent: 16),
                    DailyQuotesSettingTile(
                      isEnabled: dailyQuotesEnabled,
                    ),
                    const Divider(indent: 16, endIndent: 16),
                    VisualEffectsSettingTile(
                      isEnabled: visualEffectsEnabled,
                    ),
                    const Divider(indent: 16, endIndent: 16),
                    StatusMessageSettingTile(
                      isEnabled: statusMessageEnabled,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
