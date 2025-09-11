import 'package:anchor/core/theme/color_opacities.dart';
import 'package:anchor/core/theme/spacing_sizes.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/notification_configurator.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/subtask_editor.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/task_color_icon_section_widget.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/task_input_section_widget.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/task_modal_footer_widget.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/task_modal_header_widget.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/task_options_chips_widget.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'expandable_section_widget.dart';

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

class _TaskActionsModalState extends State<TaskActionsModal> {
  late TaskModel _task;

  // Track which sections are expanded
  final Map<String, bool> _expandedSections = {
    'time': false,
    'duration': false,
    'color': false,
    'subtasks': false,
    'notifications': false,
  };

  @override
  void initState() {
    super.initState();
    _initializeTask();
    _setInitialExpansionStates();
  }

  void _initializeTask() {
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
  }

  void _setInitialExpansionStates() {
    _expandedSections['time'] = _task.startTime != null;
    _expandedSections['duration'] = _task.duration != null;
    _expandedSections['subtasks'] = _task.subtasks.isNotEmpty;
    _expandedSections['notifications'] = _task.notifications.isNotEmpty;
  }

  void _toggleSection(String section) {
    setState(() {
      _expandedSections[section] = !_expandedSections[section]!;

      // Handle data initialization/clearing when toggling sections
      switch (section) {
        case 'time':
          if (_expandedSections[section]!) {
            // When enabling time section, set a default start time if none exists
            if (_task.startTime == null) {
              final now = DateTime.now();
              final defaultTime = DateTime(
                widget.taskDay.year,
                widget.taskDay.month,
                widget.taskDay.day,
                now.hour,
                now.minute,
              );
              _task = _task.copyWith(startTime: defaultTime);
            }
          } else {
            // When disabling time section, clear the start time
            _task = _task.copyWith(clearStartTime: true, startTime: null);
          }
          break;

        case 'duration':
          if (_expandedSections[section]!) {
            // When enabling duration section, set a default duration if none exists
            if (_task.duration == null) {
              _task = _task.copyWith(duration: const Duration(minutes: 30));
            }
          } else {
            // When disabling duration section, clear the duration
            _task = _task.copyWith(clearDuration: true, duration: null);
          }
          break;
      }
    });
  }

  void _updateTask(TaskModel updatedTask) {
    setState(() {
      _task = updatedTask;
    });
  }

  void _submit() {
    if (_task.title.trim().isEmpty) return;
    widget.onSubmit(_task);
    Navigator.of(context).pop();
  }

  void _handleDelete() {
    if (widget.onDelete != null) {
      widget.onDelete!(_task);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialTask != null;

    return DraggableScrollableSheet(
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
              TaskModalHeader(
                task: _task,
                isEdit: isEdit,
              ),

              // Content
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                  children: [
                    // Task input section
                    TaskInputSection(
                      task: _task,
                      taskDay: widget.taskDay,
                      showTimePicker: _expandedSections['time']!,
                      showDurationSelector: _expandedSections['duration']!,
                      onTaskChanged: _updateTask,
                    ),

                    const SizedBox(height: SpacingSizes.l),

                    // Expandable sections
                    ExpandableSection(
                      isExpanded: _expandedSections['color']!,
                      child: TaskColorIconSection(
                        task: _task,
                        onTaskChanged: _updateTask,
                      ),
                    ),

                    ExpandableSection(
                      isExpanded: _expandedSections['subtasks']!,
                      child: SubtaskEditor(
                        taskId: _task.id, // Pass the task ID here
                        subtasks: _task.subtasks,
                        onChanged: (subtasks) {
                          _updateTask(_task.copyWith(subtasks: subtasks));
                        },
                      ),
                    ),

                    ExpandableSection(
                      isExpanded: _expandedSections['notifications']!,
                      child: NotificationConfigurator(
                        notifications: _task.notifications,
                        taskStartTime: _task.startTime,
                        onChanged: (notifications) {
                          _updateTask(_task.copyWith(notifications: notifications));
                        },
                      ),
                    ),

                    const SizedBox(height: SpacingSizes.m),
                  ],
                ),
              ),

              // Options chips
              TaskOptionsChips(
                expandedSections: _expandedSections,
                onToggleSection: _toggleSection,
              ),
              const SizedBox(height: SpacingSizes.m),

              // Footer
              TaskModalFooter(
                task: _task,
                isEdit: isEdit,
                onSave: _submit,
                onDelete: isEdit ? _handleDelete : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
