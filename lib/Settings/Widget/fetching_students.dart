import 'package:ahmed_academy/Settings/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FetchingStudents extends StatelessWidget {
  const FetchingStudents({
    this.text = "Fetching Students",
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SpinKitThreeBounce(
          color: CustomTheme().selectedTextColor,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 20),
        ),
      ],
    );
  }
}

class Updating extends StatelessWidget {
  const Updating({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SpinKitThreeBounce(
          color: CustomTheme().selectedTextColor,
        ),
        const Text(
          "Updating...",
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 20),
        ),
      ],
    );
  }
}
