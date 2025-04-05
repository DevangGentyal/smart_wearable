import 'package:flutter/material.dart';

class GuardianHomePage extends StatelessWidget {
  const GuardianHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guardian Home')),
      body: const Center(
        child: Text(
          'Welcome, Guardian!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
