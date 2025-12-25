import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/utils/box_shadow.dart';
import 'package:gestanea/core/utils/box_decoration.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final bool showErrorIfEmpty;
  final Color focusBorderColor;
  final Color defaultBorderColor;
  final TextInputType keyboardType;
  final bool obscureText;

  const InputField({
    super.key,
    required this.controller,
    this.hintText = '',
    this.prefixIcon,
    this.showErrorIfEmpty = true,
    this.focusBorderColor = AppColors.main600,
    this.defaultBorderColor = const Color(0xFFD2D2D2),
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late FocusNode _focusNode;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    widget.controller.addListener(() {
      if (widget.showErrorIfEmpty) {
        setState(() {
          _showError = widget.controller.text.isEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _focusNode.hasFocus
        ? widget.focusBorderColor
        : AppColors.white;

    return Container(
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
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: widget.focusBorderColor)
              : null,
          suffixIcon: _showError
              ? Container(
                  margin: const EdgeInsets.all(8),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: widget.focusBorderColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text("!", style: TextStyle(color: Colors.white)),
                  ),
                )
              : null,
          hintText: widget.hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}
