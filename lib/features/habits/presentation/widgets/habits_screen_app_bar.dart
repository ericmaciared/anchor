import 'package:flutter/material.dart';

class HabitsScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onAddHabit;

  const HabitsScreenAppBar({super.key, required this.onAddHabit});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'good morning.';
    } else if (hour < 18) {
      return 'good afternoon.';
    } else {
      return 'good evening.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(_getGreeting()),
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
