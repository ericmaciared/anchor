import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WeekCalendar extends StatelessWidget {
  final DateTime selectedDay;
  final CalendarFormat calendarFormat;
  final Function(DateTime) onDaySelected;

  const WeekCalendar({
    super.key,
    required this.selectedDay,
    required this.calendarFormat,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        children: [
          TableCalendar<TaskModel>(
            focusedDay: selectedDay,
            firstDay: DateTime.utc(now.year - 1, 1, 1),
            lastDay: DateTime.utc(now.year + 1, 12, 31),
            calendarFormat: calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerVisible: false,
            availableGestures: AvailableGestures.horizontalSwipe,
            selectedDayPredicate: (day) => isSameDay(day, selectedDay),
            onDaySelected: (selected, _) => onDaySelected(selected),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                shape: BoxShape.circle,
              ),
              selectedTextStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          )
        ],
      ),
    );
  }
}
