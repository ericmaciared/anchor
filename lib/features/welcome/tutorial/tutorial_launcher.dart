import 'package:anchor/core/theme/color_opacities.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/features/welcome/tutorial/welcome_tutorial_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialLauncher {
  static const String _hasSeenTutorialKey = 'has_seen_tutorial';
  static const String _tutorialVersionKey = 'tutorial_version';
  static const int _currentTutorialVersion = 1;

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
      return false;
    }
  }

  /// Mark tutorial as seen for the current version
  static Future<void> markTutorialAsSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hasSeenTutorialKey, true);
      await prefs.setInt(_tutorialVersionKey, _currentTutorialVersion);
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
    return showDialog(
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
  }

  /// Check and show tutorial for first-time users
  static Future<void> checkAndShowTutorialIfNeeded({
    required BuildContext context,
    VoidCallback? onComplete,
  }) async {
    final hasSeenTutorialBefore = await hasSeenTutorial();
    if (!hasSeenTutorialBefore) {
      // Add a small delay to ensure the main screen is loaded
      await Future.delayed(const Duration(milliseconds: 500));

      if (context.mounted) {
        await showTutorial(
          context: context,
          isFromProfile: false,
          onComplete: onComplete,
        );
      }
    }
  }

  /// Reset tutorial state (useful for testing or debugging)
  static Future<void> resetTutorialState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_hasSeenTutorialKey);
      await prefs.remove(_tutorialVersionKey);
    } catch (e) {
      debugPrint('Failed to reset tutorial state: $e');
    }
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
          title: const Text('View Tutorial', style: TextStyle(fontSize: TextSizes.m)),
          subtitle: const Text(
            'Review how to use Anchor\'s features',
            style: TextStyle(fontSize: TextSizes.s),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: context.colors.onSurfaceVariant,
          ),
          onTap: () {
            TutorialLauncher.showTutorial(
              context: context,
              isFromProfile: true,
            );
          },
        ),
        const Divider(indent: 16, endIndent: 16),
        ListTile(
          leading: Icon(Icons.help_outline, color: context.colors.primary),
          title: const Text('Getting Started Tips', style: TextStyle(fontSize: TextSizes.m)),
          subtitle: const Text(
            'Quick tips for using the app effectively',
            style: TextStyle(fontSize: TextSizes.s),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: context.colors.onSurfaceVariant,
          ),
          onTap: () {
            _showQuickTipsDialog(context);
          },
        ),
      ],
    );
  }

  void _showQuickTipsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.tips_and_updates, color: context.colors.primary),
            const SizedBox(width: 8),
            const Text('Quick Tips'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTipItem(
                  context, 'Creating Tasks', 'Tap the + button to add new tasks with times, durations, and colors.'),
              const SizedBox(height: 16),
              _buildTipItem(context, 'Managing Tasks',
                  'Tap to expand tasks, long-press to edit, or hold the completion button to finish.'),
              const SizedBox(height: 16),
              _buildTipItem(
                  context, 'Building Habits', 'Create daily habits and track your streaks. Consistency is key!'),
              const SizedBox(height: 16),
              _buildTipItem(context, 'Navigation', 'Swipe the calendar to move between days and plan ahead.'),
              const SizedBox(height: 16),
              _buildTipItem(context, 'Personalization',
                  'Visit the profile section to customize visual effects and display options.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textStyles.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: context.textStyles.bodyMedium?.copyWith(
            fontSize: TextSizes.s,
            color: context.colors.onSurface.withAlpha(ColorOpacities.opacity70),
          ),
        ),
      ],
    );
  }
}
