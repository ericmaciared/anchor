import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/task_model.dart';
import 'task_card.dart';

class TasksList extends StatefulWidget {
  final List<Task> tasks;

  const TasksList({super.key, required this.tasks});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _markTaskCompleted(Task task) {
    HapticFeedback.lightImpact();
    setState(() {
      task.completed = true;
    });
    _confettiController.play();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Completed "${task.title}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tasks.isEmpty) {
      return const Center(child: Text('No tasks for today'));
    }
    return Stack(
      children: [
        ListView.builder(
          itemCount: widget.tasks.length,
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemBuilder: (context, index) {
            final task = widget.tasks[index];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onLongPress: () => _markTaskCompleted(task),
                child: TaskCard(task: task),
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ),
      ],
    );
  }
}
