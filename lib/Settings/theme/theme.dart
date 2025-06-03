import 'package:flutter/material.dart';

class CustomTheme {
  Color? selectedTheme;
  Color? selectedTextColor;

  CustomTheme() {
    selectedTheme = themeColor[1];
    selectedTextColor = textColor[1];
  }

  List<Color> textColor = [
    Colors.purple[300]!,
    Colors.blue[300]!,
    Colors.orange[300]!,
    Colors.red[300]!,
    Colors.green[300]!
  ];

  List<Color> themeColor = [
    Colors.purple[100]!,
    Colors.blue[100]!,
    Colors.orange[100]!,
    Colors.red[100]!,
    Colors.green[100]!
  ];
}
