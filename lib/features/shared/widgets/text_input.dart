import 'package:anchor/core/theme/text_sizes.dart';
import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final String text;
  final String label;
  final ValueChanged<String> onTextChanged;

  const TextInput({
    super.key,
    required this.text,
    required this.label,
    required this.onTextChanged,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
    _controller.addListener(() {
      widget.onTextChanged(_controller.text);
    });
  }

  @override
  void didUpdateWidget(covariant TextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text && widget.text != _controller.text) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.text = widget.text;
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontSize: TextSizes.XXL,
            fontWeight: FontWeight.w700,
          ),
      decoration: InputDecoration(
        hintText: widget.label,
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary.withAlpha(150),
              fontSize: TextSizes.XXL,
              fontWeight: FontWeight.w500,
            ),
        isDense: true,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(0),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2.0,
          ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(60),
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
      cursorColor: Theme.of(context).colorScheme.primary,
    );
  }
}
