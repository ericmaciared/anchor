import 'package:anchor/features/shared/notifications/notification_id_generator.dart';
import 'package:anchor/features/tasks/domain/entities/notification_model.dart';
import 'package:flutter/material.dart';
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
  State<NotificationConfigurator> createState() =>
      _NotificationConfiguratorState();
}

class _NotificationConfiguratorState extends State<NotificationConfigurator> {
  final List<int> predefinedOptions = [0, 5, 10, 15, 30, 60];
  int? _selectedValue;
  final _customController = TextEditingController();

  void _addNotification(int minutesBefore) async {
    final taskStart = widget.taskStartTime;
    if (taskStart == null) return;

    final scheduledTime = taskStart.subtract(Duration(minutes: minutesBefore));

    final safeId = await NotificationIdGenerator.next();

    final newNotification = NotificationModel(
      id: safeId,
      taskId: 't',
      notificationId: DateTime.now().millisecondsSinceEpoch,
      triggerType: 'minutesBefore',
      triggerValue: minutesBefore,
      scheduledTime: scheduledTime,
    );

    final updatedList = [...widget.notifications, newNotification];
    widget.onChanged(updatedList);

    setState(() {
      _selectedValue = null;
      _customController.clear();
    });
  }

  void _removeNotification(NotificationModel entry) {
    final updatedList =
        widget.notifications.where((n) => n.id != entry.id).toList();
    widget.onChanged(updatedList);
  }

  String _formatNotification(NotificationModel entry) {
    final formattedTime = DateFormat.Hm().format(entry.scheduledTime);
    if (entry.triggerValue == 0) return 'At start time ($formattedTime)';
    return '${entry.triggerValue} min before ($formattedTime)';
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notifications', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (widget.notifications.isNotEmpty)
          ...widget.notifications.map(
            (n) => ListTile(
              dense: true,
              title: Text(_formatNotification(n)),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _removeNotification(n),
              ),
            ),
          ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          value: _selectedValue,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Add notification',
          ),
          items: [
            ...predefinedOptions.map(
              (min) => DropdownMenuItem(
                value: min,
                child: Text(min == 0 ? 'At start time' : '$min min before'),
              ),
            ),
            const DropdownMenuItem(
              value: -1,
              child: Text('Custom minutes before'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
            if (value != null && value >= 0) {
              _addNotification(value);
            }
          },
        ),
        if (_selectedValue == -1) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Minutes before task',
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  final val = int.tryParse(_customController.text);
                  if (val != null && val >= 0) {
                    _addNotification(val);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
