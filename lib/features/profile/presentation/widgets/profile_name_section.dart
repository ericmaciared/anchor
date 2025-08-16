import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/widgets/adaptive_button_widget.dart';
import 'package:anchor/core/widgets/adaptive_card_widget.dart';
import 'package:anchor/features/shared/settings/settings_provider.dart';
import 'package:anchor/features/shared/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileNameSection extends ConsumerStatefulWidget {
  final String profileName;
  final Color onSurfaceColor;

  const ProfileNameSection({
    super.key,
    required this.profileName,
    required this.onSurfaceColor,
  });

  @override
  ConsumerState<ProfileNameSection> createState() => _ProfileNameSectionState();
}

class _ProfileNameSectionState extends ConsumerState<ProfileNameSection> {
  bool _isEditing = false;
  late String _currentName;

  @override
  void initState() {
    super.initState();
    _currentName = widget.profileName;
  }

  void _toggleEditing() {
    HapticService.light();
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Save the name when stopping edit
        if (_currentName.trim().isNotEmpty && _currentName != widget.profileName) {
          ref.read(settingsProvider.notifier).updateProfileName(_currentName);
        } else {
          // Revert if empty or no change
          _currentName = widget.profileName;
        }
      }
    });
  }

  void _onNameChanged(String newName) {
    setState(() {
      _currentName = newName;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return AdaptiveCardWidget(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextInput(
              text: _currentName,
              label: 'Your name',
              onTextChanged: _onNameChanged,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AdaptiveButtonWidget(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  onPressed: () {
                    setState(() {
                      _currentName = widget.profileName;
                      _isEditing = false;
                    });
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: TextSizes.M,
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                AdaptiveButtonWidget(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  onPressed: _currentName.trim().isNotEmpty ? _toggleEditing : null,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: TextSizes.M,
                      color: _currentName.trim().isNotEmpty
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface.withAlpha(100),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: _toggleEditing,
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.profileName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: widget.onSurfaceColor,
                    ),
              ),
            ),
            Icon(
              Icons.edit_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
            ),
          ],
        ),
      ),
    );
  }
}
