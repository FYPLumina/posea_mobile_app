import 'package:flutter/material.dart';

class CustomTextInputField extends StatefulWidget {
  const CustomTextInputField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enablePasswordToggle = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.borderRadius = 16,
    this.filled = true,
    this.fillColor = Colors.white,
    this.borderColor = Colors.grey,
    this.focusedBorderColor = Colors.grey,
    this.lable,
    this.enabled = true,
  });

  final String hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enablePasswordToggle;
  final int maxLines;
  final int minLines;
  final double borderRadius;
  final bool filled;
  final Color fillColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final String? lable;
  final bool enabled;

  @override
  State<CustomTextInputField> createState() => _CustomTextInputFieldState();
}

class _CustomTextInputFieldState extends State<CustomTextInputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? suffixIcon = widget.suffixIcon;

    // Add password toggle button if enabled
    if (widget.enablePasswordToggle && widget.obscureText) {
      suffixIcon = IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: _togglePasswordVisibility,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.lable != null)
          Text(
            widget.lable!,
            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
          ),
        TextFormField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          maxLines: _obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: widget.prefixIcon,
            suffixIcon: suffixIcon,
            filled: widget.filled,
            fillColor: widget.fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: widget.borderColor, width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: widget.borderColor, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: widget.focusedBorderColor, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
          enabled: widget.enabled,
        ),
      ],
    );
  }
}
