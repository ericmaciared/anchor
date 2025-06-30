// You can put this in a new file, e.g., 'time_setting_tile.dart'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeSettingTile extends ConsumerWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final TimeOfDay currentTime;
  final Function(TimeOfDay) updateFunction;

  const TimeSettingTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.currentTime,
    required this.updateFunction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: const TextStyle(fontSize: 12)),
      trailing: Text(currentTime.format(context)),
      onTap: () async {
        final newTime = await showTimePicker(
          context: context,
          initialTime: currentTime,
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );
        if (newTime != null) {
          updateFunction(newTime);
        }
      },
    );
  }
}
