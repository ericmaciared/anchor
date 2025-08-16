import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:flutter/material.dart';

class TaskOptionsChips extends StatelessWidget {
  final Map<String, bool> expandedSections;
  final ValueChanged<String> onToggleSection;

  const TaskOptionsChips({
    super.key,
    required this.expandedSections,
    required this.onToggleSection,
  });

  Widget _buildOptionChip({
    required String label,
    required String section,
    required IconData icon,
    required BuildContext context,
  }) {
    final isActive = expandedSections[section]!;

    return FilterChip(
      label: Text(label),
      avatar: Icon(icon, size: 16),
      selected: isActive,
      onSelected: (_) {
        HapticService.medium(); // Medium feedback for section toggle
        onToggleSection(section);
      },
      selectedColor: Theme.of(context).colorScheme.primary.withAlpha(50),
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Options',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildOptionChip(
              label: 'Time',
              section: 'time',
              icon: Icons.access_time,
              context: context,
            ),
            _buildOptionChip(
              label: 'Duration',
              section: 'duration',
              icon: Icons.timer,
              context: context,
            ),
            _buildOptionChip(
              label: 'Color & Icon',
              section: 'color',
              icon: Icons.palette,
              context: context,
            ),
            _buildOptionChip(
              label: 'Subtasks',
              section: 'subtasks',
              icon: Icons.list,
              context: context,
            ),
            _buildOptionChip(
              label: 'Notifications',
              section: 'notifications',
              icon: Icons.notifications,
              context: context,
            ),
          ],
        ),
      ],
    );
  }
}
