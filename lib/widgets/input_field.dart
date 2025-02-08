import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputWidget extends StatefulWidget {
  final String? hintText;
  final String? errorText;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final bool? enabled;
  final Widget? icon;
  final Widget? iconLeft;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final TextEditingController controller;
  final BuildContext context;

  const InputWidget({
    super.key,
    this.hintText,
    this.errorText,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.enabled = true,
    this.icon,
    this.iconLeft,
    this.keyboardType,
    this.onChanged,
    this.maxLength,
    this.maxLines,
    this.minLines,
    required this.controller,
    required this.context,
  });

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        keyboardType = widget.keyboardType ?? TextInputType.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor ?? Colors.transparent,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SizedBox(
        child: TextField(
          controller: widget.controller,
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(widget.controller.text);
            }
          },
          enabled: widget.enabled,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines ?? 1,
          minLines: widget.minLines ?? 1,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: widget.textColor,
            decorationColor: widget.textColor,
          ),
          decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: widget.maxLines != null ? 8 : 0,
              bottom: widget.maxLines != null ? 8 : 0,
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(
                color: widget.textColor?.withOpacity(0.7) ?? Colors.grey,
                decorationColor: widget.textColor?.withOpacity(0.7) ?? Colors.grey),
            errorText: widget.errorText,
            fillColor: widget.backgroundColor ?? Theme.of(context).colorScheme.background,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: widget.icon,
            prefixIcon: widget.iconLeft,
          ),
        ),
      ),
    );
  }
}
