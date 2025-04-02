import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 246, 241, 1),
      body: Column(
        children: [
          // Top image section
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 1), // Light blue background
              ),
              child: Stack(
                children: [
                  // Background image (clouds, heart, leaf)
                  Positioned.fill(
                      child: Image.asset('assets/images/splash_screen_img.png'))
                ],
              ),
            ),
          ),
          // Text and buttons section
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  // const Text(
                  //   'Smart Wearable',
                  //   style: TextStyle(
                  //     fontSize: 42,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black,
                  //     fontFamily: 'Roboto',
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                  // // Subtitle
                  // const Text(
                  //   'YOUR HEALTH, YOUR WAY',
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     color: Color(0xFFAA8273), // Brown-ish color
                  //     letterSpacing: 1.5,
                  //     fontFamily: 'Roboto',
                  //   ),
                  // ),
                  const SizedBox(height: 40),
                  // Sign Up Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 255, 255, 255), // Light pink
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.black12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Log In Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Or continue with
                  const Text(
                    'Or continue with',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Google button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: Image.network(
                        'https://cdn4.iconfinder.com/data/icons/logos-brands-7/512/google_logo-google_icongoogle-512.png',
                        width: 24,
                        height: 24,
                      ),
                      label: const Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
