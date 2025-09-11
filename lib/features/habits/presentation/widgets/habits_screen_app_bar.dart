import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/widgets/adaptive_button_widget.dart';
import 'package:flutter/material.dart';

class HabitsScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAddHabit;

  const HabitsScreenAppBar({super.key, required this.onAddHabit});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('habits', style: TextStyle(fontSize: TextSizes.xl)),
            AdaptiveButtonWidget(
              height: 36,
              width: 36,
              onPressed: onAddHabit,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
