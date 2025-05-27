import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskTimeColumn extends StatelessWidget {
  final DateTime? startTime;
  final Duration? duration;

  const TaskTimeColumn({super.key, this.startTime, this.duration});

  @override
  Widget build(BuildContext context) {
    if (startTime == null) return const SizedBox.shrink();
    final endTime = startTime!.add(duration ?? Duration.zero);

    return SizedBox(
      width: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(DateFormat('HH:mm').format(startTime!),
              textAlign: TextAlign.center),
          if (duration != null)
            Text(DateFormat('HH:mm').format(endTime),
                textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
