import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:flutter/material.dart';

import 'minimal_time_picker_widget.dart';

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
    final result = await showMinimalTimePicker(
      context: context,
      initialTime: time,
      is24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
    );

    // Apply the result if user didn't cancel
    if (result != null) {
      onTimeChanged(result);
    }
  }
}
