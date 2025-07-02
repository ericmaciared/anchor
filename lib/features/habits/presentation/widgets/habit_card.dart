import 'package:anchor/features/habits/domain/entities/habit_model.dart';
import 'package:flutter/material.dart';

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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GestureDetector(
        onTap: onToggleHabitCompletion, // This will toggle completion on tap
        onLongPress: onLongPress, // This will handle long press events
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
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                // --- Streak Indicator ---
                if (habit.currentStreak > 0) ...[
                  const SizedBox(
                      width:
                          12), // Spacing between the card and the streak indicator
                  Row(
                    mainAxisSize: MainAxisSize
                        .min, // Make the column as small as its children
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        color: colorScheme.secondary,
                        size: 24,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        '${habit.currentStreak}',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
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
