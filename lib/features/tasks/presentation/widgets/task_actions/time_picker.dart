import 'package:flutter/material.dart';

class TimePicker extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay> onPick;

  const TimePicker({
    super.key,
    required this.selectedTime,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            selectedTime == null
                ? 'Start time: Not set'
                : 'Start time: ${selectedTime!.format(context)}',
          ),
        ),
        TextButton(
          onPressed: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: selectedTime ?? TimeOfDay.now(),
            );
            if (picked != null) {
              onPick(picked);
            }
          },
          child: const Text('Pick Time'),
        ),
      ],
    );
  }
}
