import 'package:anchor/core/utils/date_utils.dart';
import 'package:anchor/core/widgets/adaptive_snackbar_widget.dart';
import 'package:anchor/core/widgets/scroll_fade_overlay_widget.dart';
import 'package:anchor/features/tasks/presentation/controllers/task_controller.dart';
import 'package:anchor/features/tasks/presentation/widgets/empty_task_state.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_list_section.dart';
import 'package:anchor/features/tasks/presentation/widgets/tasks_screen_app_bar.dart';
import 'package:anchor/features/tasks/presentation/widgets/week_calendar.dart';
import 'package:anchor/features/welcome/tutorial/tutorial_launcher.dart';
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
  final List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    super.initState();

    // Check and show tutorial if this is the first time user visits the tasks screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        TutorialLauncher.checkAndShowTutorialIfNeeded(context: context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = TaskController(ref, context);
    final todayTasks = controller.getTasksForDay(_selectedDay);

    return ScrollFadeOverlayPresets.appBar(
      child: Stack(
        children: [
          todayTasks.isEmpty
              ? EmptyTaskState(onAdd: () => controller.showCreateTaskModal(taskDay: _selectedDay))
              : TaskListSection(
                  selectedDay: _selectedDay,
                  selectedDayTasks: todayTasks,
                  onToggleTaskCompletion: controller.toggleTaskCompletion,
                  onToggleSubtaskCompletion: controller.toggleSubtaskCompletion,
                  onLongPress: controller.showEditTaskModal,
                ),
          Positioned(
            top: 120,
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
      appBar: TasksScreenAppBar(
        onAddTask: () => controller.showCreateTaskModal(taskDay: _selectedDay),
        onTodayPressed: () => setState(() {
          final now = DateTime.now();
          _selectedDay = normalizeDate(now);
          context.showInfoSnackbar(
            'Today is the ${now.day} of ${monthNames[now.month - 1]}',
          );
        }),
      ),
    );
  }
}
