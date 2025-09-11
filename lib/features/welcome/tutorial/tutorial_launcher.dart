import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/color_opacities.dart';
import 'package:anchor/core/theme/spacing_sizes.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_dialog_widget.dart';
import 'package:anchor/features/welcome/tutorial/welcome_tutorial_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialLauncher {
  static const String _hasSeenTutorialKey = 'has_seen_tutorial';
  static const String _tutorialVersionKey = 'tutorial_version';
  static const int _currentTutorialVersion = 1;

  // Flag to prevent multiple tutorial dialogs from showing simultaneously
  static bool _isTutorialShowing = false;

  /// Check if user has seen the tutorial for the current version
  static Future<bool> hasSeenTutorial() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasSeenTutorial = prefs.getBool(_hasSeenTutorialKey) ?? false;
      final tutorialVersion = prefs.getInt(_tutorialVersionKey) ?? 0;

      // Show tutorial if user hasn't seen it OR if tutorial version has updated
      return hasSeenTutorial && tutorialVersion >= _currentTutorialVersion;
    } catch (e) {
      // If there's an error reading preferences, show tutorial to be safe
      debugPrint('Error checking tutorial status: $e');
      return false;
    }
  }

  /// Mark tutorial as seen for the current version
  static Future<void> markTutorialAsSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hasSeenTutorialKey, true);
      await prefs.setInt(_tutorialVersionKey, _currentTutorialVersion);
      debugPrint('Tutorial marked as seen for version $_currentTutorialVersion');
    } catch (e) {
      // Handle error silently - not critical for app functionality
      debugPrint('Failed to mark tutorial as seen: $e');
    }
  }

  /// Show tutorial modal
  static Future<void> showTutorial({
    required BuildContext context,
    bool isFromProfile = false,
    VoidCallback? onComplete,
  }) async {
    // Prevent multiple tutorials from showing
    if (_isTutorialShowing) {
      debugPrint('Tutorial already showing, skipping...');
      return;
    }

    _isTutorialShowing = true;

    try {
      return await showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: false,
        builder: (context) => WelcomeTutorialModal(
          isFromProfile: isFromProfile,
          onComplete: () async {
            if (!isFromProfile) {
              await markTutorialAsSeen();
            }
            onComplete?.call();
          },
        ),
      );
    } finally {
      _isTutorialShowing = false;
    }
  }

  /// Check and show tutorial for first-time users
  static Future<void> checkAndShowTutorialIfNeeded({
    required BuildContext context,
    VoidCallback? onComplete,
  }) async {
    // Don't show if already showing or if context is not mounted
    if (_isTutorialShowing || !context.mounted) {
      return;
    }

    try {
      final hasSeenTutorialBefore = await hasSeenTutorial();

      if (!hasSeenTutorialBefore) {
        debugPrint('First time user detected, showing tutorial...');

        // Add a small delay to ensure the main screen is loaded
        await Future.delayed(const Duration(milliseconds: 500));

        if (context.mounted && !_isTutorialShowing) {
          await showTutorial(
            context: context,
            isFromProfile: false,
            onComplete: onComplete,
          );
        }
      } else {
        debugPrint('User has already seen tutorial');
      }
    } catch (e) {
      debugPrint('Error in checkAndShowTutorialIfNeeded: $e');
      // On error, don't show tutorial to avoid disrupting user experience
    }
  }

  /// Reset tutorial state (useful for testing or debugging)
  static Future<void> resetTutorialState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_hasSeenTutorialKey);
      await prefs.remove(_tutorialVersionKey);
      _isTutorialShowing = false;
      debugPrint('Tutorial state reset successfully');
    } catch (e) {
      debugPrint('Failed to reset tutorial state: $e');
    }
  }

  /// Force show tutorial (useful for profile screen access)
  static Future<void> showTutorialFromProfile({
    required BuildContext context,
    VoidCallback? onComplete,
  }) async {
    await showTutorial(
      context: context,
      isFromProfile: true,
      onComplete: onComplete,
    );
  }
}

/// Provider to check tutorial status
final tutorialStatusProvider = FutureProvider<bool>((ref) async {
  return await TutorialLauncher.hasSeenTutorial();
});

/// Provider to track if tutorial should be shown
final shouldShowTutorialProvider = Provider<bool>((ref) {
  final tutorialStatus = ref.watch(tutorialStatusProvider);
  return tutorialStatus.when(
    data: (hasSeenTutorial) => !hasSeenTutorial,
    loading: () => false,
    error: (_, __) => true, // Show tutorial on error to be safe
  );
});

/// Tutorial Section Widget for Profile Screen
class TutorialSection extends StatelessWidget {
  const TutorialSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Help & Tutorial',
            style: context.textStyles.titleMedium?.copyWith(
              fontSize: TextSizes.l,
              fontWeight: FontWeight.w600,
              color: context.colors.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: Icon(Icons.school_outlined, color: context.colors.primary),
          title: Text('View Tutorial', style: context.textStyles.bodyMedium!.copyWith(fontSize: TextSizes.m)),
          subtitle: Text(
            'Review how to use Anchor\'s features',
            style: context.textStyles.bodyMedium!.copyWith(fontSize: TextSizes.s),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: context.colors.onSurfaceVariant,
          ),
          onTap: () {
            HapticService.light();
            TutorialLauncher.showTutorialFromProfile(context: context);
          },
        ),
        const Divider(indent: 16, endIndent: 16),
        ListTile(
          leading: Icon(Icons.help_outline, color: context.colors.primary),
          title: Text('Getting Started Tips', style: context.textStyles.bodyMedium!.copyWith(fontSize: TextSizes.m)),
          subtitle: Text(
            'Quick tips for using the app effectively',
            style: context.textStyles.bodyMedium!.copyWith(fontSize: TextSizes.s),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: context.colors.onSurfaceVariant,
          ),
          onTap: () {
            HapticService.light();
            _showQuickTipsDialog(context);
          },
        ),
      ],
    );
  }

  void _showQuickTipsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AdaptiveDialogWidget(
        title: 'Quick Tips',
        contentWidget: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTipItem(
                  context, 'Creating Tasks', 'Tap the + button to add new tasks with times, durations, and colors.'),
              const SizedBox(height: SpacingSizes.m),
              _buildTipItem(context, 'Managing Tasks',
                  'Tap to expand tasks, long-press to edit, or hold the completion button to finish.'),
              const SizedBox(height: SpacingSizes.m),
              _buildTipItem(context, 'Building Habits', 'Create recurring habits and track your daily progress.'),
              const SizedBox(height: SpacingSizes.m),
              _buildTipItem(context, 'Calendar Navigation', 'Swipe the week calendar to navigate between days.'),
              const SizedBox(height: SpacingSizes.m),
              _buildTipItem(context, 'Customization', 'Visit the profile screen to personalize themes and settings.'),
            ],
          ),
        ),
        primaryActionText: 'Got it!',
        onPrimaryAction: () => Navigator.of(dialogContext).pop(),
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textStyles.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: TextSizes.m,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: context.textStyles.bodySmall?.copyWith(
            fontSize: TextSizes.s,
            color: context.colors.onSurface.withAlpha(ColorOpacities.opacity70),
          ),
        ),
      ],
    );
  }
}
