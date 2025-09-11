import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_button_widget.dart';
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
        const SizedBox(
          height: 32,
        ),
        Text('plan your day.',
            style: context.textStyles.titleMedium!.copyWith(
              fontSize: TextSizes.xl,
            )),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AdaptiveButtonWidget(
              primaryColor: context.colors.primary.withAlpha(60),
              padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 8),
              onPressed: onAdd,
              child: Text('Add Task',
                  style: context.textStyles.titleMedium!.copyWith(
                    fontSize: TextSizes.l,
                    color: context.colors.primary,
                  )),
            ),
          ],
        ),
        const SizedBox(
          height: 32,
        ),
        DailyQuoteCard()
      ],
    );
  }
}
