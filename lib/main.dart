import 'package:flutter/material.dart';

import 'features/splash/presentation/pages/splash_screen.dart';
import 'features/widgets_showcase/presentation/pages/widgets_showcase_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POSEA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.black)),
      // Change home to WidgetsShowcasePage to see all widgets
      home: const WidgetsShowcasePage(),
      // home: const SplashScreen(),
    );
  }
}
