import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_wearable/database/auth_service.dart';
import 'package:smart_wearable/database/user_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _obscurePassword = true;
  String _selectedRole = 'Patient'; // Default role

  // Form controllers
  // final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService authService = AuthService();
  final UserService userService = UserService();

  // Validation messages
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String errorMessage = '';
  bool _isLoading = false;

  // Validate form
  bool _validateForm() {
    bool isValid = true;
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    // Name validation
    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = 'Name is required');
      isValid = false;
    }

    // Email validation
    if (_emailController.text.trim().isEmpty) {
      setState(() => _emailError = 'Email is required');
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text)) {
      setState(() => _emailError = 'Please enter a valid email');
      isValid = false;
    }

    // Password validation
    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = 'Password is required');
      isValid = false;
    } else if (_passwordController.text.length < 6) {
      setState(() => _passwordError = 'Password must be at least 6 characters');
      isValid = false;
    }

    // Confirm password validation
    if (_confirmPasswordController.text.isEmpty) {
      setState(() => _confirmPasswordError = 'Please confirm your password');
      isValid = false;
    } else if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _confirmPasswordError = 'Passwords do not match');
      isValid = false;
    }

    return isValid;
  }

  // Add user to database after sign-up
  Future<bool> _addUserToDatabase(BuildContext context) async {
    try {
      // Register User (returns Firebase User object)
      User? user = await authService.register(
          _emailController.text, _passwordController.text);

      if (user != null) {
        if (_selectedRole == 'Patient') {
          // Add PATIENT data to Firestore collection
          await userService.addPatient(user.uid, _nameController.text,
              _emailController.text, _selectedRole // Store user role
              );
        } else {
          // Add GUARDIAN data to Firestore collection
          await userService.addGuardian(user.uid, _nameController.text,
              _emailController.text, _selectedRole // Store user role
              );
        }

        return true; // Success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Register Failed"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Register Failed: ${e}"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
                // Header
                const Center(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF433333),
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
                      color: Color(0xFF8A7868),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // White Container with Form
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
                      // Role Selection - Bold & Noticeable
                      const Text(
                        'Select Your Role *',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red, // Makes it stand out
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F2E9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedRole,
                            isExpanded: true,
                            items: ['Patient', 'Guardian']
                                .map((role) => DropdownMenuItem(
                                      value: role,
                                      child: Text(role),
                                    ))
                                .toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedRole = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Full Name Field
                      const Text(
                        'Full Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF433333),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8F2E9),
                          prefixIcon: const Icon(Icons.person_outline),
                          errorText: _nameError,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email Field
                      const Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF433333),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8F2E9),
                          prefixIcon: const Icon(Icons.email_outlined),
                          errorText: _emailError,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF433333),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Create password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8F2E9),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          errorText: _passwordError,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password Field
                      const Text(
                        'Confirm Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF433333),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Confirm password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8F2E9),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          errorText: _confirmPasswordError,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Create Account Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  setState(() => _isLoading = true);
                                  if (_validateForm()) {
                                    bool success =
                                        await _addUserToDatabase(context);
                                    if (success) {
                                      if (_selectedRole == 'Guardian') {
                                        Navigator.pushNamed(context, '/home');
                                      } else {
                                        Navigator.pushNamed(
                                            context, '/comp_prof');
                                      }
                                    }
                                    setState(() => _isLoading = false);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                )
                              : const Text(
                                  'Create Account',
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Already have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account? '),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
