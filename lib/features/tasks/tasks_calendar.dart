import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TasksCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final DateTime firstDayOfWeek;
  final DateTime lastDayOfWeek;
  final Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final Function(DragEndDetails details) onHorizontalDragEnd;

  const TasksCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.firstDayOfWeek,
    required this.lastDayOfWeek,
    required this.onDaySelected,
    required this.onHorizontalDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: onHorizontalDragEnd,
      child: TableCalendar(
        firstDay: firstDayOfWeek,
        lastDay: lastDayOfWeek,
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        calendarFormat: CalendarFormat.week,
        startingDayOfWeek: StartingDayOfWeek.monday,
        onDaySelected: onDaySelected,
        headerVisible: false,
        calendarStyle: const CalendarStyle(),
        daysOfWeekStyle: const DaysOfWeekStyle(),
      ),
    );
  }
}
