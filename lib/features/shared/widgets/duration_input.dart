import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_dialog_widget.dart'; // Add this import
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

    await DialogHelper.showCustom(
      context: context,
      title: 'Select Duration',
      content: StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
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
                        Navigator.of(context).pop();
                      },
                      backgroundColor: duration == d ? context.colors.primary.withAlpha(80) : null,
                      child: Text('$d mins'),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: context.colors.outline.withAlpha(50),
                    ),
                  ),
                  child: TextField(
                    controller: customDurationController,
                    decoration: InputDecoration(
                      labelText: 'Custom Duration (minutes)',
                      labelStyle: TextStyle(
                        color: context.colors.onSurface.withAlpha(150),
                        fontSize: TextSizes.M,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(
                      color: context.colors.onSurface,
                      fontSize: TextSizes.M,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    onSubmitted: (value) {
                      final int? customMin = int.tryParse(value);
                      if (customMin != null && customMin > 0) {
                        HapticService.selection(); // Selection feedback
                        onDurationChanged(customMin);
                        Navigator.of(context).pop();
                      } else {
                        HapticService.error(); // Error feedback for invalid input
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      primaryActionText: 'Set Custom',
      secondaryActionText: 'Cancel',
      onPrimaryAction: () {
        final int? customMin = int.tryParse(customDurationController.text);
        if (customMin != null && customMin > 0) {
          HapticService.selection(); // Selection feedback
          onDurationChanged(customMin);
          Navigator.of(context).pop();
        } else {
          HapticService.error(); // Error feedback
          // Show error using adaptive dialog
          DialogHelper.showError(
            context: context,
            title: 'Invalid Duration',
            message: 'Please enter a valid positive number for custom duration.',
          );
        }
      },
      onSecondaryAction: () {
        HapticService.light(); // Cancel feedback
        Navigator.of(context).pop();
      },
    );
  }
}
