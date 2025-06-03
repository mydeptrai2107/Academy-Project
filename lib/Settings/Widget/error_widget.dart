import 'package:ahmed_academy/Settings/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    this.text = "It looks like there are no students yet",
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 15,
      children: [
        Image.asset(
          "assets/images/empty-list.png",
          color: CustomTheme().selectedTextColor,
          height: 150,
        ),
        Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontFamily: 'Mulish', fontSize: 16),
        ),
      ],
    ));
  }
}

class CustomErrorWidget2 extends StatelessWidget {
  const CustomErrorWidget2({
    this.message = "Oops! An error occured. Please try again later.",
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 15,
        children: [
          Image.asset(
            "assets/images/error.png",
            height: 100,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Mulish',
                fontSize: 16),
          ),
        ],
      )),
    );
  }
}

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 15,
        children: [
          Image.asset(
            "assets/images/no-wifi.png",
            // color: CustomTheme().selectedTextColor,
            height: 100,
          ),
          const Text(
            "No Internet Connection",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Mulish',
                fontSize: 16),
          ),
        ],
      )),
    );
  }
}
