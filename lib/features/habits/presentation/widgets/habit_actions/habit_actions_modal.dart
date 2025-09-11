import 'package:anchor/core/theme/color_opacities.dart';
import 'package:anchor/core/theme/spacing_sizes.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_dialog_widget.dart'; // Add this import
import 'package:anchor/core/widgets/adaptive_snackbar_widget.dart';
import 'package:anchor/features/habits/domain/entities/habit_model.dart';
import 'package:anchor/features/shared/widgets/text_input.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/footer_actions.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class HabitActionsModal extends StatefulWidget {
  final HabitModel? initialHabit;
  final void Function(HabitModel habit) onSubmit;
  final void Function(HabitModel habit)? onDelete;

  const HabitActionsModal({
    super.key,
    this.initialHabit,
    required this.onSubmit,
    this.onDelete,
  });

  @override
  State<HabitActionsModal> createState() => _HabitActionsModalState();
}

class _HabitActionsModalState extends State<HabitActionsModal> {
  late HabitModel _habit;

  @override
  void initState() {
    super.initState();
    _habit = widget.initialHabit ??
        HabitModel(
          id: const Uuid().v4(),
          name: '',
          isSelected: true,
          isCustom: true,
          currentStreak: 0,
          lastCompletedDate: null,
        );
  }

  void _submit() {
    final trimmedName = _habit.name.trim();
    if (trimmedName.isEmpty) {
      context.showErrorSnackbar('Habit name cannot be empty');
      return;
    }
    if (trimmedName.length > 50) {
      context.showErrorSnackbar('Habit name too long (max 50 characters)');
      return;
    }

    _habit = _habit.copyWith(name: trimmedName);

    widget.onSubmit(_habit);
    Navigator.of(context).pop();
  }

  void _handleDelete() {
    if (widget.onDelete != null) {
      widget.onDelete!(_habit);
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleDeleteWithConfirmation(BuildContext context) async {
    final confirmed = await DialogHelper.showDeleteConfirmation(
      context: context,
      itemName: _habit.name.isNotEmpty ? _habit.name : 'this habit',
    );

    if (confirmed) {
      _handleDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialHabit != null;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(ColorOpacities.opacity10),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Header
              _buildHeader(context, isEdit),

              // Content
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                  children: [
                    // Habit input section
                    _buildHabitInputSection(context),

                    const SizedBox(height: SpacingSizes.m),
                  ],
                ),
              ),

              // Footer
              _buildFooter(context, isEdit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: SpacingSizes.s),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.colors.onSurface.withAlpha(ColorOpacities.opacity20),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: SpacingSizes.l),

          // Header with icon and title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(SpacingSizes.s),
                decoration: BoxDecoration(
                  color: context.colors.primary.withAlpha(ColorOpacities.opacity10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.anchor,
                  color: context.colors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: SpacingSizes.m),
              Expanded(
                child: Text(
                  isEdit ? 'Edit Habit' : 'New Habit',
                  style: context.textStyles.headlineMedium!.copyWith(
                    fontSize: TextSizes.xxl,
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

  Widget _buildHabitInputSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpacingSizes.m),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colors.outline.withAlpha(ColorOpacities.opacity20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First row with "I will" text
          Text(
            'I will',
            style: context.textStyles.bodyMedium!.copyWith(
              fontSize: TextSizes.xxl, // Match the input text size
              fontWeight: FontWeight.w700, // Match the input weight
              color: context.colors.onSurface,
            ),
          ),
          const SizedBox(height: SpacingSizes.xs),
          // Full width text input
          TextInput(
            text: _habit.name,
            label: 'habit name',
            fontSize: TextSizes.xxl, // Explicit font size
            fontWeight: FontWeight.w700, // Match other elements
            textAlign: TextAlign.left,
            onTextChanged: (text) => setState(
              () => _habit = _habit.copyWith(name: text),
            ),
          ),
          const SizedBox(height: SpacingSizes.xs),
          // "everyday" text
          Text(
            'everyday',
            style: context.textStyles.bodyMedium!.copyWith(
              fontSize: TextSizes.xxl, // Match the input text size
              fontWeight: FontWeight.w700, // Match the input weight
              color: context.colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isEdit) {
    return Container(
      padding: const EdgeInsets.all(SpacingSizes.m),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: context.colors.outline.withAlpha(ColorOpacities.opacity20),
          ),
        ),
      ),
      child: FooterActions(
        isEdit: isEdit,
        isSaveEnabled: _habit.name.trim().isNotEmpty,
        onDelete: () => _handleDeleteWithConfirmation(context),
        onSave: _submit,
      ),
    );
  }
}
