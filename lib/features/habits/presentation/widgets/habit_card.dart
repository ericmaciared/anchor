import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/features/habits/domain/entities/habit_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/haptic_feedback_service.dart';

class HabitCard extends StatelessWidget {
  final HabitModel habit;
  final VoidCallback onLongPress;
  final VoidCallback onToggleHabitCompletion;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onLongPress,
    required this.onToggleHabitCompletion,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Determine if the habit is completed today for text styling
    final isCompletedToday = habit.isCompletedToday();

    // Determine if the streak should be shown
    bool shouldShowStreak = false;
    if (habit.currentStreak > 0 && habit.lastCompletedDate != null) {
      final now = DateTime.now();
      final lastCompletedDay = DateUtils.dateOnly(habit.lastCompletedDate!);
      final today = DateUtils.dateOnly(now);
      final yesterday = DateUtils.dateOnly(now.subtract(const Duration(days: 1)));

      // Show streak if completed today or yesterday
      if (lastCompletedDay.isAtSameMomentAs(today) || lastCompletedDay.isAtSameMomentAs(yesterday)) {
        shouldShowStreak = true;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GestureDetector(
        onTap: () {
          // Add haptic feedback for habit completion toggle
          if (isCompletedToday) {
            HapticService.medium(); // Undoing completion
          } else {
            HapticService.success(); // Completing habit
          }
          onToggleHabitCompletion();
        },
        onLongPress: () {
          HapticService.longPress(); // Long press feedback
          onLongPress();
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          habit.name,
                          style: textTheme.bodyMedium!.copyWith(
                            fontSize: TextSizes.M,
                            decoration: isCompletedToday ? TextDecoration.lineThrough : TextDecoration.none,
                            color: isCompletedToday
                                ? textTheme.titleMedium!.color?.withAlpha(150)
                                : textTheme.titleMedium!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (shouldShowStreak) ...[
                  const SizedBox(width: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        color: isCompletedToday
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onSurface.withAlpha(100),
                        size: 20,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        '${habit.currentStreak}',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: TextSizes.M,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
