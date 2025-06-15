import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay?> onPick;

  const TimePicker({
    super.key,
    required this.selectedTime,
    required this.onPick,
  });

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  bool get _hasTime => widget.selectedTime != null;

  late int _selectedHour;
  late int _selectedMinute;

  @override
  void initState() {
    super.initState();
    final initial = widget.selectedTime ?? TimeOfDay.now();
    _selectedHour = initial.hour;
    _selectedMinute = initial.minute;
  }

  void _selectTime() {
    final time = TimeOfDay(hour: _selectedHour, minute: _selectedMinute);
    widget.onPick(time);
  }

  void _clearTime() {
    widget.onPick(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'When?',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(100)),
        ),
        const SizedBox(height: 12),
        if (!_hasTime)
          OutlinedButton.icon(
            onPressed: () => widget.onPick(TimeOfDay.now()),
            icon: const Icon(Icons.add),
            label: const Text('Add time'),
          ),
        if (_hasTime) ...[
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _selectedHour,
                  decoration: const InputDecoration(labelText: 'Hour'),
                  items: List.generate(24, (i) {
                    return DropdownMenuItem(
                      value: i,
                      child: Text(i.toString().padLeft(2, '0')),
                    );
                  }),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedHour = val);
                      _selectTime();
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _selectedMinute,
                  decoration: const InputDecoration(labelText: 'Minute'),
                  items: List.generate(60, (i) {
                    return DropdownMenuItem(
                      value: i,
                      child: Text(i.toString().padLeft(2, '0')),
                    );
                  }),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedMinute = val);
                      _selectTime();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Remove time',
                icon: const Icon(Icons.clear),
                onPressed: _clearTime,
              ),
            ],
          ),
        ],
      ],
    );
  }
}
