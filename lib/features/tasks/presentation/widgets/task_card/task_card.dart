import 'package:anchor/core/mixins/safe_animation_mixin.dart';
import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/widgets/adaptive_dialog_widget.dart';
import 'package:anchor/features/tasks/domain/entities/subtask_model.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:flutter/material.dart';

import 'task_expanded_actions.dart';
import 'task_header_row.dart';
import 'task_progress_bar.dart';
import 'task_time_column.dart';

class TaskCard extends StatefulWidget {
  final TaskModel task;
  final VoidCallback onLongPress;
  final VoidCallback onToggleTaskCompletion;
  final void Function(SubtaskModel subtask) onToggleSubtaskCompletion;

  const TaskCard({
    super.key,
    required this.task,
    required this.onLongPress,
    required this.onToggleTaskCompletion,
    required this.onToggleSubtaskCompletion,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> with TickerProviderStateMixin, SafeAnimationMixin {
  late final AnimationController _expansionController;
  late final AnimationController _completionController;
  late final Animation<double> _expansionAnimation;
  late final Animation<double> _completionAnimation;

  bool _isExpanded = false;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Expansion animation for when card is tapped
    _expansionController = createController(
      duration: const Duration(milliseconds: 250),
      debugLabel: 'TaskCard_Expansion',
    );

    // Completion animation for visual feedback
    _completionController = createController(
      duration: const Duration(milliseconds: 150),
      debugLabel: 'TaskCard_Completion',
    );

    _expansionAnimation = CurvedAnimation(
      parent: _expansionController,
      curve: Curves.easeInOut,
    );

    _completionAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _completionController,
      curve: Curves.easeInOut,
    ));

    // Set initial state based on task completion
    if (widget.task.isDone) {
      _completionController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(TaskCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle task completion state changes
    if (oldWidget.task.isDone != widget.task.isDone) {
      _handleCompletionStateChange();
    }
  }

  void _handleCompletionStateChange() {
    safeAnimate(_completionController, () async {
      if (widget.task.isDone) {
        await _completionController.forward();
      } else {
        await _completionController.reverse();
      }
    });
  }

  void _toggleExpanded() {
    if (_isAnimating) return;

    // Add haptic feedback for card expansion
    HapticService.medium();

    safSetState(() {
      _isExpanded = !_isExpanded;
      _isAnimating = true;
    });

    safeAnimate(_expansionController, () async {
      if (_isExpanded) {
        await _expansionController.forward();
      } else {
        await _expansionController.reverse();
      }

      safSetState(() {
        _isAnimating = false;
      });
    });
  }

  Future<void> _handleTaskCompletion() async {
    // Add success haptic feedback for task completion
    HapticService.success();

    // Close expansion first
    if (_isExpanded) {
      safSetState(() => _isExpanded = false);

      await safeAnimate(_expansionController, () async {
        await _expansionController.reverse();
      });
    }

    // Then trigger completion
    widget.onToggleTaskCompletion();
  }

  Future<void> _showUndoConfirmationDialog(BuildContext context) async {
    if (!mounted) return;

    final confirmed = await DialogHelper.showUndoConfirmation(
      context: context,
      action: 'completion',
      customMessage: 'Are you sure you want to undo this task completion?',
    );

    if (confirmed && mounted) {
      widget.onToggleTaskCompletion();
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _completionAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _completionAnimation.value,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TaskTimeColumn(
                      startTime: task.startTime,
                      duration: task.duration,
                    ),
                    const SizedBox(width: 8),
                    Builder(
                      builder: (context) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 50,
                            maxHeight: constraints.maxHeight,
                          ),
                          child: TaskProgressBar(color: task.color),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    // Main task card
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: GestureDetector(
                          onTap: _isAnimating ? null : _toggleExpanded,
                          onLongPress: () {
                            HapticService.longPress(); // Long press feedback
                            widget.onLongPress();
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TaskHeaderRow(task: task),
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                  child: AnimatedBuilder(
                                    animation: _expansionAnimation,
                                    builder: (context, child) {
                                      return SizeTransition(
                                        sizeFactor: _expansionAnimation,
                                        child: _isExpanded
                                            ? TaskExpandedActions(
                                                task: task,
                                                onComplete: _handleTaskCompletion,
                                                showUndoDialog: () => _showUndoConfirmationDialog(context),
                                                onUndoComplete: widget.onToggleTaskCompletion,
                                                onToggleSubtaskCompletion: (subtask) =>
                                                    widget.onToggleSubtaskCompletion(subtask),
                                              )
                                            : const SizedBox.shrink(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
