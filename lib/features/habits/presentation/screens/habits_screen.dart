import 'package:anchor/features/habits/presentation/controllers/habit_controller.dart';
import 'package:anchor/features/habits/presentation/widgets/habit_list.dart'; // Needed for HabitList
import 'package:anchor/features/habits/presentation/widgets/habits_screen_app_bar.dart';
import 'package:anchor/features/shared/quotes/presentation/widgets/daily_quote_card.dart'; // Needed for DailyQuoteCard
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/empty_habit_state.dart';

class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({super.key});

  @override
  ConsumerState<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends ConsumerState<HabitsScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = HabitController(ref, context);
    final selectedHabits = controller.getAllSelectedHabits();

    return Scaffold(
      appBar: HabitsScreenAppBar(
        onAddHabit: () => controller.showCreateHabitModal(),
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Scrollable content
            selectedHabits.isEmpty
                ? EmptyHabitState(onAdd: () {})
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      HabitList(
                        habits: selectedHabits,
                        label: 'Habits',
                        onToggleHabitCompletion: (habit) {
                          controller.toggleHabitCompletion(habit);
                        },
                        onLongPress: (habit) {
                          controller.showEditHabitModal(habit);
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16),
                        child: Divider(),
                      ),
                      DailyQuoteCard(),
                      const SizedBox(height: 112),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
