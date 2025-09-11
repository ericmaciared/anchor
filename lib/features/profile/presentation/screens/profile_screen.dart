import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/scroll_fade_overlay_widget.dart';
import 'package:anchor/features/profile/presentation/widgets/daily_quotes_setting_tile.dart';
import 'package:anchor/features/profile/presentation/widgets/display_density_setting_tile.dart';
import 'package:anchor/features/profile/presentation/widgets/liquid_glass_setting_tile.dart';
import 'package:anchor/features/profile/presentation/widgets/profile_name_section.dart';
import 'package:anchor/features/profile/presentation/widgets/status_message_setting_tile.dart';
import 'package:anchor/features/profile/presentation/widgets/time_setting_tile.dart';
import 'package:anchor/features/profile/presentation/widgets/visual_effects_setting_tile.dart';
import 'package:anchor/features/shared/settings/settings_provider.dart';
import 'package:anchor/features/welcome/policy_markdown_sheet_widget.dart';
import 'package:anchor/features/welcome/tutorial/tutorial_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsyncValue = ref.watch(settingsProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
        final liquidGlassEnabled = settings.liquidGlassEnabled;
        final statusMessageEnabled = settings.statusMessageEnabled;

        return ScrollFadeOverlayPresets.appBar(
          fadeHeight: 120,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              const SizedBox(height: 120),
              ProfileNameSection(
                profileName: profileName,
                onSurfaceColor: context.colors.onSurface,
              ),
              const SizedBox(height: 32),

              // Tutorial Section - Add this
              const TutorialSection(),
              const SizedBox(height: 32),

              // Settings Section
              _buildSectionHeader(context, 'Settings'),
              const SizedBox(height: 16),
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
                  LiquidGlassSettingTile(
                    isEnabled: liquidGlassEnabled,
                  ),
                  const Divider(indent: 16, endIndent: 16),
                  StatusMessageSettingTile(
                    isEnabled: statusMessageEnabled,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Feedback Section
              _buildSectionHeader(context, 'Feedback & Support'),
              const SizedBox(height: 16),
              _buildFeedbackSection(context),

              const SizedBox(height: 32),

              // Legal Section
              _buildSectionHeader(context, 'Legal'),
              const SizedBox(height: 16),
              _buildLegalSection(context),

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Anchor App Version 1.0.0',
                  textAlign: TextAlign.center,
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (isDarkMode) Image.asset('assets/icon/app_logo_white.png', width: 80, height: 80),
              if (!isDarkMode) Image.asset('assets/icon/app_logo_black.png', width: 80, height: 80),
              const SizedBox(height: 96),
            ],
          ),
          appBar: _buildAppBar(context, profileName),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: context.textStyles.titleMedium?.copyWith(
          fontSize: TextSizes.l,
          fontWeight: FontWeight.w600,
          color: context.colors.primary,
        ),
      ),
    );
  }

  Widget _buildFeedbackSection(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.feedback_outlined, color: context.colors.primary),
          title: const Text('Send Feedback', style: TextStyle(fontSize: TextSizes.m)),
          subtitle: const Text('Help us improve Anchor with your suggestions', style: TextStyle(fontSize: TextSizes.s)),
          trailing: Icon(Icons.open_in_new, size: 16, color: context.colors.onSurfaceVariant),
          onTap: () => _launchFeedbackBoard(context),
        ),
        const Divider(indent: 16, endIndent: 16),
        ListTile(
          leading: Icon(Icons.bug_report_outlined, color: context.colors.primary),
          title: const Text('Report a Bug', style: TextStyle(fontSize: TextSizes.m)),
          subtitle: const Text('Found an issue? Let us know so we can fix it', style: TextStyle(fontSize: TextSizes.s)),
          trailing: Icon(Icons.open_in_new, size: 16, color: context.colors.onSurfaceVariant),
          onTap: () => _launchFeedbackBoard(context),
        ),
      ],
    );
  }

  Widget _buildLegalSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () => _showTermsOfService(context),
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
          child: Text(
            'Terms of Service',
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
        Container(
          width: 1,
          height: 16,
          color: context.colors.onSurfaceVariant.withAlpha(100),
        ),
        TextButton(
          onPressed: () => _showPrivacyPolicy(context),
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
          child: Text(
            'Privacy Policy',
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchFeedbackBoard(BuildContext context) async {
    const url = 'https://anchorapp.canny.io/';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (context.mounted) {
          _showUrlErrorDialog(context, url);
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showUrlErrorDialog(context, url);
      }
    }
  }

  void _showUrlErrorDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unable to Open Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('We couldn\'t open the feedback board automatically.'),
            const SizedBox(height: 12),
            const Text('Please visit:'),
            const SizedBox(height: 8),
            SelectableText(
              url,
              style: TextStyle(
                color: context.colors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _showTermsOfService(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.colors.surface,
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
      backgroundColor: context.colors.surface,
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
            Text('profile & settings', style: TextStyle(fontSize: TextSizes.xl)),
          ],
        ),
      ),
    );
  }
}
