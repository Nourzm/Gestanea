import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/utils/box_shadow.dart';
import 'package:gestanea/core/utils/box_decoration.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final Color focusBorderColor;
  final Color defaultBorderColor;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? errorText;
  final String? Function(String)? validator;

  const InputField({
    super.key,
    required this.controller,
    this.hintText = '',
    this.prefixIcon,
    this.focusBorderColor = AppColors.main600,
    this.defaultBorderColor = const Color(0xFFD2D2D2),
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.errorText,
    this.validator,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late FocusNode _focusNode;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _obscureText = widget.obscureText;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final borderColor = hasError
        ? Colors.red
        : (_focusNode.hasFocus ? widget.focusBorderColor : AppColors.white);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              const BoxShadow(
                color: AppColors.white,
                offset: Offset(-2.5, -2.5),
                blurRadius: 5,
                spreadRadius: -5,
                inset: true,
              ),
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.25),
                offset: const Offset(2.5, 2.5),
                blurRadius: 5,
                inset: true,
              ),
            ],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText && _obscureText,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: widget.focusBorderColor)
                  : null,
              suffixIcon: _buildSuffixIcon(hasError),
              hintText: widget.hintText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget? _buildSuffixIcon(bool hasError) {
    // If it's a password field, always show visibility toggle
    // (Errors are shown below the field, so we don't need error icon in suffix)
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: hasError 
              ? Colors.red.withOpacity(0.7)
              : widget.focusBorderColor.withOpacity(0.7),
          size: 22,
        ),
        onPressed: _togglePasswordVisibility,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
      );
    }

    // For non-password fields, show error icon if there's an error
    if (hasError) {
      return Container(
        margin: const EdgeInsets.all(8),
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text(
            "!",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // No suffix icon
    return null;
  }
}
