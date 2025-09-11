import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/spacing_sizes.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:flutter/material.dart';

class SuggestedTasksChips extends StatelessWidget {
  final void Function(TaskModel task) onSuggestionSelected;

  const SuggestedTasksChips({
    super.key,
    required this.onSuggestionSelected,
  });

  static List<TaskModel> get _suggestions {
    final now = DateTime.now();
    return [
      TaskModel(
        id: 'suggestion-1',
        title: 'Workout',
        icon: Icons.fitness_center,
        color: Colors.redAccent,
        startTime: DateTime(now.year, now.month, now.day, 7, 0),
        duration: const Duration(minutes: 60),
        isDone: false,
        day: now,
      ),
      TaskModel(
        id: 'suggestion-2',
        title: 'Read',
        icon: Icons.book,
        color: Colors.indigo,
        startTime: DateTime(now.year, now.month, now.day, 21, 30),
        duration: const Duration(minutes: 30),
        isDone: false,
        day: now,
      ),
      TaskModel(
        id: 'suggestion-3',
        title: 'Buy groceries',
        icon: Icons.shopping_cart,
        color: Colors.green,
        startTime: DateTime(now.year, now.month, now.day, 17, 0),
        duration: const Duration(minutes: 45),
        isDone: false,
        day: now,
      ),
      TaskModel(
        id: 'suggestion-4',
        title: 'Meditate',
        icon: Icons.self_improvement,
        color: Colors.deepPurple,
        startTime: DateTime(now.year, now.month, now.day, 6, 30),
        duration: const Duration(minutes: 15),
        isDone: false,
        day: now,
      ),
      TaskModel(
        id: 'suggestion-5',
        title: 'Walk dog',
        icon: Icons.pets,
        color: Colors.orange,
        startTime: DateTime(now.year, now.month, now.day, 8, 0),
        duration: const Duration(minutes: 30),
        isDone: false,
        day: now,
      ),
      TaskModel(
        id: 'suggestion-6',
        title: 'Journal',
        icon: Icons.edit,
        color: Colors.brown,
        startTime: DateTime(now.year, now.month, now.day, 22, 0),
        duration: const Duration(minutes: 20),
        isDone: false,
        day: now,
      ),
      TaskModel(
        id: 'suggestion-7',
        title: 'Clean room',
        icon: Icons.cleaning_services,
        color: Colors.lightBlue,
        startTime: DateTime(now.year, now.month, now.day, 15, 0),
        duration: const Duration(minutes: 40),
        isDone: false,
        day: now,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SpacingSizes.m),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: SpacingSizes.m),
            ..._suggestions.map((suggested) {
              return Padding(
                padding: const EdgeInsets.only(right: SpacingSizes.s),
                child: ActionChip(
                  avatar: Icon(suggested.icon, size: 16),
                  label: Text(suggested.title, style: context.textStyles.bodyMedium!.copyWith(fontSize: TextSizes.s)),
                  onPressed: () {
                    HapticService.selection(); // Selection feedback for suggestion
                    onSuggestionSelected(suggested);
                  },
                ),
              );
            }),
            SizedBox(width: 16.0),
          ],
        ),
      ),
    );
  }
}
