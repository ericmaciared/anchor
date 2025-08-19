import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/features/shared/widgets/minimal_time_picker_widget.dart';
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

        final result = await showMinimalTimePicker(
          context: context,
          initialTime: currentTime,
          is24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
        );

        if (result != null) {
          updateFunction(result);
        }
      },
    );
  }
}
