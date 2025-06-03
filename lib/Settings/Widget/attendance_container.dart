import 'package:flutter/material.dart';

class AttendanceContainer extends StatelessWidget {
  final String studentName;
  final bool isPresent;
  final Function() onToggle;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? borderColor;
  final double borderRadius;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final BoxShadow? boxShadow;

  const AttendanceContainer({
    super.key,
    required this.studentName,
    required this.isPresent,
    required this.onToggle,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.margin = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    this.borderColor,
    this.borderRadius = 8.0,
    this.width = double.infinity,
    this.height,
    this.textStyle,
    this.backgroundColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        border: Border.all(color: borderColor ?? Colors.black12),
        borderRadius: BorderRadius.circular(borderRadius),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 1.0,
        //     offset: const Offset(1, 2),
        //   ),
        // ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              studentName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  color: Colors.grey[800]),
            ),
          ),
          const SizedBox(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  width: 35,
                  height: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isPresent ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("P",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  width: 35,
                  height: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: !isPresent ? Colors.red : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("A",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
