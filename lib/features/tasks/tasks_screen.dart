import 'package:anchor/features/tasks/models/task_model.dart';
import 'package:flutter/material.dart';

import 'tasks_calendar.dart';
import 'tasks_list.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late DateTime _focusedDay;
  late DateTime _firstDayOfWeek;
  late DateTime _lastDayOfWeek;
  DateTime? _selectedDay;

  final List<Task> _tasks = [
    Task(
      id: 1,
      title: 'Buy groceries',
      category: 'Personal',
      icon: Icons.shopping_cart,
      startTime: TimeOfDay(hour: 10, minute: 0),
      duration: const Duration(hours: 1),
    ),
    Task(
      id: 2,
      title: 'Finish project report',
      category: 'Work',
      icon: Icons.work,
      startTime: TimeOfDay(hour: 14, minute: 0),
      duration: const Duration(hours: 2),
    ),
    Task(
      id: 3,
      title: 'Call mom',
      category: 'Family',
      icon: Icons.phone,
      startTime: TimeOfDay(hour: 20, minute: 0),
      duration: const Duration(minutes: 30),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _calculateCurrentWeek();
    _selectedDay = _focusedDay;
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

  List<Task> _getTasksForDay(DateTime day) {
    // For simplicity, assign all tasks to today
    return _tasks;
  }

  @override
  Widget build(BuildContext context) {
    List<Task> tasksForSelectedDay =
        _selectedDay != null ? _getTasksForDay(_selectedDay!) : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
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
              child: TasksList(tasks: tasksForSelectedDay),
            ),
          ],
        ),
      ),
    );
  }
}
