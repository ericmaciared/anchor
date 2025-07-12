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
        onTap: onToggleHabitCompletion,
        onLongPress: onLongPress,
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
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 14,
                                    decoration: habit.isCompletedToday()
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (habit.currentStreak > 0) ...[
                  const SizedBox(width: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        color: habit.isCompletedToday()
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(100),
                        size: 20,
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
                                  fontSize: 14,
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
