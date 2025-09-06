import 'package:anchor/core/mixins/safe_animation_mixin.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/features/habits/presentation/controllers/habit_controller.dart';
import 'package:anchor/features/shared/settings/settings_provider.dart';
import 'package:anchor/features/tasks/presentation/controllers/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GreetingCard extends ConsumerStatefulWidget {
  const GreetingCard({super.key});

  @override
  ConsumerState<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends ConsumerState<GreetingCard> with TickerProviderStateMixin, SafeAnimationMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  String? _lastGreeting;
  String? _lastName;
  int _lastCompletedTasks = -1;
  int _lastTotalTasks = -1;
  int _lastCompletedHabits = -1;
  int _lastTotalHabits = -1;

  // Cache for expensive computations
  String _cacheKey = '';
  List<TextSpan>? _cachedSpans;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = createController(
      duration: const Duration(milliseconds: 700),
      debugLabel: 'GreetingCard_Fade',
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    // Start initial animation
    safeAnimate(_fadeController, () => _fadeController.forward());
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'good morning';
    } else if (hour < 18) {
      return 'good afternoon';
    } else {
      return 'good evening';
    }
  }

  String _generateCacheKey(
    String userName,
    int totalTasks,
    int completedTasks,
    int totalHabits,
    int completedHabits,
    String displayDensity,
  ) {
    final greeting = _getGreeting();
    return '$greeting-$userName-$completedTasks-$totalTasks-$completedHabits-$totalHabits-$displayDensity';
  }

  double _getBaseFontSize(String displayDensity) {
    return displayDensity == 'Compact' ? TextSizes.M : TextSizes.L;
  }

  double _getHighlightFontSize(String displayDensity) {
    return displayDensity == 'Compact' ? TextSizes.L : TextSizes.XL;
  }

  double _getLineHeight(String displayDensity) {
    return 1.5; // Consistent line height regardless of density
  }

  EdgeInsets _getPadding(String displayDensity) {
    return displayDensity == 'Compact'
        ? const EdgeInsets.symmetric(horizontal: 0, vertical: 12)
        : const EdgeInsets.symmetric(horizontal: 0, vertical: 16);
  }

  List<TextSpan> _getPersonalizedMessageSpans(
    BuildContext context,
    String userName,
    int totalTasks,
    int completedTasks,
    int totalHabits,
    int completedHabits,
    String displayDensity,
  ) {
    final cacheKey = _generateCacheKey(
      userName,
      totalTasks,
      completedTasks,
      totalHabits,
      completedHabits,
      displayDensity,
    );

    // Return cached result if available
    if (_cacheKey == cacheKey && _cachedSpans != null) {
      return _cachedSpans!;
    }

    final remainingTasks = totalTasks - completedTasks;
    final remainingHabits = totalHabits - completedHabits;
    final totalRemainingGoals = remainingTasks + remainingHabits;
    final totalGoals = totalTasks + totalHabits;
    final completedGoals = completedTasks + completedHabits;

    final colorScheme = Theme.of(context).colorScheme;
    final lineHeight = _getLineHeight(displayDensity);

    final baseTextStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w400,
          fontSize: _getBaseFontSize(displayDensity),
          height: lineHeight,
        );

    final highlightStyle = baseTextStyle.copyWith(
      color: colorScheme.secondary,
      fontWeight: FontWeight.w600,
      fontSize: _getHighlightFontSize(displayDensity),
    );

    final successStyle = highlightStyle.copyWith(
      color: colorScheme.tertiary,
    );

    final hour = DateTime.now().hour;
    final dayOfWeek = DateTime.now().weekday; // 1 = Monday, 7 = Sunday

    final List<TextSpan> messageSpans = [
      TextSpan(text: '${_getGreeting()} ', style: baseTextStyle),
      TextSpan(text: '$userName', style: highlightStyle),
      TextSpan(text: ', ', style: baseTextStyle),
    ];

    // No goals set
    if (totalGoals == 0) {
      final noGoalsMessages = [
        'your schedule is open. Ready to add some structure?',
        'clean slate today. What would you like to accomplish?',
        'no commitments yet. Time to set some intentions.',
        'blank canvas today. What priorities deserve your focus?',
        'open agenda. Consider adding tasks or habits to track progress.',
        'flexible day ahead. What goals would serve you well?',
      ];
      final messageIndex = (hour + dayOfWeek) % noGoalsMessages.length;

      messageSpans.add(TextSpan(text: noGoalsMessages[messageIndex], style: baseTextStyle));
    }
    // All goals completed
    else if (totalRemainingGoals == 0) {
      final completionMessages = [
        'all objectives complete. Strong execution today.',
        'clean sweep. All tasks and habits finished.',
        'everything done. Efficient day of progress.',
        'goals achieved. Well-planned and well-executed.',
        'full completion. Your systems are working.',
        'objectives met. Consistent follow-through pays off.',
        'all items cleared. Productive day in the books.',
        'targets hit. Solid commitment to your priorities.',
      ];
      final messageIndex = (completedGoals + dayOfWeek) % completionMessages.length;

      messageSpans.add(TextSpan(text: completionMessages[messageIndex], style: successStyle));
    }
    // Progress in motion
    else {
      final progressPercentage = (completedGoals / totalGoals * 100).round();

      // 80%+ completion
      if (progressPercentage >= 80) {
        final nearCompletionMessages = [
          'strong finish ahead. $totalRemainingGoals items left to close out.',
          'almost there. $totalRemainingGoals remaining for full completion.',
          'final push needed. $totalRemainingGoals goals still open.',
          'home stretch. $totalRemainingGoals tasks awaiting attention.',
          'nearly done. $totalRemainingGoals items on your list.',
          'closing time. $totalRemainingGoals objectives left to finish.',
        ];
        final messageIndex = (progressPercentage + hour) % nearCompletionMessages.length;

        messageSpans.add(TextSpan(text: nearCompletionMessages[messageIndex], style: baseTextStyle));
      }
      // 50-79% completion
      else if (progressPercentage >= 50) {
        final midProgressMessages = [
          'steady progress. $totalRemainingGoals goals remain on your radar.',
          'good momentum building. $totalRemainingGoals items still need focus.',
          'halfway point passed. $totalRemainingGoals objectives ahead.',
          'consistent execution. $totalRemainingGoals tasks in your queue.',
          'solid advancement. $totalRemainingGoals goals require attention.',
          'progress tracking well. $totalRemainingGoals items left to tackle.',
        ];
        final messageIndex = (completedGoals + dayOfWeek) % midProgressMessages.length;

        messageSpans.add(TextSpan(text: midProgressMessages[messageIndex], style: baseTextStyle));
      }
      // 25-49% completion
      else if (progressPercentage >= 25) {
        final earlyProgressMessages = [
          'momentum started. $totalRemainingGoals goals need your focus.',
          'foundation laid. $totalRemainingGoals items await completion.',
          'initial progress made. $totalRemainingGoals objectives remain.',
          'good beginning. $totalRemainingGoals tasks on your agenda.',
          'early wins secured. $totalRemainingGoals goals still active.',
          'started strong. $totalRemainingGoals items need attention.',
        ];
        final messageIndex = (totalGoals + hour) % earlyProgressMessages.length;

        messageSpans.add(TextSpan(text: earlyProgressMessages[messageIndex], style: baseTextStyle));
      }
      // 1-24% completion
      else if (completedGoals > 0) {
        final minimumProgressMessages = [
          'first steps taken. $totalRemainingGoals goals need progress.',
          'initial momentum. $totalRemainingGoals items require focus.',
          'starting movement. $totalRemainingGoals objectives ahead.',
          'early action completed. $totalRemainingGoals tasks remain.',
          'baseline established. $totalRemainingGoals goals active.',
          'opening progress. $totalRemainingGoals items on your list.',
        ];
        final messageIndex = (completedGoals + dayOfWeek) % minimumProgressMessages.length;

        messageSpans.add(TextSpan(text: minimumProgressMessages[messageIndex], style: baseTextStyle));
      }
      // No progress yet
      else {
        List<String> noProgressMessages;

        if (hour < 8) {
          noProgressMessages = [
            'early start available. $totalGoals goals ready for attention.',
            'morning advantage. $totalGoals objectives set for today.',
            'day begins now. $totalGoals items on your schedule.',
            'fresh start time. $totalGoals goals await your focus.',
          ];
        } else if (hour < 12) {
          noProgressMessages = [
            'morning focus time. $totalGoals goals need your attention.',
            'productive hours ahead. $totalGoals objectives to address.',
            'workflow ready. $totalGoals items require progress.',
            'momentum time. $totalGoals goals on your agenda.',
          ];
        } else if (hour < 16) {
          noProgressMessages = [
            'afternoon productivity. $totalGoals goals await progress.',
            'midday focus. $totalGoals objectives need attention.',
            'afternoon execution. $totalGoals items on your list.',
            'steady progress time. $totalGoals goals require focus.',
          ];
        } else if (hour < 20) {
          noProgressMessages = [
            'evening focus. $totalGoals goals need completion.',
            'end-of-day push. $totalGoals objectives await attention.',
            'closing hours. $totalGoals items require progress.',
            'final focus time. $totalGoals goals on your agenda.',
          ];
        } else {
          noProgressMessages = [
            'late planning session. $totalGoals goals set for progress.',
            'evening preparation. $totalGoals objectives need attention.',
            'night focus time. $totalGoals items await completion.',
            'quiet hours ahead. $totalGoals goals require focus.',
          ];
        }

        final messageIndex = (totalGoals + dayOfWeek) % noProgressMessages.length;
        messageSpans.add(TextSpan(text: noProgressMessages[messageIndex], style: baseTextStyle));
      }

      // Add specific context for task/habit balance
      if (remainingTasks == 0 && remainingHabits > 0) {
        final tasksDoneMessages = [
          ' Tasks cleared. Focus shifts to habit development.',
          ' Task list complete. Time for habit reinforcement.',
          ' All tasks finished. Habit consistency remains.',
          ' Task objectives met. Habits need attention.',
        ];
        final messageIndex = remainingHabits % tasksDoneMessages.length;
        messageSpans.add(TextSpan(text: tasksDoneMessages[messageIndex], style: baseTextStyle));
      } else if (remainingHabits == 0 && remainingTasks > 0) {
        final habitsDoneMessages = [
          ' Habits complete. Task execution needed.',
          ' Daily habits finished. Focus on task delivery.',
          ' Habit consistency maintained. Tasks require progress.',
          ' All habits done. Time for task completion.',
        ];
        final messageIndex = remainingTasks % habitsDoneMessages.length;
        messageSpans.add(TextSpan(text: habitsDoneMessages[messageIndex], style: baseTextStyle));
      } else if (remainingTasks > 0 && remainingHabits > 0) {
        // Mixed progress insights
        if (completedTasks > completedHabits) {
          messageSpans.add(TextSpan(text: ' Strong task progress today.', style: baseTextStyle));
        } else if (completedHabits > completedTasks) {
          messageSpans.add(TextSpan(text: ' Solid habit consistency today.', style: baseTextStyle));
        } else if (completedTasks == completedHabits && completedTasks > 0) {
          messageSpans.add(TextSpan(text: ' Balanced progress across goals.', style: baseTextStyle));
        }
      }
    }

    // Cache the result
    _cacheKey = cacheKey;
    _cachedSpans = messageSpans;

    return messageSpans;
  }

  void _triggerMessageChangeAnimation() {
    safeAnimate(_fadeController, () async {
      await _fadeController.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsyncValue = ref.watch(settingsProvider);

    final taskController = TaskController(ref, context);
    final habitController = HabitController(ref, context);

    final allTodayTasks = taskController.getTasksForDay(DateTime.now());
    final allTodayHabits = habitController.getAllSelectedHabits();

    final completedTasks = allTodayTasks.where((task) => task.isDone).length;
    final totalTasks = allTodayTasks.length;

    final completedHabits = allTodayHabits.where((habit) => habit.isCompletedToday()).length;
    final totalHabits = allTodayHabits.length;

    return settingsAsyncValue.when(
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
      data: (settings) {
        if (!settings.statusMessageEnabled) return const SizedBox.shrink();

        final currentGreeting = _getGreeting();
        final currentUserName = settings.profileName;
        final displayDensity = settings.displayDensity;

        bool hasMessageChanged = false;
        if (_lastGreeting != currentGreeting ||
            _lastName != currentUserName ||
            _lastCompletedTasks != completedTasks ||
            _lastTotalTasks != totalTasks ||
            _lastCompletedHabits != completedHabits ||
            _lastTotalHabits != totalHabits) {
          hasMessageChanged = true;
          _lastGreeting = currentGreeting;
          _lastName = currentUserName;
          _lastCompletedTasks = completedTasks;
          _lastTotalTasks = totalTasks;
          _lastCompletedHabits = completedHabits;
          _lastTotalHabits = totalHabits;
        }

        if (hasMessageChanged) {
          _triggerMessageChangeAnimation();
        }

        final personalizedMessageSpans = _getPersonalizedMessageSpans(
          context,
          currentUserName,
          totalTasks,
          completedTasks,
          totalHabits,
          completedHabits,
          displayDensity,
        );

        return FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: _getPadding(displayDensity),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(children: personalizedMessageSpans),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
