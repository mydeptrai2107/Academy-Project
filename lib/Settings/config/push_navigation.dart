import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PushNavigation {
  static void push(context, page) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
  }

  static void pop(context) {
    Navigator.pop(context);
  }
}
