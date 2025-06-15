import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:flutter/material.dart';

class SuggestedTasksList extends StatefulWidget {
  final void Function(TaskModel task) onTap;

  const SuggestedTasksList({super.key, required this.onTap});

  static List<TaskModel> get suggestions {
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
  State<SuggestedTasksList> createState() => _SuggestedTasksListState();
}

class _SuggestedTasksListState extends State<SuggestedTasksList> {
  final List<bool> _visible =
      List.generate(SuggestedTasksList.suggestions.length, (_) => false);

  @override
  void initState() {
    super.initState();
    _staggeredShow();
  }

  Future<void> _staggeredShow() async {
    for (int i = 0; i < _visible.length; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        setState(() {
          _visible[i] = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Some suggestions?',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(100)),
        ),
        const SizedBox(height: 12),
        ...SuggestedTasksList.suggestions.asMap().entries.map((entry) {
          final i = entry.key;
          final task = entry.value;

          return AnimatedOpacity(
            opacity: _visible[i] ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: AnimatedSlide(
              offset: _visible[i] ? Offset.zero : const Offset(0, 0.2),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => widget.onTap(task),
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
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withAlpha(100)),
                          )
                        : null,
                    horizontalTitleGap: 12,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ),
            ),
          );
        })
      ],
    );
  }
}
