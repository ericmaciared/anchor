import 'package:anchor/features/habits/customize_habits_modal.dart';
import 'package:anchor/features/habits/habit_card.dart';
import 'package:flutter/material.dart';

import 'models/habit_model.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final List<Habit> _habits = [
    Habit(id: 1, title: 'Drink water', icon: Icons.local_drink),
    Habit(id: 2, title: 'Meditate', icon: Icons.self_improvement),
    Habit(id: 3, title: 'Exercise', icon: Icons.fitness_center),
  ];

  void _showCustomizeModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const CustomizeHabitsModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('habits.')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _habits.length + 1,
        itemBuilder: (context, index) {
          if (index < _habits.length) {
            return HabitCard(habit: _habits[index]);
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Center(
                child: OutlinedButton.icon(
                  onPressed: _showCustomizeModal,
                  icon: const Icon(Icons.edit),
                  label: const Text('Personalize Habits'),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
