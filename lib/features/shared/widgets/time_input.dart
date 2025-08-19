import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/widgets/adaptive_dialog_widget.dart';
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
        await _showTimePickerDialog(context);
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

  Future<void> _showTimePickerDialog(BuildContext context) async {
    // Use a StatefulBuilder to manage the selected time state
    TimeOfDay selectedTime = time; // Initialize with current time

    final result = await DialogHelper.showCustom<TimeOfDay>(
      context: context,
      title: 'Select Time',
      content: StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: 350,
            child: showPicker(
              isInlinePicker: true,
              value: Time(
                hour: selectedTime.hour,
                minute: selectedTime.minute,
              ),
              is24HrFormat: true,
              sunrise: const TimeOfDay(hour: 6, minute: 0),
              sunset: const TimeOfDay(hour: 18, minute: 0),
              sunAsset: Image.asset('assets/images/sun.png'),
              moonAsset: Image.asset('assets/images/moon.png'),
              accentColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Colors.transparent,
              hideButtons: true,
              dialogInsetPadding: const EdgeInsets.all(0),
              duskSpanInMinutes: 120,
              onChange: (newTime) {
                HapticService.selection(); // Selection feedback for time change
                setState(() {
                  selectedTime = newTime; // Update the local state
                });
              },
            ),
          );
        },
      ),
      primaryActionText: 'Save',
      secondaryActionText: 'Cancel',
      onPrimaryAction: () {
        Navigator.of(context).pop(selectedTime); // Return the selected time
      },
      onSecondaryAction: () {
        HapticService.light(); // Cancel feedback
        Navigator.of(context).pop(); // Return null
      },
    );

    // Apply the result if user didn't cancel
    if (result != null) {
      onTimeChanged(result);
    }
  }
}
