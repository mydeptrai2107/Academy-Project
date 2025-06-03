import 'package:flutter/material.dart';

class StyledDropdown extends StatefulWidget {
  final List<String> items;
  final String hintText;
  final Color backgroundColor;
  final double borderRadius;
  final Color shadowColor;
  final double shadowBlurRadius;
  final Offset shadowOffset;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  const StyledDropdown({
    super.key,
    required this.items,
    this.hintText = "Select Class",
    this.backgroundColor = Colors.white,
    this.borderRadius = 12.0,
    this.shadowColor = Colors.black,
    this.shadowBlurRadius = 8.0,
    this.shadowOffset = const Offset(0, 4),
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  State<StyledDropdown> createState() => _StyledDropdownState();
}

class _StyledDropdownState extends State<StyledDropdown> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: widget.shadowColor.withAlpha(26),
            blurRadius: widget.shadowBlurRadius,
            offset: widget.shadowOffset,
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          value: selectedValue,
          hint: Text(widget.hintText),
          items: widget.items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(fontFamily: "Poppins"),
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
          },
          isExpanded: true,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontFamily: "Poppins"),
        ),
      ),
    );
  }
}
