import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_wearable/database/user_service.dart';
import 'package:smart_wearable/utils/sendInvite.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _guardianNameController = TextEditingController();
  final TextEditingController _guardianEmailController =
      TextEditingController();
  final TextEditingController _guardianPhoneController =
      TextEditingController();
  String? selectedGender = 'Male';
  String? selectedBloodGroup = 'Select Blood Group';
  final User? user = FirebaseAuth.instance.currentUser;
  final UserService _userService = UserService();
  var userData;

  // Error message fields for each input
  String _ageError = '';
  String _genderError = '';
  String _weightError = '';
  String _heightError = '';
  String _bloodGroupError = '';
  String _allergiesError = '';
  String _addressError = '';
  String _guardianNameError = '';
  String _guardianEmailError = '';
  String _guardianPhoneError = '';

  // Reset all error messages
  void _resetErrors() {
    setState(() {
      _ageError = '';
      _genderError = '';
      _weightError = '';
      _heightError = '';
      _bloodGroupError = '';
      _allergiesError = '';
      _addressError = '';
      _guardianNameError = '';
      _guardianEmailError = '';
      _guardianPhoneError = '';
    });
  }

  // Validating form
  bool _validateForm() {
    bool isValid = true;
    _resetErrors();

    // Validate Age
    if (_ageController.text.trim().isEmpty ||
        int.tryParse(_ageController.text.trim()) == null ||
        int.parse(_ageController.text.trim()) <= 0 ||
        int.parse(_ageController.text.trim()) > 120) {
      setState(() {
        _ageError = 'Enter a valid age (1-120).';
      });
      isValid = false;
    }

    // Validate Gender
    if (selectedGender == null || selectedGender!.isEmpty) {
      setState(() {
        _genderError = 'Gender is required.';
      });
      isValid = false;
    }

    // Validate Weight
    if (_weightController.text.trim().isEmpty ||
        double.tryParse(_weightController.text.trim()) == null ||
        double.parse(_weightController.text.trim()) <= 0) {
      setState(() {
        _weightError = 'Enter a valid weight.';
      });
      isValid = false;
    }

    // Validate Height
    if (_heightController.text.trim().isEmpty ||
        double.tryParse(_heightController.text.trim()) == null ||
        double.parse(_heightController.text.trim()) <= 0) {
      setState(() {
        _heightError = 'Enter a valid height.';
      });
      isValid = false;
    }

    // Validate Blood Group
    if (selectedBloodGroup == 'Select Blood Group' ||
        selectedBloodGroup == null) {
      setState(() {
        _bloodGroupError = 'Select a valid Blood Group.';
      });
      isValid = false;
    }

    // Validate Allergies
    if (_allergiesController.text.trim().length > 200) {
      setState(() {
        _allergiesError =
            'Allergies description should not exceed 200 characters.';
      });
      isValid = false;
    }

    // Validate Address
    if (_addressController.text.trim().isEmpty) {
      setState(() {
        _addressError = 'Address is required.';
      });
      isValid = false;
    }

    // Validate Guardian Name
    if (_guardianNameController.text.trim().isEmpty) {
      setState(() {
        _guardianNameError = 'Guardian Name is required.';
      });
      isValid = false;
    }

    // Validate Guardian Email
    if (_guardianEmailController.text.trim().isEmpty ||
        !_emailRegex.hasMatch(_guardianEmailController.text.trim())) {
      setState(() {
        _guardianEmailError = 'Enter a valid email address.';
      });
      isValid = false;
    }

    // Validate Guardian Phone
    if (_guardianPhoneController.text.trim().isEmpty) {
      setState(() {
        _guardianPhoneError = 'Phone number is required.';
      });
      isValid = false;
    }

    return isValid;
  }

  // Email Regex
  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Generate Token for guardian-invitation
  String generateToken() {
    var random = Random.secure();
    var values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  // Add user to database after sign-up
  Future<bool> _addUserData() async {
    try {
      if (user != null) {
        final patientData = await _userService.getPatient(user!.uid);

        String guardianEmail = _guardianEmailController.text.trim();

        // Before Adding Patient: Send invitation to Guardian
        String inviteToken =
            generateToken(); // Function to generate a unique token
        String inviteLink =
            "https://smart-wearable-api.vercel.app/?token=$inviteToken";

        final success = await sendInvite(guardianEmail, patientData!['name'],
            inviteLink); // Send Invite via Email

        if (success) {
          // Wait for the user to close the dialog before continuing
          await showDialog(
            context: context,
            barrierDismissible:
                false, // Prevent user from closing it by tapping outside
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Email Sent"),
                content: Text(
                    "Email has been sent to Guardian. Contact them to make them accept the Invite within 24hrs."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text("Okay"),
                  ),
                ],
              );
            },
          );
        }

        // Add the profile data in users collection
        Map<String, dynamic> data = {
          "age": _ageController.text,
          "gender": selectedGender,
          "weight": _weightController.text,
          "height": _heightController.text,
          "bloodGroup": selectedBloodGroup,
          "allergies": _allergiesController.text,
          "address": _addressController.text,
          "guardian_name": _guardianNameController.text,
          "guardian_email": _guardianEmailController.text,
          "guardian_phone": _guardianPhoneController.text,
        };

        // Add patients data
        await _userService.updatePatient(user!.uid, data);
        // Add guardian-invites data
        await _userService.addGuardianInvite(
            inviteToken,
            user!.uid,
            _guardianNameController.text,
            _guardianEmailController.text,
            _guardianPhoneController.text);

        return true;
      }

      // If user is not registered
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Register First"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profile Completion Failed: " + e.toString()),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return false;
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _allergiesController.dispose();
    _addressController.dispose();
    _guardianNameController.dispose();
    _guardianEmailController.dispose();
    _guardianPhoneController.dispose();
    super.dispose();
  }

  // Helper widget for error text
  Widget _errorText(String error) {
    return error.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(
              error,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          )
        : SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Center(
                  child: Text(
                    'Complete Your Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Please fill in your information',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Basic Information Section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Basic Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Age and Gender
                      Row(
                        children: [
                          // Age
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Age',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _ageError.isEmpty
                                          ? const Color(0xFFEEEEEE)
                                          : Colors.red,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _ageController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: '',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 14),
                                    ),
                                  ),
                                ),
                                _errorText(_ageError),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Gender
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Gender',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _genderError.isEmpty
                                          ? const Color(0xFFEEEEEE)
                                          : Colors.red,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedGender,
                                      isExpanded: true,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: <String>['Male', 'Female', 'Other']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedGender = newValue!;
                                          _genderError = '';
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                _errorText(_genderError),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Weight and Height
                      Row(
                        children: [
                          // Weight
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Weight (kg)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _weightError.isEmpty
                                          ? const Color(0xFFEEEEEE)
                                          : Colors.red,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _weightController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: '',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 14),
                                    ),
                                  ),
                                ),
                                _errorText(_weightError),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Height
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Height (cm)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _heightError.isEmpty
                                          ? const Color(0xFFEEEEEE)
                                          : Colors.red,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _heightController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: '',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 14),
                                    ),
                                  ),
                                ),
                                _errorText(_heightError),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Medical Information Section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Medical Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Blood Group
                      const Text(
                        'Blood Group',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _bloodGroupError.isEmpty
                                ? const Color(0xFFEEEEEE)
                                : Colors.red,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedBloodGroup,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: <String>[
                              'Select Blood Group',
                              'A+',
                              'A-',
                              'B+',
                              'B-',
                              'AB+',
                              'AB-',
                              'O+',
                              'O-'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedBloodGroup = newValue!;
                                _bloodGroupError = '';
                              });
                            },
                          ),
                        ),
                      ),
                      _errorText(_bloodGroupError),
                      const SizedBox(height: 16),

                      // Allergies
                      const Text(
                        'Allergies',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _allergiesError.isEmpty
                                ? const Color(0xFFEEEEEE)
                                : Colors.red,
                          ),
                        ),
                        child: TextField(
                          controller: _allergiesController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                      _errorText(_allergiesError),
                      const SizedBox(height: 16),

                      // Address
                      const Text(
                        'Address',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _addressError.isEmpty
                                ? const Color(0xFFEEEEEE)
                                : Colors.red,
                          ),
                        ),
                        child: TextField(
                          controller: _addressController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                      _errorText(_addressError),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Emergency Contact Section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Emergency Contact',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Guardian Name
                      const Text(
                        'Guardian Name',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _guardianNameError.isEmpty
                                ? const Color(0xFFEEEEEE)
                                : Colors.red,
                          ),
                        ),
                        child: TextField(
                          controller: _guardianNameController,
                          decoration: InputDecoration(
                            hintText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                      _errorText(_guardianNameError),
                      const SizedBox(height: 16),

                      // Guardian Email
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _guardianEmailError.isEmpty
                                ? const Color(0xFFEEEEEE)
                                : Colors.red,
                          ),
                        ),
                        child: TextField(
                          controller: _guardianEmailController,
                          decoration: InputDecoration(
                            hintText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                      _errorText(_guardianEmailError),
                      const SizedBox(height: 16),

                      // Guardian Phone
                      const Text(
                        'Phone No',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _guardianPhoneError.isEmpty
                                ? const Color(0xFFEEEEEE)
                                : Colors.red,
                          ),
                        ),
                        child: TextField(
                          controller: _guardianPhoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                      _errorText(_guardianPhoneError),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Save and Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_validateForm()) {
                        bool success = await _addUserData();
                        if (success) {
                          Navigator.pushNamed(context, '/home');
                        }
                      }
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
