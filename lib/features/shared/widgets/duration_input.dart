import 'package:anchor/core/theme/text_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DurationInput extends StatelessWidget {
  final int? duration;
  final ValueChanged<int?> onDurationChanged;

  const DurationInput({
    super.key,
    required this.duration,
    required this.onDurationChanged,
  });

  static const List<int> predefinedDurations = [15, 30, 60, 90, 120];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _showDurationPickerDialog(context);
      },
      child: Text(
        duration != null ? '${duration.toString()} mins' : 'Set duration',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontSize: TextSizes.XXL,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  Future<void> _showDurationPickerDialog(BuildContext context) async {
    TextEditingController customDurationController = TextEditingController(
      text: !predefinedDurations.contains(duration) && duration != null
          ? duration.toString()
          : '',
    );

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Select Duration'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: predefinedDurations.map((d) {
                    return ActionChip(
                      label: Text('$d mins'),
                      onPressed: () {
                        onDurationChanged(d);
                        Navigator.of(dialogContext).pop();
                      },
                      backgroundColor: duration == d
                          ? Theme.of(context).colorScheme.primary.withAlpha(20)
                          : null,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: customDurationController,
                  decoration: const InputDecoration(
                    labelText: 'Custom Duration (minutes)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onSubmitted: (value) {
                    final int? customMin = int.tryParse(value);
                    if (customMin != null && customMin > 0) {
                      onDurationChanged(customMin);
                      Navigator.of(dialogContext).pop();
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Set Custom'),
              onPressed: () {
                final int? customMin =
                    int.tryParse(customDurationController.text);
                if (customMin != null && customMin > 0) {
                  onDurationChanged(customMin);
                  Navigator.of(dialogContext).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Please enter a valid positive number for custom duration.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
