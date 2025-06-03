import 'package:ahmed_academy/Presentation/ClassPerformance/login_screen.dart';
import 'package:ahmed_academy/Settings/theme/theme.dart';
import 'package:ahmed_academy/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Future.delayed(const Duration(seconds: 2));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorSchemeSeed: CustomTheme().selectedTextColor,
          scaffoldBackgroundColor: Colors.grey[150]),
      home: const AdminLoginScreen(),
    );
  }
}
