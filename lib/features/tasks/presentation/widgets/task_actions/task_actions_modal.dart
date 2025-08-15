import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/features/shared/widgets/duration_input.dart';
import 'package:anchor/features/shared/widgets/text_input.dart';
import 'package:anchor/features/shared/widgets/time_input.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/color_picker.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/footer_actions.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/icon_picker.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/notification_configurator.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/subtask_editor.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TaskActionsModal extends StatefulWidget {
  final DateTime taskDay;
  final TaskModel? initialTask;
  final void Function(TaskModel task) onSubmit;
  final void Function(TaskModel task)? onDelete;

  const TaskActionsModal({
    super.key,
    required this.taskDay,
    this.initialTask,
    required this.onSubmit,
    this.onDelete,
  });

  @override
  State<TaskActionsModal> createState() => _TaskActionsModalState();
}

class _TaskActionsModalState extends State<TaskActionsModal> with TickerProviderStateMixin {
  late TaskModel _task;
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _showTimePicker = false;
  bool _showDurationSelector = false;
  bool _showColorPicker = false;
  bool _showSubtaskEditor = false;
  bool _showNotificationConfigurator = false;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    final day = widget.initialTask?.startTime ?? widget.taskDay;
    _task = widget.initialTask ??
        TaskModel(
          id: const Uuid().v4(),
          title: '',
          isDone: false,
          day: DateTime(day.year, day.month, day.day),
          startTime: null,
          duration: null,
          color: Colors.blue,
          icon: Icons.check_circle_outline,
          subtasks: [],
          notifications: [],
        );

    // Initialize visibility based on existing task data
    _showTimePicker = _task.startTime != null;
    _showDurationSelector = _task.duration != null;
    _showColorPicker = false;
    _showSubtaskEditor = _task.subtasks.isNotEmpty;
    _showNotificationConfigurator = _task.notifications.isNotEmpty;

    // Start animations
    _slideController.forward();
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_task.title.trim().isEmpty) return;

    // Add a subtle scale animation on submit
    _scaleController.reverse().then((_) {
      widget.onSubmit(_task);
      Navigator.of(context).pop();
    });
  }

  void _toggleOption(String option) {
    setState(() {
      switch (option) {
        case 'time':
          _showTimePicker = !_showTimePicker;
          if (!_showTimePicker) {
            _task = _task.copyWith(startTime: null);
          }
          break;
        case 'duration':
          _showDurationSelector = !_showDurationSelector;
          if (!_showDurationSelector) {
            _task = _task.copyWith(duration: null);
          }
          break;
        case 'color':
          _showColorPicker = !_showColorPicker;
          break;
        case 'subtasks':
          _showSubtaskEditor = !_showSubtaskEditor;
          break;
        case 'notifications':
          _showNotificationConfigurator = !_showNotificationConfigurator;
          break;
      }
    });
  }

  Widget _buildAnimatedSection(Widget child, {bool visible = true}) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
        child: visible ? child : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildFloatingChip({
    required String label,
    required VoidCallback onPressed,
    required bool isActive,
    IconData? icon,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 250),
      tween: Tween<double>(begin: 1.0, end: isActive ? 1.02 : 1.0),
      curve: Curves.easeInOutCubic,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(24),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Theme.of(context).colorScheme.primary.withAlpha(25)
                        : Theme.of(context).colorScheme.surfaceContainerHigh.withAlpha(200),
                    borderRadius: BorderRadius.circular(24),
                    border: isActive
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary.withAlpha(80),
                            width: 1.5,
                          )
                        : Border.all(
                            color: Theme.of(context).colorScheme.outline.withAlpha(30),
                            width: 1,
                          ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.primary.withAlpha(20),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: 16,
                          color: isActive
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface.withAlpha(160),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        label,
                        style: TextStyle(
                          color: isActive
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface.withAlpha(180),
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialTask != null;

    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.85,
            minChildSize: 0.5,
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
                    // Drag handle
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(60),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: controller,
                        padding: const EdgeInsets.only(
                          top: 24,
                          left: 20,
                          right: 20,
                        ),
                        children: [
                          // Header with icon
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _task.color.withAlpha(30),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _task.icon,
                                  color: _task.color,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  isEdit ? 'edit task' : 'new task',
                                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                        fontSize: TextSizes.XXL,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Main task input
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline.withAlpha(30),
                              ),
                            ),
                            child: Wrap(
                              spacing: 8,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  'Today, I will ',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: TextSizes.L),
                                ),
                                SizedBox(
                                  width: _task.title.isEmpty ? 140 : (_task.title.length + 2) * 12,
                                  child: TextInput(
                                    text: _task.title,
                                    label: 'task name',
                                    onTextChanged: (text) => setState(() => _task = _task.copyWith(title: text)),
                                  ),
                                ),
                                if (_showTimePicker) ...[
                                  Text(
                                    'at ',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: TextSizes.L),
                                  ),
                                  TimeInput(
                                    time: _task.startTime != null
                                        ? TimeOfDay(hour: _task.startTime!.hour, minute: _task.startTime!.minute)
                                        : TimeOfDay.now(),
                                    onTimeChanged: (time) {
                                      setState(() => _task = _task.copyWith(
                                          startTime: time != null
                                              ? DateTime(
                                                  widget.taskDay.year,
                                                  widget.taskDay.month,
                                                  widget.taskDay.day,
                                                  time.hour,
                                                  time.minute,
                                                )
                                              : null));
                                    },
                                  ),
                                ],
                                if (_showDurationSelector) ...[
                                  Text(
                                    'for ',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: TextSizes.L),
                                  ),
                                  DurationInput(
                                      duration: _task.duration != null
                                          ? _task.duration!.inMinutes
                                          : const Duration(minutes: 15).inMinutes,
                                      onDurationChanged: (min) => setState(() => _task =
                                          _task.copyWith(duration: min != null ? Duration(minutes: min) : null)))
                                ],
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Options section
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
                              _buildFloatingChip(
                                label: _showTimePicker ? 'Remove Time' : 'Add Time',
                                icon: Icons.access_time,
                                isActive: _showTimePicker,
                                onPressed: () => _toggleOption('time'),
                              ),
                              _buildFloatingChip(
                                label: _showDurationSelector ? 'Remove Duration' : 'Add Duration',
                                icon: Icons.timer,
                                isActive: _showDurationSelector,
                                onPressed: () => _toggleOption('duration'),
                              ),
                              _buildFloatingChip(
                                label: 'Color & Icon',
                                icon: Icons.palette,
                                isActive: _showColorPicker,
                                onPressed: () => _toggleOption('color'),
                              ),
                              _buildFloatingChip(
                                label: 'Subtasks',
                                icon: Icons.list,
                                isActive: _showSubtaskEditor,
                                onPressed: () => _toggleOption('subtasks'),
                              ),
                              _buildFloatingChip(
                                label: 'Notifications',
                                icon: Icons.notifications,
                                isActive: _showNotificationConfigurator,
                                onPressed: () => _toggleOption('notifications'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Expandable sections
                          _buildAnimatedSection(
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ColorPickerWidget(
                                      selectedColor: _task.color,
                                      onColorSelected: (color) => setState(() => _task = _task.copyWith(color: color)),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    children: [
                                      Text(
                                        'Icon',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(color: Theme.of(context).colorScheme.onSurface.withAlpha(100)),
                                      ),
                                      const SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (_) => IconPicker(
                                              selectedIcon: _task.icon,
                                              onIconSelected: (icon) =>
                                                  setState(() => _task = _task.copyWith(icon: icon)),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: _task.color.withAlpha(30),
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: _task.color.withAlpha(100),
                                            ),
                                          ),
                                          child: Icon(_task.icon, color: _task.color, size: 28),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            visible: _showColorPicker,
                          ),

                          _buildAnimatedSection(
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: SubtaskEditor(
                                subtasks: _task.subtasks,
                                onChanged: (subtasks) => setState(() => _task = _task.copyWith(subtasks: subtasks)),
                              ),
                            ),
                            visible: _showSubtaskEditor,
                          ),

                          _buildAnimatedSection(
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: NotificationConfigurator(
                                notifications: _task.notifications,
                                taskStartTime: _task.startTime,
                                onChanged: (notifications) =>
                                    setState(() => _task = _task.copyWith(notifications: notifications)),
                              ),
                            ),
                            visible: _showNotificationConfigurator,
                          ),
                        ],
                      ),
                    ),

                    // Footer with enhanced styling
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border(
                          top: BorderSide(
                            color: Theme.of(context).colorScheme.outline.withAlpha(30),
                          ),
                        ),
                      ),
                      child: FooterActions(
                        isEdit: isEdit,
                        isSaveEnabled: _task.title.trim().isNotEmpty,
                        onDelete: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: Text('Confirm Deletion',
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: TextSizes.XL)),
                              content: Text('Are you sure you want to delete this task?',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: TextSizes.M)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(dialogContext).pop(false),
                                  child: Text(
                                    'Cancel',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: TextSizes.M),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(dialogContext).pop(true),
                                  child: Text(
                                    'Delete',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontSize: TextSizes.M, color: Theme.of(context).colorScheme.error),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if ((confirmed ?? false) && widget.onDelete != null) {
                            widget.onDelete!(widget.initialTask!);
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
          ),
        ),
      ),
    );
  }
}
