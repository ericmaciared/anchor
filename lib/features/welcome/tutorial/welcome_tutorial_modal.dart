import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_button_widget.dart';
import 'package:anchor/core/widgets/adaptive_card_widget.dart';
import 'package:anchor/features/shared/gradients/dynamic_gradient.dart';
import 'package:flutter/material.dart';

class WelcomeTutorialModal extends StatefulWidget {
  final VoidCallback? onComplete;
  final bool isFromProfile;

  const WelcomeTutorialModal({
    super.key,
    this.onComplete,
    this.isFromProfile = false,
  });

  @override
  State<WelcomeTutorialModal> createState() => _WelcomeTutorialModalState();
}

class _WelcomeTutorialModalState extends State<WelcomeTutorialModal> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  late AnimationController _slideController;

  int _currentPage = 0;
  static const int _totalPages = 6;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Start animations
    _slideController.forward();
    _updateProgress();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    final progress = (_currentPage + 1) / _totalPages;
    _progressController.animateTo(progress);
  }

  void _nextPage() {
    HapticService.medium();
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeTutorial();
    }
  }

  void _previousPage() {
    HapticService.light();
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipTutorial() {
    HapticService.light();
    _completeTutorial();
  }

  void _completeTutorial() {
    HapticService.success();
    Navigator.of(context).pop();
    widget.onComplete?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: DynamicGradient(
        duration: const Duration(seconds: 8),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                // Header with progress and skip
                _buildHeader(),

                // Tutorial slides
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                      _updateProgress();
                    },
                    itemCount: _totalPages,
                    itemBuilder: (context, index) {
                      return _buildSlide(index);
                    },
                  ),
                ),

                // Navigation buttons
                _buildNavigationButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          // Progress indicator
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_currentPage + 1} of $_totalPages',
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.onSurface.withAlpha(150),
                    fontSize: TextSizes.s,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_currentPage + 1) / _totalPages,
                    backgroundColor: context.colors.onSurface.withAlpha(30),
                    valueColor: AlwaysStoppedAnimation(context.colors.primary),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          AdaptiveButtonWidget(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onPressed: _skipTutorial,
            child: Text(
              'Skip',
              style: TextStyle(
                color: context.colors.onSurface.withAlpha(150),
                fontSize: TextSizes.m,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(int index) {
    switch (index) {
      case 0:
        return _WelcomeSlide();
      case 1:
        return _TasksSlide();
      case 2:
        return _HabitsSlide();
      case 3:
        return _NotificationsSlide();
      case 4:
        return _PersonalizationSlide();
      case 5:
        return _GetStartedSlide();
      default:
        return Container();
    }
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          // Previous button
          if (_currentPage > 0)
            AdaptiveButtonWidget(
              width: 56,
              height: 56,
              borderRadius: 28,
              onPressed: _previousPage,
              child: Icon(
                Icons.arrow_back_ios_new,
                color: context.colors.onSurface,
              ),
            )
          else
            const SizedBox(width: 56),

          const Spacer(),

          // Next/Finish button
          AdaptiveButtonWidget(
            width: _currentPage == _totalPages - 1 ? 140 : 56,
            height: 56,
            borderRadius: 28,
            primaryColor: context.colors.primary.withAlpha(30),
            onPressed: _nextPage,
            child: _currentPage == _totalPages - 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.isFromProfile ? 'Done' : 'Get Started',
                        style: TextStyle(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: TextSizes.m,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.check,
                        color: context.colors.primary,
                        size: 20,
                      ),
                    ],
                  )
                : Icon(
                    Icons.arrow_forward_ios,
                    color: context.colors.primary,
                  ),
          ),
        ],
      ),
    );
  }
}

// Slide 1: Welcome
class _WelcomeSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          if (isDarkMode)
            Image.asset('assets/icon/app_logo_white.png', width: 120, height: 120)
          else
            Image.asset('assets/icon/app_logo_black.png', width: 120, height: 120),

          const SizedBox(height: 40),

          // Title
          Text(
            'Welcome to Anchor',
            style: context.textStyles.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colors.primary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Subtitle
          Text(
            'Your personal productivity companion that helps you build better habits and manage tasks with style.',
            style: context.textStyles.bodyLarge?.copyWith(
              fontSize: TextSizes.l,
              height: 1.4,
              color: context.colors.onSurface.withAlpha(180),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          // Feature preview icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFeatureIcon(context, Icons.check_circle_outline, 'Tasks'),
              _buildFeatureIcon(context, Icons.anchor, 'Habits'),
              _buildFeatureIcon(context, Icons.notifications_outlined, 'Reminders'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(BuildContext context, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: context.colors.primary.withAlpha(20),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            icon,
            color: context.colors.primary,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: context.textStyles.bodySmall?.copyWith(
            fontSize: TextSizes.s,
            color: context.colors.onSurface.withAlpha(150),
          ),
        ),
      ],
    );
  }
}

// Slide 2: Tasks
class _TasksSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mock task interface
          AdaptiveCardWidget(
            padding: const EdgeInsets.all(20),
            borderRadius: 20,
            child: Column(
              children: [
                _buildMockTask(context, 'Workout', Icons.fitness_center, Colors.red, true),
                const SizedBox(height: 12),
                _buildMockTask(context, 'Buy groceries', Icons.shopping_cart, Colors.green, false),
                const SizedBox(height: 12),
                _buildMockTask(context, 'Read for 30 mins', Icons.book, Colors.blue, false),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Title
          Text(
            'Organize Your Tasks',
            style: context.textStyles.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: TextSizes.xxl,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            'Create tasks with start times, durations, colors, and subtasks. Tap to expand and see more details, or hold to complete instantly.',
            style: context.textStyles.bodyLarge?.copyWith(
              fontSize: TextSizes.l,
              height: 1.4,
              color: context.colors.onSurface.withAlpha(180),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Feature highlights
          _buildFeatureList(context, [
            'Set start times and durations',
            'Add subtasks for complex projects',
            'Color-code by priority or category',
          ]),
        ],
      ),
    );
  }

  Widget _buildMockTask(BuildContext context, String title, IconData icon, Color color, bool isCompleted) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 16),
        Icon(icon, color: isCompleted ? context.colors.onSurface.withAlpha(100) : color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: TextSizes.m,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted ? context.colors.onSurface.withAlpha(100) : null,
            ),
          ),
        ),
        Icon(
          isCompleted ? Icons.check_circle : Icons.circle_outlined,
          color: isCompleted ? context.colors.onSurface.withAlpha(100) : color,
        ),
      ],
    );
  }

  Widget _buildFeatureList(BuildContext context, List<String> features) {
    return Column(
      spacing: 8,
      children: features
          .map((feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: context.colors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: context.textStyles.bodyMedium?.copyWith(
                          fontSize: TextSizes.m,
                          color: context.colors.onSurface.withAlpha(160),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

// Slide 3: Habits
class _HabitsSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mock habit interface
          AdaptiveCardWidget(
            padding: const EdgeInsets.all(20),
            borderRadius: 20,
            child: Column(
              children: [
                _buildMockHabit(context, 'Drink 8 glasses of water', 12, true),
                const SizedBox(height: 16),
                _buildMockHabit(context, 'Practice gratitude', 7, true),
                const SizedBox(height: 16),
                _buildMockHabit(context, 'Morning meditation', 3, false),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Title
          Text(
            'Build Lasting Habits',
            style: context.textStyles.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: TextSizes.xxl,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            'Track daily habits and build streaks. The app automatically calculates your current streak and motivates you to keep going.',
            style: context.textStyles.bodyLarge?.copyWith(
              fontSize: TextSizes.l,
              height: 1.4,
              color: context.colors.onSurface.withAlpha(180),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Streak explanation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.secondary.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: context.colors.secondary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Streak counters show your consecutive days of progress',
                    style: context.textStyles.bodyMedium?.copyWith(
                      fontSize: TextSizes.m,
                      color: context.colors.onSurface.withAlpha(160),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockHabit(BuildContext context, String title, int streak, bool isCompleted) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: TextSizes.m,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                color: isCompleted ? context.colors.onSurface.withAlpha(150) : null,
              ),
            ),
          ),
        ),
        if (streak > 0) ...[
          const SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_fire_department,
                color: isCompleted ? context.colors.secondary : context.colors.onSurface.withAlpha(100),
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '$streak',
                style: TextStyle(
                  fontSize: TextSizes.m,
                  fontWeight: FontWeight.bold,
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// Slide 4: Notifications
class _NotificationsSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mock notification
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.colors.primary.withAlpha(15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.colors.primary.withAlpha(50)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.colors.primary.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: context.colors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time to progress',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: TextSizes.m,
                            ),
                          ),
                          Text(
                            'Workout (60 mins)',
                            style: TextStyle(
                              color: context.colors.onSurface.withAlpha(150),
                              fontSize: TextSizes.s,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'now',
                      style: TextStyle(
                        color: context.colors.primary,
                        fontSize: TextSizes.s,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Title
          Text(
            'Smart Notifications',
            style: context.textStyles.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: TextSizes.xxl,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            'Set custom reminders for your tasks. Get notified minutes or hours before, or at a specific time. Never miss an important task again.',
            style: context.textStyles.bodyLarge?.copyWith(
              fontSize: TextSizes.l,
              height: 1.4,
              color: context.colors.onSurface.withAlpha(180),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Notification options
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _buildNotificationOption(context, 'At start'),
              _buildNotificationOption(context, '5 min before'),
              _buildNotificationOption(context, '15 min before'),
              _buildNotificationOption(context, 'Custom time'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationOption(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.outline.withAlpha(50)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: TextSizes.s,
          color: context.colors.onSurface.withAlpha(160),
        ),
      ),
    );
  }
}

// Slide 5: Personalization
class _PersonalizationSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Settings preview
          AdaptiveCardWidget(
            padding: const EdgeInsets.all(20),
            borderRadius: 16,
            child: Column(
              children: [
                _buildSettingItem(context, Icons.opacity, 'Liquid Glass Effects', true),
                _buildSettingItem(context, Icons.format_quote, 'Daily Quotes', true),
                _buildSettingItem(context, Icons.density_medium, 'Compact View', false),
                _buildSettingItem(context, Icons.message_outlined, 'Status Messages', true),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Title
          Text(
            'Make It Yours',
            style: context.textStyles.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: TextSizes.xxl,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            'Customize the app to match your style. Choose from different visual effects, display densities, and personalization options in the profile section.',
            style: context.textStyles.bodyLarge?.copyWith(
              fontSize: TextSizes.l,
              height: 1.4,
              color: context.colors.onSurface.withAlpha(180),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, IconData icon, String title, bool enabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: context.colors.primary,
            size: 20,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: TextSizes.m,
              ),
            ),
          ),
          Switch(
            value: enabled,
            onChanged: null,
            activeThumbColor: context.colors.primary,
          ),
        ],
      ),
    );
  }
}

// Slide 6: Get Started
class _GetStartedSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: context.colors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.anchor,
              color: context.colors.primary,
              size: 60,
            ),
          ),

          const SizedBox(height: 40),

          // Title
          Text(
            'Ready to Begin!',
            style: context.textStyles.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colors.primary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            'You\'re all set! Start by creating your first task or habit. Remember, you can always revisit this tutorial from the profile screen.',
            style: context.textStyles.bodyLarge?.copyWith(
              fontSize: TextSizes.l,
              height: 1.4,
              color: context.colors.onSurface.withAlpha(180),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Quick tips
          AdaptiveCardWidget(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Quick Tips',
                  style: context.textStyles.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: TextSizes.l,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTip(context, 'Tap + to create tasks and habits'),
                const SizedBox(height: 8),
                _buildTip(context, 'Long press to edit or complete tasks'),
                const SizedBox(height: 8),
                _buildTip(context, 'Swipe calendar to navigate between days'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(BuildContext context, String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.tips_and_updates_outlined,
            color: context.colors.secondary,
            size: 16,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: context.textStyles.bodyMedium?.copyWith(
                fontSize: TextSizes.s,
                color: context.colors.onSurface.withAlpha(160),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
