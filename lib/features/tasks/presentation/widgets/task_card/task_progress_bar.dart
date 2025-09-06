import 'package:anchor/core/widgets/adaptive_card_widget.dart';
import 'package:flutter/material.dart';

class TaskProgressBar extends StatelessWidget {
  final Color color;

  const TaskProgressBar({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 12,
      child: AdaptiveCardWidget(
        borderRadius: 6,
        primaryColor: color,
        child: Container(),
      ),
    );
  }
}
