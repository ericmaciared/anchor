import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
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
    if (_habit.name.trim().isEmpty) return;
    widget.onSubmit(_habit);
    Navigator.of(context).pop();
  }

  void _handleDelete() {
    if (widget.onDelete != null) {
      widget.onDelete!(_habit);
      Navigator.of(context).pop();
    }
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Confirm Deletion',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: TextSizes.XL,
                  ),
            ),
            content: Text(
              'Are you sure you want to delete this habit?',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: TextSizes.M,
                  ),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: TextSizes.M,
                      ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Delete',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: TextSizes.M,
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _handleDeleteWithConfirmation(BuildContext context) async {
    final confirmed = await _showDeleteConfirmation(context);
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
              color: Colors.black.withAlpha(20),
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

                    const SizedBox(height: 20),
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
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.colors.onSurface.withAlpha(50),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 24),

          // Header with icon and title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.colors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.anchor,
                  color: context.colors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  isEdit ? 'Edit Habit' : 'New Habit',
                  style: context.textStyles.headlineMedium!.copyWith(
                    fontSize: TextSizes.XXL,
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colors.outline.withAlpha(50),
        ),
      ),
      child: Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'I will ',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: TextSizes.L,
                ),
          ),
          SizedBox(
            width: _habit.name.isEmpty ? 140 : (_habit.name.length + 2) * 12,
            child: TextInput(
              text: _habit.name,
              label: 'habit name',
              onTextChanged: (text) => setState(
                () => _habit = _habit.copyWith(name: text),
              ),
            ),
          ),
          Text(
            'everyday',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: TextSizes.L,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isEdit) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withAlpha(50),
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
