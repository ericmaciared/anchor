import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
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

class _ProfileNameSectionState extends ConsumerState<ProfileNameSection> with SingleTickerProviderStateMixin {
  bool _isEditing = false;
  late String _currentName;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _currentName = widget.profileName;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    HapticService.light();
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _animationController.forward();
      } else {
        _animationController.reverse();
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

  void _cancelEdit() {
    HapticService.light();
    setState(() {
      _currentName = widget.profileName;
      _isEditing = false;
    });
    _animationController.reverse();
  }

  void _saveEdit() {
    if (_currentName.trim().isNotEmpty) {
      HapticService.success();
      _toggleEditing();
    } else {
      HapticService.error();
    }
  }

  void _onNameChanged(String newName) {
    setState(() {
      _currentName = newName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveCardWidget(
      padding: const EdgeInsets.all(24.0),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with greeting and edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Welcome back',
                style: context.textStyles.bodyMedium?.copyWith(
                  fontSize: TextSizes.M,
                  color: context.colors.onSurface.withAlpha(150),
                ),
              ),
              if (!_isEditing)
                AdaptiveButtonWidget(
                  width: 36,
                  height: 36,
                  borderRadius: 18,
                  enableHaptics: false,
                  onPressed: _toggleEditing,
                  child: Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: context.colors.primary,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Name display/edit section
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _isEditing ? _buildEditingView() : _buildDisplayView(),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayView() {
    return Column(
      key: const ValueKey('display'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _toggleEditing,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              widget.profileName,
              style: context.textStyles.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: TextSizes.XXL,
                color: widget.onSurfaceColor,
                height: 1.2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tap to edit your display name',
          style: context.textStyles.bodySmall?.copyWith(
            fontSize: TextSizes.S,
            color: context.colors.onSurface.withAlpha(100),
          ),
        ),
      ],
    );
  }

  Widget _buildEditingView() {
    return Column(
      key: const ValueKey('editing'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInput(
          text: _currentName,
          label: 'Your name',
          onTextChanged: _onNameChanged,
        ),

        const SizedBox(height: 20),

        // Action buttons
        FadeTransition(
          opacity: _fadeAnimation,
          child: Row(
            children: [
              Expanded(
                child: AdaptiveButtonWidget(
                  height: 44,
                  borderRadius: 22,
                  enableHaptics: false,
                  onPressed: _cancelEdit,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.close,
                        size: 16,
                        color: context.colors.onSurface.withAlpha(150),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: TextSizes.M,
                          color: context.colors.onSurface.withAlpha(150),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AdaptiveButtonWidget(
                  height: 44,
                  borderRadius: 22,
                  enableHaptics: false,
                  primaryColor: _currentName.trim().isNotEmpty ? context.colors.primary.withAlpha(30) : null,
                  enabled: _currentName.trim().isNotEmpty,
                  onPressed: _currentName.trim().isNotEmpty ? _saveEdit : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check,
                        size: 16,
                        color: _currentName.trim().isNotEmpty
                            ? context.colors.primary
                            : context.colors.onSurface.withAlpha(100),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Save',
                        style: TextStyle(
                          fontSize: TextSizes.M,
                          color: _currentName.trim().isNotEmpty
                              ? context.colors.primary
                              : context.colors.onSurface.withAlpha(100),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
