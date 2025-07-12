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

class _GreetingCardState extends ConsumerState<GreetingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String? _lastGreeting;
  String? _lastName;
  int _lastCompletedTasks = -1;
  int _lastTotalTasks = -1;
  int _lastCompletedHabits = -1;
  int _lastTotalHabits = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

  List<TextSpan> _getCustomMessageSpans(
    BuildContext context,
    String userName,
    int totalTasks,
    int completedTasks,
    int totalHabits,
    int completedHabits,
  ) {
    final remainingTasks = totalTasks - completedTasks;
    final remainingHabits = totalHabits - completedHabits;
    final totalRemainingGoals = remainingTasks + remainingHabits;

    final colorScheme = Theme.of(context).colorScheme;

    const double commonLineHeight = 1.5;

    final baseTextStyle = Theme.of(context).textTheme.titleLarge!.copyWith(
          color: colorScheme.onSurface,
          height: commonLineHeight, // Apply consistent height
        );
    final highlightStyle = baseTextStyle.copyWith(
      color: colorScheme.secondary,
      fontWeight: FontWeight.bold,
      fontSize: baseTextStyle.fontSize! * 1.1,
      height: commonLineHeight,
    );
    final numberHighlightStyle = highlightStyle.copyWith(
      color: colorScheme.primary,
      fontSize: baseTextStyle.fontSize! * 1.2,
      height: commonLineHeight,
    );

    final List<TextSpan> messageSpans = [
      TextSpan(text: '${_getGreeting()} ', style: baseTextStyle),
      TextSpan(text: '$userName, ', style: baseTextStyle),
    ];

    if (totalTasks == 0 && totalHabits == 0) {
      messageSpans.addAll([
        TextSpan(text: 'you have ', style: baseTextStyle),
        TextSpan(
            text: 'no goals',
            style: highlightStyle.copyWith(color: colorScheme.error)),
        TextSpan(
            text: ' set for today. Time to add some!', style: baseTextStyle),
      ]);
    } else if (totalRemainingGoals == 0) {
      messageSpans.addAll([
        TextSpan(text: 'awesome! ', style: highlightStyle),
        TextSpan(text: 'All your goals are ', style: baseTextStyle),
        TextSpan(
            text: 'completed',
            style: highlightStyle.copyWith(color: colorScheme.tertiary)),
        TextSpan(text: ' for today.', style: baseTextStyle),
      ]);
    } else if (remainingTasks == 0 && remainingHabits > 0) {
      messageSpans.addAll([
        TextSpan(text: 'great job', style: highlightStyle),
        TextSpan(
            text: ' on your tasks! Keep up the habit building. ',
            style: baseTextStyle),
        TextSpan(text: '$remainingHabits', style: numberHighlightStyle),
        TextSpan(text: ' habits remaining.', style: baseTextStyle),
      ]);
    } else if (remainingHabits == 0 && remainingTasks > 0) {
      messageSpans.addAll([
        TextSpan(text: 'habits on point! ', style: highlightStyle),
        TextSpan(text: 'Let\'s crush those ', style: baseTextStyle),
        TextSpan(text: '$remainingTasks', style: numberHighlightStyle),
        TextSpan(text: ' tasks remaining.', style: baseTextStyle),
      ]);
    } else if (totalRemainingGoals <= (totalTasks + totalHabits) / 2) {
      messageSpans.addAll([
        TextSpan(text: 'you\'re doing great, ', style: highlightStyle),
        TextSpan(text: 'almost there! ', style: baseTextStyle),
        TextSpan(text: '$totalRemainingGoals', style: numberHighlightStyle),
        TextSpan(text: ' goals left.', style: baseTextStyle),
      ]);
    } else if (totalRemainingGoals > 0 &&
        totalRemainingGoals == (totalTasks + totalHabits)) {
      messageSpans.addAll([
        TextSpan(text: 'time to get started', style: highlightStyle),
        TextSpan(text: ' on your goals for today! ', style: baseTextStyle),
        TextSpan(text: '$totalRemainingGoals', style: numberHighlightStyle),
        TextSpan(text: ' goals to tackle.', style: baseTextStyle),
      ]);
    } else {
      messageSpans.addAll([
        TextSpan(text: 'keep pushing, ', style: highlightStyle),
        TextSpan(text: 'you\'ve got this! ', style: baseTextStyle),
        TextSpan(text: '$totalRemainingGoals', style: numberHighlightStyle),
        TextSpan(text: ' goals to go.', style: baseTextStyle),
      ]);
    }
    return messageSpans;
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

    final completedHabits =
        allTodayHabits.where((habit) => habit.isCompletedToday()).length;
    final totalHabits = allTodayHabits.length;

    return settingsAsyncValue.when(
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
      data: (settings) {
        if (!settings.statusMessageEnabled) return SizedBox.shrink();
        final currentGreeting = _getGreeting();
        final currentUserName = settings.profileName;

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
          _animationController.forward(from: 0.0);
        }

        final customMessageSpans = _getCustomMessageSpans(
          context,
          currentUserName,
          totalTasks,
          completedTasks,
          totalHabits,
          completedHabits,
        );

        return FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: customMessageSpans,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
