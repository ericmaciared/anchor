import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: LiquidGlass(
        glassContainsChild: false,
        settings: LiquidGlassSettings(
          ambientStrength: 1,
          blur: 20,
        ),
        shape: LiquidRoundedSuperellipse(borderRadius: Radius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
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
                color: Theme.of(context).colorScheme.onSurface,
              ),
              weekendStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withAlpha(150),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(150),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
          ),
        ),
      ),
    );
  }
}
