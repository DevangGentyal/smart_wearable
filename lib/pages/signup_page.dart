import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _obscurePassword = true;
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Header
                const Center(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF433333), // Dark brown
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Subtitle
                const Center(
                  child: Text(
                    'Join us and start your journey',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF8A7868), // Medium brown
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // White container with form
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name field
                      const Text(
                        'Full Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF433333),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F2E9), // Light beige
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFEADBC8)),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            hintStyle: const TextStyle(
                              color: Color(0xFFBDBDBD),
                              fontSize: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.person_outline,
                              color: Color(0xFF8A7868),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email Address field
                      const Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF433333),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F2E9), // Light beige
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFEADBC8)),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            hintStyle: const TextStyle(
                              color: Color(0xFFBDBDBD),
                              fontSize: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Color(0xFF8A7868),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password field
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF433333),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F2E9), // Light beige
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFEADBC8)),
                        ),
                        child: TextField(
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Create password',
                            hintStyle: const TextStyle(
                              color: Color(0xFFBDBDBD),
                              fontSize: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.help_outline,
                              color: Color(0xFF8A7868),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF8A7868),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Terms and Conditions checkbox
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _isChecked,
                              onChanged: (value) {
                                setState(() {
                                  _isChecked = value ?? false;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: const BorderSide(color: Color(0xFF8A7868)),
                              activeColor: const Color(0xFF8A7868),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'I agree to the Terms & Conditions',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8A7868),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Create Account button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/comp_prof');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Or continue with
                      const Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Color(0xFF8A7868),
                              thickness: 0.5,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(
                                color: Color(0xFF8A7868),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Color(0xFF8A7868),
                              thickness: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Social sign-in buttons
                      Row(
                        children: [
                          // Google button
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                side:
                                    const BorderSide(color: Color(0xFFEADBC8)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: Image.network(
                                'https://cdn4.iconfinder.com/data/icons/logos-brands-7/512/google_logo-google_icongoogle-512.png',
                                width: 24,
                                height: 24,
                              ),
                              label: const Text(
                                'Google',
                                style: TextStyle(
                                  color: Color(0xFF8A7868),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Already have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: Color(0xFF8A7868),
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color(0xFF433333),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
