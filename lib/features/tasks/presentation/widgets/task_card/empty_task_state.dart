import 'package:anchor/features/shared/quotes/presentation/widgets/daily_quote_card.dart';
import 'package:flutter/material.dart';

class EmptyTaskState extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyTaskState({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: onAdd,
            child: const Text('Add Task'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: DailyQuoteCard(),
          ),
        ],
      ),
    );
  }
}
