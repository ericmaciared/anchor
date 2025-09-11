import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_card_widget.dart';
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AdaptiveCardWidget(
        effectIntensity: 10,
        borderRadius: 16,
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: TableCalendar<TaskModel>(
          focusedDay: selectedDay,
          firstDay: DateTime.utc(now.year - 1, 1, 1),
          lastDay: DateTime.utc(now.year + 1, 12, 31),
          calendarFormat: calendarFormat,
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerVisible: false,
          availableGestures: AvailableGestures.horizontalSwipe,
          selectedDayPredicate: (day) => isSameDay(day, selectedDay),
          onDaySelected: (selected, _) => onDaySelected(selected),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: context.colors.onSurface,
            ),
            weekendStyle: TextStyle(
              color: context.colors.onSurface,
            ),
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: context.colors.surfaceContainerHighest.withAlpha(150),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: context.colors.primary.withAlpha(150),
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(color: context.colors.onPrimaryContainer),
          ),
        ),
      ),
    );
  }
}
