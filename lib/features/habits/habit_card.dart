import 'package:anchor/features/habits/models/habit_model.dart';
import 'package:flutter/material.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;

  const HabitCard({super.key, required this.habit});

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  void _handleTap() {
    setState(() {
      widget.habit.markDone();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isCustom = widget.habit.type == HabitType.custom;
    final completed = widget.habit.isCompletedToday();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _handleTap,
        onLongPress: isCustom ? _handleTap : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isCustom
              ? _buildCustomCard(context, completed)
              : _buildPredefinedCard(context, completed),
        ),
      ),
    );
  }

  Widget _buildPredefinedCard(BuildContext context, bool completed) {
    return Row(
      children: [
        Icon(widget.habit.icon, size: 32),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            widget.habit.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  decoration: completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
          ),
        ),
        Checkbox(value: completed, onChanged: (_) => _handleTap()),
      ],
    );
  }

  Widget _buildCustomCard(BuildContext context, bool completed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(widget.habit.icon, size: 28),
            const SizedBox(width: 12),
            Text(
              widget.habit.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Streak: ${widget.habit.streak} 🔥'),
            Text('Done: ${widget.habit.counter}x'),
          ],
        ),
      ],
    );
  }
}
