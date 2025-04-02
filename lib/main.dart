import 'package:flutter/material.dart';
import 'package:smart_wearable/pages/comp_prof_page.dart';
import 'package:smart_wearable/pages/home_page.dart';
import 'package:smart_wearable/pages/signup_page.dart';
import 'package:smart_wearable/pages/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
// Create a GoRouter object

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Wearable',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      routes: {
        "/signup": (context) => SignupPage(),
        "/comp_prof": (context) => CompleteProfilePage(),
        "/home": (context) => HomePage(),
      },
    );
  }
}
