import 'package:anchor/features/shared/widgets/text_input.dart';
import 'package:flutter/material.dart';

import '../../tasks/presentation/widgets/task_actions/icon_picker.dart';

class IconAndTitle extends StatefulWidget {
  final IconData selectedIcon;
  final String title;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<IconData> onIconChanged;

  const IconAndTitle({
    super.key,
    required this.selectedIcon,
    required this.title,
    required this.onTitleChanged,
    required this.onIconChanged,
  });

  @override
  State<IconAndTitle> createState() => _IconAndTitleState();
}

class _IconAndTitleState extends State<IconAndTitle> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.title);
    _controller.addListener(() {
      widget.onTitleChanged(_controller.text);
    });
  }

  @override
  void didUpdateWidget(covariant IconAndTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.title != oldWidget.title && widget.title != _controller.text) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.text = widget.title;
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openIconPicker() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => IconPicker(
        selectedIcon: widget.selectedIcon,
        onIconSelected: widget.onIconChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What?',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(100)),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            IconButton(
              icon: Icon(widget.selectedIcon, size: 28),
              onPressed: _openIconPicker,
            ),
            const SizedBox(width: 12),
            Expanded(
                child: TextInput(
              text: widget.title,
              label: 'Task Name',
              onTextChanged: (text) => widget.onTitleChanged(text),
            )),
          ],
        ),
      ],
    );
  }
}
