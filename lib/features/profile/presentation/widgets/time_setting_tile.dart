import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeSettingTile extends ConsumerWidget {
  final IconData icon;
  final String title;
  final TimeOfDay currentTime;
  final Function(TimeOfDay) updateFunction;

  const TimeSettingTile({
    super.key,
    required this.icon,
    required this.title,
    required this.currentTime,
    required this.updateFunction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: Text(currentTime.format(context), style: const TextStyle(fontSize: 14)),
      onTap: () async {
        HapticService.light(); // Light feedback for opening time picker
        Navigator.of(context).push(
          showPicker(
            context: context,
            value: Time(
              hour: currentTime.hour,
              minute: currentTime.minute,
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
            onChange: (time) => updateFunction(time),
          ),
        );
      },
    );
  }
}
