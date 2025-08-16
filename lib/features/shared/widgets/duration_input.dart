import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_button_widget.dart';
import 'package:anchor/core/widgets/regular_button_widget.dart';
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
        HapticService.light(); // Light feedback for opening duration picker
        await _showDurationPickerDialog(context);
      },
      child: Text(
        duration != null ? '${duration.toString()} mins' : 'Set duration',
        style: context.textStyles.bodyMedium!.copyWith(
          color: context.colors.primary,
          fontSize: TextSizes.XXL,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Future<void> _showDurationPickerDialog(BuildContext context) async {
    TextEditingController customDurationController = TextEditingController(
      text: !predefinedDurations.contains(duration) && duration != null ? duration.toString() : '',
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
                    return RegularButtonWidget(
                      width: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      onPressed: () {
                        HapticService.selection(); // Selection feedback
                        onDurationChanged(d);
                        Navigator.of(dialogContext).pop();
                      },
                      backgroundColor: duration == d ? context.colors.primary.withAlpha(80) : null,
                      child: Text('$d mins'),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // TODO: Redo without material feel
                TextField(
                  controller: customDurationController,
                  decoration: const InputDecoration(
                    labelText: 'Custom Duration (minutes)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  onSubmitted: (value) {
                    final int? customMin = int.tryParse(value);
                    if (customMin != null && customMin > 0) {
                      HapticService.selection(); // Selection feedback
                      onDurationChanged(customMin);
                      Navigator.of(dialogContext).pop();
                    } else {
                      HapticService.error(); // Error feedback for invalid input
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AdaptiveButtonWidget(
                  onPressed: () {
                    HapticService.light(); // Cancel feedback
                    Navigator.of(dialogContext).pop();
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Cancel'),
                ),
                AdaptiveButtonWidget(
                  onPressed: () {
                    final int? customMin = int.tryParse(customDurationController.text);
                    if (customMin != null && customMin > 0) {
                      HapticService.selection(); // Selection feedback
                      onDurationChanged(customMin);
                      Navigator.of(dialogContext).pop();
                    } else {
                      HapticService.error(); // Error feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid positive number for custom duration.')),
                      );
                    }
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Set Custom'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
