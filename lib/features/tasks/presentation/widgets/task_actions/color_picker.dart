import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    const colorOptions = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
    ];

    return Row(
      children: [
        const Text('Color:'),
        const SizedBox(width: 12),
        ...colorOptions.map((color) {
          final isSelected = color == selectedColor;
          return GestureDetector(
            onTap: () => onColorSelected(color),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isSelected ? 30 : 30,
              height: isSelected ? 30 : 30,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(
                        color: Colors.black,
                        width: 2,
                      )
                    : null,
              ),
            ),
          );
        }),
      ],
    );
  }
}
