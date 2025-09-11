import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:flutter/material.dart';

class IconPicker extends StatelessWidget {
  final IconData selectedIcon;
  final void Function(IconData) onIconSelected;

  const IconPicker({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  static const Map<String, List<IconData>> _iconCategories = {
    'Work': [
      Icons.work,
      Icons.business_center,
      Icons.apartment,
      Icons.meeting_room,
      Icons.engineering,
    ],
    'Health & Fitness': [
      Icons.fitness_center,
      Icons.self_improvement,
      Icons.healing,
      Icons.directions_run,
      Icons.local_hospital,
    ],
    'Study & Learning': [
      Icons.book,
      Icons.menu_book,
      Icons.school,
      Icons.science,
      Icons.cast_for_education,
    ],
    'Shopping & Food': [
      Icons.shopping_cart,
      Icons.shopping_bag,
      Icons.store,
      Icons.fastfood,
      Icons.local_dining,
    ],
    'Music & Entertainment': [
      Icons.music_note,
      Icons.library_music,
      Icons.queue_music,
      Icons.movie,
      Icons.tv,
    ],
    'Pets & Animals': [
      Icons.pets,
      Icons.cruelty_free,
      Icons.nature,
      Icons.bug_report,
    ],
    'Travel & Outdoors': [
      Icons.directions_car,
      Icons.flight,
      Icons.hiking,
      Icons.landscape,
      Icons.map,
    ],
    'Home & Life': [
      Icons.home,
      Icons.bed,
      Icons.kitchen,
      Icons.cleaning_services,
      Icons.lightbulb,
    ],
    'Others': [
      Icons.star_border,
      Icons.favorite_border,
      Icons.lightbulb_outline,
      Icons.alarm,
      Icons.settings,
    ],
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: _iconCategories.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: context.textStyles.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        GridView.count(
                          crossAxisCount: 5,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          children: entry.value.map((icon) {
                            final isSelected = icon == selectedIcon;
                            return GestureDetector(
                              onTap: () {
                                HapticService.selection(); // Selection feedback for icon pick
                                onIconSelected(icon);
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isSelected ? context.colors.primary.withAlpha(12) : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  icon,
                                  color: isSelected ? context.colors.primary : Theme.of(context).iconTheme.color,
                                  size: 28,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
