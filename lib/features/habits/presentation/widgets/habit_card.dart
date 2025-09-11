import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
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
    // Determine if the habit is completed today for text styling
    final isCompletedToday = habit.isCompletedToday();

    // Determine if the streak should be shown
    bool shouldShowStreak = habit.shouldShowStreak();

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
                          style: context.textStyles.bodyMedium!.copyWith(
                            fontSize: TextSizes.m,
                            decoration: isCompletedToday ? TextDecoration.lineThrough : TextDecoration.none,
                            color: isCompletedToday
                                ? context.textStyles.titleMedium!.color?.withAlpha(150)
                                : context.textStyles.titleMedium!.color,
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
                        color: isCompletedToday ? context.colors.secondary : context.colors.onSurface.withAlpha(100),
                        size: 20,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        '${habit.currentStreak}',
                        style: context.textStyles.titleMedium?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: TextSizes.m,
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
