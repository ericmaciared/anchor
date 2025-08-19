import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerWidget extends StatefulWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  final List<Color> _defaultColors = [
    Colors.blue,
    Colors.pink,
    Colors.green,
    Colors.orange,
    Colors.yellow,
    Colors.red,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.brown,
  ];

  Color? _customColor;

  List<Color> get _colorOptions {
    final colors = [..._defaultColors];

    // If the selected color is not in default and not already added, prepend it
    if (!colors.contains(widget.selectedColor)) {
      colors.insert(0, widget.selectedColor);
    }

    return colors;
  }

  void _openCustomColorPicker() {
    HapticService.medium(); // Medium feedback for opening custom picker

    Color tempColor = _customColor ?? context.colors.onSurface.withAlpha(100);

    DialogHelper.showCustom(
      context: context,
      title: 'Select a Custom Color',
      content: StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ColorPicker(
              pickerColor: tempColor,
              onColorChanged: (color) {
                HapticService.light(); // Light feedback for color changes
                setState(() {
                  tempColor = color;
                });
              },
              enableAlpha: false,
              labelTypes: [],
              pickerAreaHeightPercent: 0.7,
              displayThumbColor: true,
              pickerAreaBorderRadius: BorderRadius.circular(8),
              paletteType: PaletteType.hslWithHue,
            ),
          );
        },
      ),
      primaryActionText: 'Select',
      secondaryActionText: 'Cancel',
      onPrimaryAction: () {
        HapticService.medium(); // Selection confirmation feedback
        setState(() => _customColor = tempColor);
        widget.onColorSelected(tempColor);
        Navigator.of(context).pop();
      },
      onSecondaryAction: () {
        HapticService.light(); // Cancel feedback
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildColorCircle(Color color) {
    final isSelected = color == widget.selectedColor;

    return GestureDetector(
      onTap: () {
        HapticService.selection(); // Selection feedback for color pick
        widget.onColorSelected(color);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: isSelected
            ? const Center(
                child: Icon(
                  Icons.check,
                  size: 18,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildAddCustomButton() {
    return GestureDetector(
      onTap: _openCustomColorPicker,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: context.colors.onSurface.withAlpha(100)),
        ),
        child: Center(
          child: Icon(Icons.add, size: 18, color: context.colors.onSurface.withAlpha(100)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task Color',
          style: context.textStyles.titleMedium,
        ),
        const SizedBox(height: 8),
        Card(
          color: context.colors.surfaceContainerHigh,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAddCustomButton(),
                  ..._colorOptions.map(_buildColorCircle),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
