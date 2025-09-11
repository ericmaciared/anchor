import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/features/habits/domain/entities/habit_model.dart';
import 'package:flutter/material.dart';

import 'habit_card.dart';

typedef HabitCallback = void Function(HabitModel habit);

class HabitList extends StatelessWidget {
  final List<HabitModel> habits;
  final String? label;
  final void Function(HabitModel habit) onToggleHabitCompletion;
  final HabitCallback onLongPress;

  const HabitList({
    super.key,
    required this.habits,
    required this.onToggleHabitCompletion,
    required this.onLongPress,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(label!, style: context.textStyles.titleMedium),
          ),
        ...habits.map(
          (habit) => HabitCard(
            habit: habit,
            onToggleHabitCompletion: () => onToggleHabitCompletion(habit),
            onLongPress: () => onLongPress(habit),
          ),
        ),
      ],
    );
  }
}
