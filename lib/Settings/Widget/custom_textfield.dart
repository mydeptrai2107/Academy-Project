import 'package:ahmed_academy/Settings/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Color backgroundColor;
  final double borderRadius;
  final Color shadowColor;
  final double shadowBlurRadius;
  final Offset shadowOffset;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final ValueChanged<String>? onChanged;

  const CustomTextfield({
    super.key,
    this.hintText = "Enter text here",
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.backgroundColor = Colors.white,
    this.borderRadius = 12.0,
    this.shadowColor = Colors.black,
    this.shadowBlurRadius = 8.0,
    this.shadowOffset = const Offset(0, 4),
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    this.padding = const EdgeInsets.all(6),
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: TextField(
        cursorColor: CustomTheme().selectedTextColor,
        cursorErrorColor: CustomTheme().selectedTextColor,
        enableSuggestions: true,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        onEditingComplete: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onSubmitted: (value) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTapOutside: (value) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        style:
            const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelStyle: const TextStyle(
              color: Color.fromARGB(255, 102, 102, 102),
              fontFamily: 'OpenSans'),
          labelText: hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
        ),
      ),
    );
  }
}
