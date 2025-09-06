import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:flutter/material.dart';

enum TextInputVariant {
  primary, // For main titles, large text (existing style)
  secondary, // For subtasks, smaller inputs
  outlined, // For forms with visible borders
}

class TextInput extends StatefulWidget {
  final String text;
  final String label;
  final ValueChanged<String> onTextChanged;
  final TextInputVariant variant;
  final bool autofocus;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final Color? backgroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool enabled;

  const TextInput({
    super.key,
    required this.text,
    required this.label,
    required this.onTextChanged,
    this.variant = TextInputVariant.primary,
    this.autofocus = false,
    this.maxLines = 1,
    this.textInputAction,
    this.onEditingComplete,
    this.focusNode,
    this.textAlign = TextAlign.center,
    this.contentPadding,
    this.backgroundColor,
    this.fontSize,
    this.fontWeight,
    this.enabled = true,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isLocalFocusNode = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
    _controller.addListener(() {
      widget.onTextChanged(_controller.text);
    });

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _isLocalFocusNode = true;
    }
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
    if (_isLocalFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  TextStyle _getTextStyle(BuildContext context) {
    switch (widget.variant) {
      case TextInputVariant.primary:
        return Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontSize: widget.fontSize ?? TextSizes.XXL,
              fontWeight: widget.fontWeight ?? FontWeight.w700,
            );
      case TextInputVariant.secondary:
        return Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: context.colors.onSurface,
              fontSize: widget.fontSize ?? TextSizes.M,
              fontWeight: widget.fontWeight ?? FontWeight.w500,
            );
      case TextInputVariant.outlined:
        return Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: context.colors.onSurface,
              fontSize: widget.fontSize ?? TextSizes.M,
              fontWeight: widget.fontWeight ?? FontWeight.w500,
            );
    }
  }

  TextStyle _getHintStyle(BuildContext context) {
    switch (widget.variant) {
      case TextInputVariant.primary:
        return Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary.withAlpha(150),
              fontSize: widget.fontSize ?? TextSizes.XXL,
              fontWeight: widget.fontWeight ?? FontWeight.w500,
            );
      case TextInputVariant.secondary:
        return Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: context.colors.onSurface.withAlpha(100),
              fontSize: widget.fontSize ?? TextSizes.M,
              fontWeight: widget.fontWeight ?? FontWeight.w400,
            );
      case TextInputVariant.outlined:
        return Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: context.colors.onSurface.withAlpha(120),
              fontSize: widget.fontSize ?? TextSizes.M,
              fontWeight: widget.fontWeight ?? FontWeight.w400,
            );
    }
  }

  InputDecoration _getDecoration(BuildContext context) {
    switch (widget.variant) {
      case TextInputVariant.primary:
        return InputDecoration(
          hintText: widget.label,
          hintStyle: _getHintStyle(context),
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
          contentPadding: widget.contentPadding ?? EdgeInsets.zero,
          filled: widget.backgroundColor != null,
          fillColor: widget.backgroundColor,
        );
      case TextInputVariant.secondary:
        return InputDecoration(
          hintText: widget.label,
          hintStyle: _getHintStyle(context),
          isDense: true,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          filled: widget.backgroundColor != null,
          fillColor: widget.backgroundColor,
        );
      case TextInputVariant.outlined:
        return InputDecoration(
          hintText: widget.label,
          hintStyle: _getHintStyle(context),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: context.colors.outline.withAlpha(50),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: context.colors.outline.withAlpha(50),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: context.colors.primary,
              width: 1.5,
            ),
          ),
          contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          filled: true,
          fillColor: widget.backgroundColor ?? context.colors.surfaceContainerHigh,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      textAlign: widget.textAlign,
      style: _getTextStyle(context),
      decoration: _getDecoration(context),
      cursorColor: Theme.of(context).colorScheme.primary,
      autofocus: widget.autofocus,
      maxLines: widget.maxLines,
      textInputAction: widget.textInputAction,
      onEditingComplete: widget.onEditingComplete,
      enabled: widget.enabled,
    );
  }
}
