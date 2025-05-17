import 'package:flutter/material.dart';

class DurationDropdown extends StatelessWidget {
  final int? duration;
  final ValueChanged<int?> onChanged;

  const DurationDropdown({
    super.key,
    required this.duration,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Duration:'),
        const SizedBox(width: 12),
        DropdownButton<int>(
          value: duration,
          hint: const Text('Select'),
          items: [15, 30, 45, 60, 90, 120]
              .map((min) =>
                  DropdownMenuItem(value: min, child: Text('$min min')))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
