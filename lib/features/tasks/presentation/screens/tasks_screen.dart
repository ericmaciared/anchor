import 'package:anchor/core/utils/date_utils.dart';
import 'package:anchor/features/tasks/presentation/controllers/task_controller.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_card/empty_task_state.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_card/task_list_section.dart';
import 'package:anchor/features/tasks/presentation/widgets/tasks_screen_app_bar.dart';
import 'package:anchor/features/tasks/presentation/widgets/week_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  DateTime _selectedDay = normalizeDate(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final controller = TaskController(ref, context);
    final todayTasks = controller.getTasksForDay(_selectedDay);

    return Scaffold(
      appBar: TasksScreenAppBar(
        onAddTask: controller.showCreateTaskModal,
      ),
      body: SafeArea(
        child: Column(
          children: [
            WeekCalendar(
              selectedDay: _selectedDay,
              onDaySelected: (day) => setState(() {
                _selectedDay = normalizeDate(day);
              }),
            ),
            Expanded(
              child: todayTasks.isEmpty
                  ? EmptyTaskState(onAdd: controller.showCreateTaskModal)
                  : TaskListSection(
                      selectedDayTasks: todayTasks,
                      onComplete: controller.completeTask,
                      onLongPress: controller.showEditTaskModal,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
