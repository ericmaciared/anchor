import 'package:flutter/material.dart';

class HabitsScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onAddHabit;

  const HabitsScreenAppBar({super.key, required this.onAddHabit});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text('habits'),
      scrolledUnderElevation: 0.0,
      actions: [
        IconButton(
          onPressed: onAddHabit,
          tooltip: 'Add Habit',
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
