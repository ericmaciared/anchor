import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/scroll_fade_overlay_widget.dart';
import 'package:anchor/features/profile/presentation/widgets/daily_quotes_setting.dart';
import 'package:anchor/features/profile/presentation/widgets/display_density_setting_tile.dart';
import 'package:anchor/features/profile/presentation/widgets/profile_name_section.dart';
import 'package:anchor/features/profile/presentation/widgets/status_message_setting_tile.dart';
import 'package:anchor/features/profile/presentation/widgets/time_setting_tile.dart';
import 'package:anchor/features/profile/presentation/widgets/visual_effects_setting_tile.dart';
import 'package:anchor/features/shared/settings/settings_provider.dart';
import 'package:anchor/features/welcome/policy_markdown_sheet_widget.dart';
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
      error: (err, stack) => Center(child: Text('Error loading settings: $err')),
      data: (settings) {
        final profileName = settings.profileName;
        final wakeUpTime = settings.wakeUpTime;
        final bedTime = settings.bedTime;
        final displayDensity = settings.displayDensity;
        final dailyQuotesEnabled = settings.dailyQuotesEnabled;
        final visualEffectsEnabled = settings.visualEffectsEnabled;
        final statusMessageEnabled = settings.statusMessageEnabled;

        return ScrollFadeOverlayPresets.appBar(
          fadeHeight: 120,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              const SizedBox(height: 120),
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
                    updateFunction: (newTime) => ref.read(settingsProvider.notifier).updateWakeUpTime(newTime),
                  ),
                  const Divider(indent: 16, endIndent: 16),
                  TimeSettingTile(
                    icon: Icons.nights_stay_outlined,
                    title: 'Bedtime',
                    currentTime: bedTime,
                    updateFunction: (newTime) => ref.read(settingsProvider.notifier).updateBedTime(newTime),
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
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Terms section
                    TextButton(
                      onPressed: () => _showTermsOfService(context),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                      child: Text(
                        'terms of service',
                        style: context.textStyles.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () => _showPrivacyPolicy(context),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                      child: Text(
                        'privacy policy',
                        style: context.textStyles.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'App Version 1.0.0',
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          appBar: _buildAppBar(context, profileName),
        );
      },
    );
  }

  Future<void> _showTermsOfService(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const TermsOfServiceModalWidget(
        assetPath: 'assets/policies/terms_of_service.md',
      ),
    );
  }

  Future<void> _showPrivacyPolicy(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const PrivacyPolicyModalWidget(
        assetPath: 'assets/policies/privacy_policy.md',
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, String profileName) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('profile & settings', style: TextStyle(fontSize: TextSizes.XL)),
          ],
        ),
      ),
    );
  }
}
