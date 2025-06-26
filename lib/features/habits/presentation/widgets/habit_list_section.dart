import 'package:anchor/features/habits/domain/entities/habit_model.dart';
import 'package:anchor/features/shared/quotes/presentation/widgets/daily_quote_card.dart';
import 'package:flutter/material.dart';

import 'habit_list.dart';

class HabitListSection extends StatelessWidget {
  final List<HabitModel> habits;
  final void Function(HabitModel habit) onToggleHabitCompletion;
  final void Function(HabitModel habit) onLongPress;

  const HabitListSection({
    super.key,
    required this.habits,
    required this.onToggleHabitCompletion,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        HabitList(
          habits: habits,
          label: 'Habits',
          onToggleHabitCompletion: onToggleHabitCompletion,
          onLongPress: onLongPress,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Divider(),
        ),
        DailyQuoteCard(),
        const SizedBox(height: 112),
      ],
    );
  }
}
