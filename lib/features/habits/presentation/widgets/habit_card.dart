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
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: LayoutBuilder(builder: (context, constraints) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(habit.name),
                ],
              ),
            ),
          );
        }));
  }
}
