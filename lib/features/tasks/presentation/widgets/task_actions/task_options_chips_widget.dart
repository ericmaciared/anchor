import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/color_opacities.dart';
import 'package:anchor/core/theme/spacing_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_button_widget.dart';
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

    return AdaptiveButtonWidget(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        primaryColor: isActive ? context.colors.primary.withAlpha(ColorOpacities.opacity60) : null,
        onPressed: () {
          HapticService.medium(); // Medium feedback for section toggle
          onToggleSection(section);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon),
            const SizedBox(width: SpacingSizes.s),
            Text(label),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 48, // Fixed height for the scrollable row
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              const SizedBox(width: SpacingSizes.m),
              _buildOptionChip(
                label: 'Time',
                section: 'time',
                icon: Icons.access_time,
                context: context,
              ),
              const SizedBox(width: SpacingSizes.s),
              _buildOptionChip(
                label: 'Duration',
                section: 'duration',
                icon: Icons.timer,
                context: context,
              ),
              const SizedBox(width: SpacingSizes.s),
              _buildOptionChip(
                label: 'Color & Icon',
                section: 'color',
                icon: Icons.palette,
                context: context,
              ),
              const SizedBox(width: SpacingSizes.s),
              _buildOptionChip(
                label: 'Subtasks',
                section: 'subtasks',
                icon: Icons.list,
                context: context,
              ),
              const SizedBox(width: SpacingSizes.s),
              _buildOptionChip(
                label: 'Notifications',
                section: 'notifications',
                icon: Icons.notifications,
                context: context,
              ),
              const SizedBox(width: SpacingSizes.m),
            ],
          ),
        ),
      ),
    );
  }
}
