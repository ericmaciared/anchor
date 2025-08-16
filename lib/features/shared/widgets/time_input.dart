import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';

class TimeInput extends StatelessWidget {
  final TimeOfDay time;
  final ValueChanged<TimeOfDay?> onTimeChanged;

  const TimeInput({
    super.key,
    required this.time,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        HapticService.light(); // Light feedback for opening time picker

        Navigator.of(context).push(
          showPicker(
            context: context,
            value: Time(
              hour: time.hour,
              minute: time.minute,
            ),
            is24HrFormat: true,
            sunrise: TimeOfDay(hour: 6, minute: 0),
            sunset: TimeOfDay(hour: 18, minute: 0),
            sunAsset: Image.asset('assets/images/sun.png'),
            moonAsset: Image.asset('assets/images/moon.png'),
            accentColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
            okText: 'Save',
            duskSpanInMinutes: 120,
            onChange: (selectedTime) {
              HapticService.selection(); // Selection feedback for time change
              onTimeChanged(selectedTime);
            },
          ),
        );
      },
      child: Text(
        '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontSize: TextSizes.XXL,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
