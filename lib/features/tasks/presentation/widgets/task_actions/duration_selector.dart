import 'package:anchor/core/theme/color_opacities.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:flutter/material.dart';

class DurationSelector extends StatelessWidget {
  final int? duration;
  final ValueChanged<int?> onChanged;

  const DurationSelector({
    super.key,
    required this.duration,
    required this.onChanged,
  });

  static const predefinedDurations = [15, 30, 60, 90, 120];

  bool get _isCustom => duration != null && !predefinedDurations.contains(duration);

  @override
  Widget build(BuildContext context) {
    // Combine predefined and custom durations
    final allDurations = {
      ...predefinedDurations,
      if (_isCustom) duration!,
    }.toList()
      ..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How long?',
          style: context.textStyles.titleMedium!
              .copyWith(color: context.colors.onSurface.withAlpha(ColorOpacities.opacity40)),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: const Text('No duration'),
              selected: duration == null,
              onSelected: (_) => onChanged(null),
            ),
            ...allDurations.map((d) => ChoiceChip(
                  label: Text('$d min'),
                  selected: duration == d,
                  onSelected: (_) => onChanged(d),
                )),
            ActionChip(
              avatar: const Icon(Icons.add, size: 16),
              label: const Text('Custom'),
              onPressed: () async {
                final customValue = await _showCustomDurationDialog(context);
                if (customValue != null && customValue > 0) {
                  onChanged(customValue);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<int?> _showCustomDurationDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom Duration'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Duration in minutes',
            hintText: 'Enter number of minutes',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text.trim());
              Navigator.of(context).pop(value);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
