import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_wearable/pages/comp_prof_page.dart';
import 'package:smart_wearable/pages/home_page.dart';
import 'package:smart_wearable/pages/login_page.dart';
import 'package:smart_wearable/pages/signup_page.dart';
import 'package:smart_wearable/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  // await dotenv.load(fileName: ".env");
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
      home: const EntryPoint(),
      routes: {
        "/home": (context) => HomePage(),
        "/signup": (context) => SignupPage(),
        "/login": (context) => LoginPage(),
        "/comp_prof": (context) => CompleteProfilePage(),
      },
    );
  }
}

class EntryPoint extends StatefulWidget {
  const EntryPoint({Key? key}) : super(key: key);

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  Widget _initialScreen = const LoadingScreen(); // Show loader by default

  @override
  void initState() {
    super.initState();
    _checkRememberMe();
  }

  Future<void> _checkRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? false;

    await Future.delayed(const Duration(seconds: 2)); // Simulate splash delay

    // If user didn't select Remember Me, show SplashScreen
    if (!rememberMe) {
      setState(() => _initialScreen = const SplashScreen());
      return;
    }

    // Check current FirebaseAuth user once (not listening continuously)
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Logged in
      setState(() => _initialScreen = const HomePage());
    } else {
      // Not logged in
      setState(() => _initialScreen = const SplashScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _initialScreen;
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/loader.gif'),
      ),
    );
  }
}
