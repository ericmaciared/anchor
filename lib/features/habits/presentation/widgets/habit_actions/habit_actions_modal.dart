import 'package:anchor/core/theme/text_sizes.dart';
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

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialHabit != null;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.only(
                    top: 24,
                    left: 16,
                    right: 16,
                  ),
                  children: [
                    Text(
                      isEdit ? 'edit habit' : 'new habit',
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontSize: TextSizes.XXL,
                              ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 8,
                      children: [
                        Text('I will '),
                        SizedBox(
                          width: 200,
                          child: TextInput(
                            text: _habit.name,
                            label: 'habit name',
                            onTextChanged: (text) => setState(
                                () => _habit = _habit.copyWith(name: text)),
                          ),
                        ),
                        Text('everyday'),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FooterActions(
                  isEdit: isEdit,
                  isSaveEnabled: _habit.name.trim().isNotEmpty,
                  onDelete: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: Text('Confirm Deletion',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: TextSizes.XL)),
                        content: Text(
                            'Are you sure you want to delete this habit?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: TextSizes.M)),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(false),
                            child: Text(
                              'Cancel',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: TextSizes.M,
                                  ),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(true),
                            child: Text(
                              'Delete',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: TextSizes.M,
                                      color:
                                          Theme.of(context).colorScheme.error),
                            ),
                          ),
                        ],
                      ),
                    );

                    if ((confirmed ?? false) && widget.onDelete != null) {
                      widget.onDelete!(widget.initialHabit!);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  onSave: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
