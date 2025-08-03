import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/features/shared/quotes/presentation/widgets/daily_quote_card.dart';
import 'package:flutter/material.dart';

class EmptyTaskState extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyTaskState({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: onAdd,
          child: Text('Add Task',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: TextSizes.L,
                    color: Theme.of(context).colorScheme.primary,
                  )),
        ),
        const SizedBox(
          height: 8,
        ),
        DailyQuoteCard()
      ],
    );
  }
}
