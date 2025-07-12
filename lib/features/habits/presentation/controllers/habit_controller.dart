import 'package:anchor/features/habits/domain/entities/habit_model.dart';
import 'package:anchor/features/habits/presentation/providers/habit_provider.dart';
import 'package:anchor/features/habits/presentation/widgets/habit_actions/habit_actions_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HabitController {
  final WidgetRef ref;
  final BuildContext context;

  HabitController(this.ref, this.context);

  List<HabitModel> getAllHabits() {
    final habits = ref.watch(habitProvider);
    return habits;
  }

  List<HabitModel> getAllSelectedHabits() {
    final habits = ref.watch(habitProvider);
    return habits.where((t) => t.isSelected).toList();
  }

  void showCreateHabitModal() {
    final habitNotifier = ref.read(habitProvider.notifier);
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HabitActionsModal(
        onSubmit: (habit) => habitNotifier.createHabit(habit),
      ),
    );
  }

  void showEditHabitModal(HabitModel habit) {
    final habitNotifier = ref.read(habitProvider.notifier);
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HabitActionsModal(
        initialHabit: habit,
        onSubmit: (habit) => habitNotifier.updateHabit(habit),
        onDelete: (habit) async {
          final deleted = await habitNotifier.deleteHabit(habit.id);
          if (deleted != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Habit "${deleted.name}" deleted'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    habitNotifier.undoDelete(deleted);
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void toggleHabitCompletion(HabitModel habit) {
    ref.read(habitProvider.notifier).toggleHabitCompletion(habit);
  }
}
