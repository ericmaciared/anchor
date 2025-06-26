import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MinimalTaskTimeColumn extends StatelessWidget {
  final DateTime? startTime;
  final Duration? duration;

  const MinimalTaskTimeColumn({super.key, this.startTime, this.duration});

  @override
  Widget build(BuildContext context) {
    if (startTime == null) return const SizedBox.shrink();

    return Text(
      DateFormat('H:mm').format(startTime!),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12),
    );
  }
}
