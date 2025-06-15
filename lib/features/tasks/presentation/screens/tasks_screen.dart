import 'package:anchor/core/utils/date_utils.dart';
import 'package:anchor/features/tasks/presentation/controllers/task_controller.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_card/empty_task_state.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_list_section.dart';
import 'package:anchor/features/tasks/presentation/widgets/tasks_screen_app_bar.dart';
import 'package:anchor/features/tasks/presentation/widgets/week_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart' show CalendarFormat;

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  DateTime _selectedDay = normalizeDate(DateTime.now());
  final CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    final controller = TaskController(ref, context);
    final todayTasks = controller.getTasksForDay(_selectedDay);

    return Scaffold(
      appBar: TasksScreenAppBar(
        onAddTask: controller.showCreateTaskModal,
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Scrollable content
            Padding(
              padding: const EdgeInsets.only(
                  top: 96), // Adjust this height as needed
              child: todayTasks.isEmpty
                  ? EmptyTaskState(onAdd: controller.showCreateTaskModal)
                  : TaskListSection(
                      selectedDayTasks: todayTasks,
                      onToggleTaskCompletion: controller.toggleTaskCompletion,
                      onToggleSubtaskCompletion:
                          controller.toggleSubtaskCompletion,
                      onLongPress: controller.showEditTaskModal,
                    ),
            ),

            // Positioned Week Calendar on top
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: WeekCalendar(
                selectedDay: _selectedDay,
                calendarFormat: _calendarFormat,
                onDaySelected: (day) => setState(() {
                  _selectedDay = normalizeDate(day);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
