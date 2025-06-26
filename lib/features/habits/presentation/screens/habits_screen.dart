import 'package:anchor/features/habits/presentation/controllers/habit_controller.dart';
import 'package:anchor/features/habits/presentation/widgets/habit_list_section.dart';
import 'package:anchor/features/habits/presentation/widgets/habits_screen_app_bar.dart';
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
    final todayHabits = controller.getAllSelectedHabits();

    return Scaffold(
      appBar: HabitsScreenAppBar(
        onAddHabit: () {},
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Scrollable content
            Padding(
              padding: const EdgeInsets.only(
                  top: 96), // Adjust this height as needed
              child: todayHabits.isEmpty
                  ? EmptyHabitState(onAdd: () {})
                  : HabitListSection(
                      habits: todayHabits,
                      onToggleHabitCompletion: (habit) {},
                      onLongPress: (habit) {},
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
