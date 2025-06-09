import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WeekCalendar extends StatelessWidget {
  final DateTime selectedDay;
  final Function(DateTime) onDaySelected;

  const WeekCalendar({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TableCalendar<TaskModel>(
        focusedDay: selectedDay,
        firstDay: DateTime.utc(now.year - 1, 1, 1),
        lastDay: DateTime.utc(now.year + 1, 12, 31),
        calendarFormat: CalendarFormat.week,
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerVisible: false,
        availableGestures: AvailableGestures.horizontalSwipe,
        selectedDayPredicate: (day) => isSameDay(day, selectedDay),
        onDaySelected: (selected, _) => onDaySelected(selected),
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.black87,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
