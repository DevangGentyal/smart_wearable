import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_wearable/database/user_service.dart';
import 'package:smart_wearable/pages/connect_device_page.dart';
import 'package:smart_wearable/pages/settings_page.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({Key? key}) : super(key: key);

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  int _selectedIndex = 0;

  // Define your pages here
  final List<Widget> _pages = [
    PatientHomePageContent(), // Custom widget for home content
    ConnectDevicePage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.white : Colors.grey[200],
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: _pages,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.home, 0),
                  _buildNavItem(Icons.devices, 1),
                  _buildNavItem(Icons.settings, 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientHomePageContent extends StatefulWidget {
  const PatientHomePageContent({Key? key}) : super(key: key);

  @override
  State<PatientHomePageContent> createState() => _PatientHomePageContentState();
}

class _PatientHomePageContentState extends State<PatientHomePageContent> {
  int _selectedIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;
  final UserService _userService = UserService();
  var patientData = null;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Delay to ensure smooth fade-in
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0;
      });
    }); // call the async method without awaiting
  }

  Future<void> _loadUserData() async {
    final data =
        await _userService.getPatient(user!.uid); // your async operation
    setState(() {
      patientData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Safely extract first name
    final fullName = patientData?['name'] ?? '';
    final firstName = fullName.split(' ').first;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 600),
      opacity: _opacity,
      curve: Curves.easeInOut,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4F8),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top section with user info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello $firstName',
                            style: TextStyle(
                              fontSize:
                                  screenWidth * 0.08, // Responsive font size
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Text(
                            'Are you feeling good?',
                            style: TextStyle(
                              fontSize: screenWidth * 0.06,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.12,
                      height: screenWidth * 0.12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        image: const DecorationImage(
                          image: AssetImage('assets/images/profile_img.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.03),

                // Health metrics grid
                Expanded(
                  child: GridView.count(
                    crossAxisCount:
                        screenWidth > 600 ? 3 : 2, // Tablet/Desktop support
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildMetricCard(
                        title: 'Heart Rate',
                        value: '75',
                        unit: 'bpm',
                        color: const Color(0xFFFEE8E8),
                        iconData: Icons.favorite,
                        iconColor: Colors.red,
                        iconBackgroundColor: Colors.white,
                        assetImage: null,
                      ),
                      _buildMetricCard(
                        title: 'SpO2',
                        value: '98',
                        unit: '%',
                        color: const Color(0xFFE8F1FE),
                        iconData: Icons.air,
                        iconColor: Colors.blue,
                        iconBackgroundColor: Colors.white,
                        assetImage: 'assets/images/lungs.png',
                      ),
                      _buildMetricCard(
                        title: 'Stress Level',
                        value: 'Low',
                        unit: '',
                        color: const Color(0xFFFFF2D0),
                        iconData: Icons.psychology,
                        iconColor: Colors.orange,
                        iconBackgroundColor: Colors.white,
                        assetImage: 'assets/images/brain.png',
                      ),
                      _buildMetricCard(
                        title: 'Activity',
                        value: 'Active',
                        unit: '',
                        color: const Color(0xFFE8E6FE),
                        iconData: Icons.directions_run,
                        iconColor: Colors.purple,
                        iconBackgroundColor: Colors.white,
                        assetImage: null,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // Voice Command Button
                _buildFeatureCard(
                  icon: Icons.mic,
                  iconColor: Colors.blue,
                  bgColor: const Color(0xFFE8F1FE),
                  title: 'Voice Command',
                  subtitle: 'Tap to speak',
                ),

                SizedBox(height: screenHeight * 0.015),

                // Emergency SOS Button
                _buildFeatureCard(
                  icon: Icons.phone,
                  iconColor: Colors.white,
                  bgColor: Colors.red,
                  title: 'Emergency SOS',
                  subtitle: 'Press for help',
                  isEmergency: true,
                ),

                SizedBox(height: screenHeight * 0.02),

                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String unit,
    required Color color,
    required IconData iconData,
    required Color iconColor,
    required Color iconBackgroundColor,
    required String? assetImage,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconBackgroundColor,
                ),
                child: Icon(iconData, color: iconColor),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    unit,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (assetImage != null)
            Positioned(
              bottom: -10,
              right: -10,
              child: Opacity(
                opacity: 0.4,
                child: Image.asset(
                  assetImage,
                  width: 80,
                  height: 80,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Widget _buildFeatureCard({
  required IconData icon,
  required Color iconColor,
  required Color bgColor,
  required String title,
  required String subtitle,
  bool isEmergency = false,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: isEmergency ? Colors.red : Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isEmergency
                ? Colors.white.withOpacity(0.2)
                : const Color(0xFFE8F1FE),
          ),
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isEmergency ? Colors.white : Colors.black,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: isEmergency
                    ? Colors.white.withOpacity(0.8)
                    : Colors.black.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
