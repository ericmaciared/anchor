import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_button_widget.dart';
import 'package:flutter/material.dart';

class MinimalTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final bool is24HourFormat;

  const MinimalTimePicker({
    super.key,
    required this.initialTime,
    required this.onTimeChanged,
    this.is24HourFormat = true,
  });

  @override
  State<MinimalTimePicker> createState() => _MinimalTimePickerState();
}

class _MinimalTimePickerState extends State<MinimalTimePicker> {
  late TimeOfDay _selectedTime;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
    _hourController = FixedExtentScrollController(
      initialItem: widget.is24HourFormat ? _selectedTime.hour : _selectedTime.hourOfPeriod,
    );
    _minuteController = FixedExtentScrollController(
      initialItem: _selectedTime.minute,
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  List<int> get _hours {
    if (widget.is24HourFormat) {
      return List.generate(24, (index) => index);
    } else {
      return List.generate(12, (index) => index == 0 ? 12 : index);
    }
  }

  List<int> get _minutes {
    return List.generate(60, (index) => index);
  }

  void _updateTime({int? hour, int? minute, DayPeriod? period}) {
    int newHour = hour ?? _selectedTime.hour;
    int newMinute = minute ?? _selectedTime.minute;

    if (!widget.is24HourFormat && hour != null) {
      if (period == DayPeriod.pm && hour != 12) {
        newHour = hour + 12;
      } else if (period == DayPeriod.am && hour == 12) {
        newHour = 0;
      } else if (period != null) {
        // Handle AM/PM toggle without hour change
        if (period == DayPeriod.pm && _selectedTime.hour < 12) {
          newHour = _selectedTime.hour + 12;
        } else if (period == DayPeriod.am && _selectedTime.hour >= 12) {
          newHour = _selectedTime.hour - 12;
        }
      }
    }

    setState(() {
      _selectedTime = TimeOfDay(hour: newHour, minute: newMinute);
    });

    widget.onTimeChanged(_selectedTime);
  }

  Widget _buildTimeWheel({
    required List<int> items,
    required FixedExtentScrollController controller,
    required String label,
    required ValueChanged<int> onSelectedItemChanged,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: context.textStyles.bodySmall?.copyWith(
            color: context.colors.onSurface.withAlpha(150),
            fontSize: TextSizes.s,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 160,
          width: 80,
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.colors.outline.withAlpha(50),
            ),
          ),
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 40,
            perspective: 0.005,
            diameterRatio: 1.2,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              HapticService.light();
              onSelectedItemChanged(items[index]);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                if (index < 0 || index >= items.length) return null;

                final value = items[index];
                final isSelected = index == controller.selectedItem;

                return Container(
                  alignment: Alignment.center,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: context.textStyles.titleLarge!.copyWith(
                      fontSize: isSelected ? TextSizes.xl : TextSizes.l,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? context.colors.primary : context.colors.onSurface.withAlpha(120),
                    ),
                    child: Text(
                      value.toString().padLeft(2, '0'),
                    ),
                  ),
                );
              },
              childCount: items.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmPmToggle() {
    if (widget.is24HourFormat) return const SizedBox.shrink();

    final period = _selectedTime.period;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Period',
          style: context.textStyles.bodySmall?.copyWith(
            color: context.colors.onSurface.withAlpha(150),
            fontSize: TextSizes.s,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.colors.outline.withAlpha(50),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPeriodButton('AM', period == DayPeriod.am, () {
                _updateTime(period: DayPeriod.am);
              }),
              Container(
                height: 1,
                color: context.colors.outline.withAlpha(30),
              ),
              _buildPeriodButton('PM', period == DayPeriod.pm, () {
                _updateTime(period: DayPeriod.pm);
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodButton(String text, bool isSelected, VoidCallback onTap) {
    return AdaptiveButtonWidget(
      width: 60,
      height: 40,
      borderRadius: 0,
      enableHaptics: false,
      primaryColor: isSelected ? context.colors.primary.withAlpha(30) : null,
      onPressed: () {
        HapticService.selection();
        onTap();
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: TextSizes.m,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? context.colors.primary : context.colors.onSurface.withAlpha(150),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Time display
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: context.colors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _selectedTime.format(context),
              style: context.textStyles.headlineMedium?.copyWith(
                fontSize: TextSizes.xxxl,
                fontWeight: FontWeight.w700,
                color: context.colors.primary,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Time wheels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeWheel(
                items: _hours,
                controller: _hourController,
                label: 'Hour',
                onSelectedItemChanged: (hour) {
                  _updateTime(hour: hour);
                },
              ),

              // Separator
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Text(
                  ':',
                  style: context.textStyles.headlineLarge?.copyWith(
                    color: context.colors.onSurface.withAlpha(150),
                    fontSize: TextSizes.xxl,
                  ),
                ),
              ),

              _buildTimeWheel(
                items: _minutes,
                controller: _minuteController,
                label: 'Minute',
                onSelectedItemChanged: (minute) {
                  _updateTime(minute: minute);
                },
              ),

              if (!widget.is24HourFormat) ...[
                const SizedBox(width: 16),
                _buildAmPmToggle(),
              ],
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Time picker dialog wrapper
class TimePickerDialog extends StatelessWidget {
  final TimeOfDay initialTime;
  final bool is24HourFormat;

  const TimePickerDialog({
    super.key,
    required this.initialTime,
    this.is24HourFormat = true,
  });

  @override
  Widget build(BuildContext context) {
    TimeOfDay selectedTime = initialTime;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Time',
                    style: context.textStyles.headlineMedium?.copyWith(
                      fontSize: TextSizes.xl,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Time picker content
            MinimalTimePicker(
              initialTime: initialTime,
              is24HourFormat: is24HourFormat,
              onTimeChanged: (time) {
                selectedTime = time;
              },
            ),

            // Actions
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: context.colors.outline.withAlpha(50),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AdaptiveButtonWidget(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    enableHaptics: false,
                    onPressed: () {
                      HapticService.light();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: TextSizes.m,
                        color: context.colors.onSurface.withAlpha(150),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  AdaptiveButtonWidget(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    primaryColor: context.colors.primary.withAlpha(30),
                    enableHaptics: false,
                    onPressed: () {
                      HapticService.medium();
                      Navigator.of(context).pop(selectedTime);
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: TextSizes.m,
                        fontWeight: FontWeight.w600,
                        color: context.colors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper function to show the time picker
Future<TimeOfDay?> showMinimalTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  bool is24HourFormat = true,
}) async {
  return showDialog<TimeOfDay>(
    context: context,
    builder: (context) => TimePickerDialog(
      initialTime: initialTime,
      is24HourFormat: is24HourFormat,
    ),
  );
}
