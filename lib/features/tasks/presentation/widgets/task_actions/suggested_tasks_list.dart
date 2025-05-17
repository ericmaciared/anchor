import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:flutter/material.dart';

class SuggestedTasksList extends StatelessWidget {
  final void Function(Task task) onTap;

  const SuggestedTasksList({super.key, required this.onTap});

  static List<Task> get suggestions {
    final now = DateTime.now();
    return [
      Task(
        id: 'suggestion-1',
        title: 'Workout',
        icon: Icons.fitness_center,
        color: Colors.redAccent,
        startTime: DateTime(now.year, now.month, now.day, 7, 0),
        duration: const Duration(minutes: 60),
        isDone: false,
        day: now,
      ),
      Task(
        id: 'suggestion-2',
        title: 'Read',
        icon: Icons.book,
        color: Colors.indigo,
        startTime: DateTime(now.year, now.month, now.day, 21, 30),
        duration: const Duration(minutes: 30),
        isDone: false,
        day: now,
      ),
      Task(
        id: 'suggestion-3',
        title: 'Buy groceries',
        icon: Icons.shopping_cart,
        color: Colors.green,
        startTime: DateTime(now.year, now.month, now.day, 17, 0),
        duration: const Duration(minutes: 45),
        isDone: false,
        day: now,
      ),
      Task(
        id: 'suggestion-4',
        title: 'Meditate',
        icon: Icons.self_improvement,
        color: Colors.deepPurple,
        startTime: DateTime(now.year, now.month, now.day, 6, 30),
        duration: const Duration(minutes: 15),
        isDone: false,
        day: now,
      ),
      Task(
        id: 'suggestion-5',
        title: 'Walk dog',
        icon: Icons.pets,
        color: Colors.orange,
        startTime: DateTime(now.year, now.month, now.day, 8, 0),
        duration: const Duration(minutes: 30),
        isDone: false,
        day: now,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Some suggestions?',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 12),
        ...suggestions.map((task) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTap(task),
              borderRadius: BorderRadius.circular(8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: task.color,
                  child: Icon(task.icon, color: Colors.white),
                ),
                title: Text(task.title),
                subtitle: task.startTime != null
                    ? Text(
                        '${TimeOfDay.fromDateTime(task.startTime!).format(context)} · ${task.duration?.inMinutes ?? 0} min',
                        style: TextStyle(color: Colors.grey.shade600),
                      )
                    : null,
                horizontalTitleGap: 12,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          );
        })
      ],
    );
  }
}
