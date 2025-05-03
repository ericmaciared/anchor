import 'package:anchor/features/tasks/add_edit_task_modal.dart';
import 'package:anchor/features/tasks/models/task_model.dart';
import 'package:anchor/features/tasks/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'task_list/tasks_list.dart';
import 'tasks_calendar.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  late DateTime _focusedDay;
  late DateTime _firstDayOfWeek;
  late DateTime _lastDayOfWeek;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _calculateCurrentWeek();
  }

  void _calculateCurrentWeek() {
    _firstDayOfWeek =
        _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1));
    _lastDayOfWeek = _firstDayOfWeek.add(const Duration(days: 6));
  }

  void _goToPreviousWeek() {
    setState(() {
      _focusedDay = _focusedDay.subtract(const Duration(days: 7));
      _calculateCurrentWeek();
    });
  }

  void _goToNextWeek() {
    setState(() {
      _focusedDay = _focusedDay.add(const Duration(days: 7));
      _calculateCurrentWeek();
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity != null) {
      if (details.primaryVelocity! < 0) {
        _goToNextWeek();
      } else if (details.primaryVelocity! > 0) {
        _goToPreviousWeek();
      }
    }
  }

  List<Task> _getTasksForDay(List<Task> allTasks, DateTime day) {
    return allTasks;
  }

  @override
  Widget build(BuildContext context) {
    final taskAsync = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('good morning.'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => AddEditTaskModal(
                  onSubmit: (task) async {
                    await ref.read(tasksProvider.notifier).addTask(task);
                  },
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TasksCalendar(
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              firstDayOfWeek: _firstDayOfWeek,
              lastDayOfWeek: _lastDayOfWeek,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onHorizontalDragEnd: _onHorizontalDragEnd,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: taskAsync.when(
                data: (tasks) {
                  List<Task> tasksForSelectedDay = _selectedDay != null
                      ? _getTasksForDay(tasks, _selectedDay!)
                      : [];
                  return TasksList(tasks: tasksForSelectedDay);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
