import 'package:flutter/material.dart';
import 'package:apk_sinduuu/screens/welcome_screen.dart';
import 'package:apk_sinduuu/theme/theme.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skyward Lockdown',
      theme: lightMode,
      home: const WelcomeScreen(),
    );
  }
}
