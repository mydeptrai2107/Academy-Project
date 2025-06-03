import 'package:flutter/material.dart';

class ContainerWithLead extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? borderColor;
  final double borderRadius;
  final double? width;
  final double? height;
  final String text;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final BoxShadow? boxShadow;
  final Widget? leading;

  const ContainerWithLead({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    this.margin = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    this.borderColor,
    this.borderRadius = 8.0,
    this.width = double.infinity,
    this.height,
    required this.text,
    this.textStyle,
    this.backgroundColor,
    this.boxShadow,
    this.leading,
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
        //     color: Colors.black.withOpacity(0.2),
        //     blurRadius: 1.0,
        //     offset: const Offset(1, 2),
        //   ),
        // ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              text,
              style: textStyle ??
                  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      color: Colors.grey[800]),
            ),
          ),
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}
