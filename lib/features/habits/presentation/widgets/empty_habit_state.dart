import 'package:anchor/features/shared/quotes/presentation/widgets/daily_quote_card.dart';
import 'package:flutter/material.dart';

class EmptyHabitState extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyHabitState({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: onAdd,
          child: const Text('Add Habit'),
        ),
        DailyQuoteCard()
      ],
    );
  }
}
