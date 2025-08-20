import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_button_widget.dart';
import 'package:anchor/core/widgets/adaptive_dialog_widget.dart';
import 'package:anchor/features/shared/notifications/notification_id_generator.dart';
import 'package:anchor/features/shared/widgets/minimal_time_picker_widget.dart';
import 'package:anchor/features/tasks/domain/entities/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NotificationConfigurator extends StatefulWidget {
  final List<NotificationModel> notifications;
  final DateTime? taskStartTime;
  final ValueChanged<List<NotificationModel>> onChanged;

  const NotificationConfigurator({
    super.key,
    required this.notifications,
    required this.onChanged,
    required this.taskStartTime,
  });

  @override
  State<NotificationConfigurator> createState() => _NotificationConfiguratorState();
}

class _NotificationConfiguratorState extends State<NotificationConfigurator> {
  static const int maxAdvanceHours = 24; // Maximum hours before task start
  final _customController = TextEditingController();

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  bool _isValidAdvanceTime(int minutesBefore) {
    return minutesBefore <= (maxAdvanceHours * 60);
  }

  String _getAdvanceTimeError(int minutesBefore) {
    if (minutesBefore > (maxAdvanceHours * 60)) {
      return 'Notifications cannot be more than $maxAdvanceHours hours in advance';
    }
    return '';
  }

  Future<void> _addNotification(int minutesBefore) async {
    final taskStart = widget.taskStartTime;
    if (taskStart == null) {
      _showError('No task start time set');
      return;
    }

    if (!_isValidAdvanceTime(minutesBefore)) {
      _showError(_getAdvanceTimeError(minutesBefore));
      return;
    }

    final scheduledTime = taskStart.subtract(Duration(minutes: minutesBefore));

    // Check if notification time is in the past
    if (scheduledTime.isBefore(DateTime.now())) {
      _showError('Cannot schedule notifications in the past');
      return;
    }

    final safeId = await NotificationIdGenerator.next();

    final newNotification = NotificationModel(
      id: safeId,
      taskId: 't',
      triggerType: 'minutesBefore',
      triggerValue: minutesBefore,
      scheduledTime: scheduledTime,
    );

    final updatedList = [...widget.notifications, newNotification];
    widget.onChanged(updatedList);

    setState(() {
      _customController.clear();
    });

    HapticService.success();
  }

  Future<void> _addCustomTimeNotification() async {
    final taskStart = widget.taskStartTime;
    if (taskStart == null) {
      _showError('No task start time set');
      return;
    }

    final result = await showMinimalTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(taskStart),
      is24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
    );

    if (result == null) return;

    final scheduledTime = DateTime(
      taskStart.year,
      taskStart.month,
      taskStart.day,
      result.hour,
      result.minute,
    );

    // Check if notification time is in the past
    if (scheduledTime.isBefore(DateTime.now())) {
      _showError('Cannot schedule notifications in the past');
      return;
    }

    // Check if notification is too far in advance
    final difference = taskStart.difference(scheduledTime);
    if (difference.inHours > maxAdvanceHours) {
      _showError('Notifications cannot be more than $maxAdvanceHours hours in advance');
      return;
    }

    final safeId = await NotificationIdGenerator.next();

    final newNotification = NotificationModel(
      id: safeId,
      taskId: 't',
      triggerType: 'customTime',
      triggerValue: 0,
      scheduledTime: scheduledTime,
    );

    final updatedList = [...widget.notifications, newNotification];
    widget.onChanged(updatedList);

    HapticService.success();
  }

  void _removeNotification(NotificationModel entry) {
    final updatedList = widget.notifications.where((n) => n.id != entry.id).toList();
    widget.onChanged(updatedList);
    HapticService.medium();
  }

  void _showError(String message) {
    HapticService.error();
    DialogHelper.showError(
      context: context,
      title: 'Invalid Notification',
      message: message,
    );
  }

  String _formatNotification(NotificationModel entry) {
    final formattedTime = DateFormat.Hm().format(entry.scheduledTime);

    if (entry.triggerType == 'customTime') {
      return formattedTime;
    }

    if (entry.triggerValue == 0) {
      return 'At start ($formattedTime)';
    }

    final value = entry.triggerValue;
    if (value >= 60) {
      final hours = value ~/ 60;
      final minutes = value % 60;
      if (minutes == 0) {
        return '${hours}h before ($formattedTime)';
      } else {
        return '${hours}h ${minutes}m before ($formattedTime)';
      }
    }

    return '${value}m before ($formattedTime)';
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colors.outline.withAlpha(30),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: context.colors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.notifications_outlined,
              size: 16,
              color: context.colors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _formatNotification(notification),
              style: context.textStyles.bodyMedium?.copyWith(
                fontSize: TextSizes.M,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          AdaptiveButtonWidget(
            width: 32,
            height: 32,
            borderRadius: 16,
            enableHaptics: false,
            onPressed: () => _removeNotification(notification),
            child: Icon(
              Icons.close,
              size: 16,
              color: context.colors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickOption({
    required String label,
    required int minutes,
    required IconData icon,
  }) {
    final isValid = _isValidAdvanceTime(minutes);

    return AdaptiveButtonWidget(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 12,
      primaryColor: isValid ? null : context.colors.error.withAlpha(20),
      border: isValid ? null : Border.all(color: context.colors.error.withAlpha(50)),
      enableHaptics: false,
      onPressed: isValid ? () => _addNotification(minutes) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: isValid ? context.colors.primary : context.colors.error,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: TextSizes.S,
              fontWeight: FontWeight.w500,
              color: isValid ? context.colors.onSurface : context.colors.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.taskStartTime?.toIso8601String());
    final hasNotifications = widget.notifications.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.notifications_outlined,
              size: 20,
              color: context.colors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Notifications',
              style: context.textStyles.titleMedium?.copyWith(
                fontSize: TextSizes.L,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (widget.taskStartTime == null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHigh.withAlpha(100),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.colors.outline.withAlpha(30),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: context.colors.onSurface.withAlpha(150),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Set a start time to enable notifications',
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.colors.onSurface.withAlpha(150),
                      fontSize: TextSizes.S,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          const SizedBox(height: 16),

          // Current notifications
          if (hasNotifications) ...[
            ...widget.notifications.map(_buildNotificationItem),
            const SizedBox(height: 16),
          ],

          // Quick options
          Text(
            'Quick Options',
            style: context.textStyles.bodyMedium?.copyWith(
              fontSize: TextSizes.M,
              fontWeight: FontWeight.w600,
              color: context.colors.onSurface.withAlpha(150),
            ),
          ),
          const SizedBox(height: 12),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1.2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              _buildQuickOption(
                label: 'At start',
                minutes: 0,
                icon: Icons.play_arrow,
              ),
              _buildQuickOption(
                label: '5 min\nbefore',
                minutes: 5,
                icon: Icons.schedule,
              ),
              _buildQuickOption(
                label: '15 min\nbefore',
                minutes: 15,
                icon: Icons.access_time,
              ),
              _buildQuickOption(
                label: '30 min\nbefore',
                minutes: 30,
                icon: Icons.alarm,
              ),
              _buildQuickOption(
                label: '1 hour\nbefore',
                minutes: 60,
                icon: Icons.history,
              ),
              AdaptiveButtonWidget(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                borderRadius: 12,
                primaryColor: context.colors.secondary.withAlpha(30),
                enableHaptics: false,
                onPressed: _addCustomTimeNotification,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_calendar,
                      size: 20,
                      color: context.colors.secondary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Custom\ntime',
                      style: TextStyle(
                        fontSize: TextSizes.S,
                        fontWeight: FontWeight.w500,
                        color: context.colors.secondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Custom minutes input
          Text(
            'Custom Minutes Before',
            style: context.textStyles.bodyMedium?.copyWith(
              fontSize: TextSizes.M,
              fontWeight: FontWeight.w600,
              color: context.colors.onSurface.withAlpha(150),
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.colors.outline.withAlpha(50),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: 'e.g., 45',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintStyle: TextStyle(
                        color: context.colors.onSurface.withAlpha(100),
                        fontSize: TextSizes.M,
                      ),
                    ),
                    style: TextStyle(
                      color: context.colors.onSurface,
                      fontSize: TextSizes.M,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                AdaptiveButtonWidget(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  primaryColor: context.colors.primary.withAlpha(30),
                  borderRadius: 10,
                  enableHaptics: false,
                  onPressed: () {
                    final text = _customController.text.trim();
                    if (text.isEmpty) {
                      HapticService.error();
                      return;
                    }

                    final val = int.tryParse(text);
                    if (val == null || val < 0) {
                      _showError('Please enter a valid positive number');
                      return;
                    }

                    _addNotification(val);
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(
                      fontSize: TextSizes.M,
                      fontWeight: FontWeight.w600,
                      color: context.colors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Info text about limits
          const SizedBox(height: 12),
          Text(
            'Notifications can be scheduled up to $maxAdvanceHours hours in advance',
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.onSurface.withAlpha(120),
              fontSize: TextSizes.S,
            ),
          ),
        ],
      ],
    );
  }
}
