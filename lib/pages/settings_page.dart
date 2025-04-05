import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_wearable/database/auth_service.dart';
// import 'package:smart_wearable/utils/userdataStore.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);
  // final role = userStore.role!;
  User? user = FirebaseAuth.instance.currentUser;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    // var userData;
    // if (role == 'Patient') {
    //   userData = userStore.patientData;
    // } else {
    //   userData = userStore.guardianData;
    // }
    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                // Full Name Field
                _buildFieldLabel("Full Name"),
                const SizedBox(height: 8),
                _buildInfoContainer(
                  icon: Icons.person_outline,
                  text: 'Satish Gentyal',
                ),
                const SizedBox(height: 20),

                // Email Field
                _buildFieldLabel("Email"),
                const SizedBox(height: 8),
                _buildInfoContainer(
                  icon: Icons.person_outline,
                  text: 'satishgentyal@gmail.com',
                ),
                const SizedBox(height: 20),

                // Phone Number Field
                _buildFieldLabel("Phone No"),
                const SizedBox(height: 8),
                _buildInfoContainer(
                  icon: Icons.person_outline,
                  text: "9421659207",
                ),
                const SizedBox(height: 40),

                // Logout Button
                Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Add logout functionality here
                        await _authService.logout();
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Color(0xFF4B5563),
      ),
    );
  }

  Widget _buildInfoContainer({required IconData icon, required String text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.black),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
