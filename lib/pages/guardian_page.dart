import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_wearable/database/user_service.dart';
import 'package:smart_wearable/pages/settings_page.dart';
// import 'package:smart_wearable/pages/connect_device_page.dart';

class GuardianHomePage extends StatefulWidget {
  const GuardianHomePage({Key? key}) : super(key: key);

  @override
  State<GuardianHomePage> createState() => _GuardianHomePageState();
}

class _GuardianHomePageState extends State<GuardianHomePage> {
  int _selectedIndex = 0;

  // Define your pages here
  final List<Widget> _pages = [
    const GuardianHomePageContent(),
    Center(
      child: Text('Alert Details Page'),
    ),
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
      backgroundColor: const Color(0xFFF0F3F9),
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
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.home, 0),
                  _buildNavItem(Icons.notifications_active, 1),
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

class GuardianHomePageContent extends StatefulWidget {
  const GuardianHomePageContent({Key? key}) : super(key: key);

  @override
  State<GuardianHomePageContent> createState() =>
      _GuardianHomePageContentState();
}

class _GuardianHomePageContentState extends State<GuardianHomePageContent> {
  final User? user = FirebaseAuth.instance.currentUser;
  final UserService _userService = UserService();
  dynamic guardianData;
  dynamic patientData;
  double _opacity = 0.0;
  bool _isloading = true;
  bool _isPatientAssigned = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final gdata = await _userService.getGuardian(user!.uid);
    final pdata;
    if (gdata!['patient_id'].toString().isEmpty) {
      pdata = null;
    } else {
      pdata = await _userService.getPatient(gdata!['patient_id']);
    }
    print("pdata = " + pdata.toString());
    setState(() {
      _isloading = false;
      guardianData = gdata;
      patientData = pdata;
      _opacity = 0.0;
    });
    // Trigger opacity change after UI is built
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    return _isloading
        ? Center()
        : patientData == null
            ? AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: _opacity,
                curve: Curves.easeInOut,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 80),
                        Text(
                          "Hello ${guardianData['name']}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "You don't have any patient\nto Track!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Image.asset(
                          'assets/images/empty.png', // Make sure you have this asset in your project
                          height: 200,
                          width: 200,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          "Accept a patient's invite to track them",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Add your check mail functionality here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            "Check Mail",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: _opacity,
                curve: Curves.easeInOut,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with user info - REDUCED SIZE
                        _buildHeader(),
                        const SizedBox(height: 12),

                        // Sensor Data Title
                        const Text(
                          'Sensor Data',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF7080F5),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Sensor metrics grid
                        _buildSensorGrid(),
                        const SizedBox(height: 14),

                        // Action buttons
                        _buildActionButtons(),
                        const SizedBox(height: 14),

                        // Recent Alerts
                        _buildRecentAlerts(),
                        const SizedBox(height: 10), // Add bottom padding
                      ],
                    ),
                  ),
                ),
              );
  }

  Widget _buildHeader() {
    // Safely extract first name
    final gfullName = guardianData?['name'] ?? '';
    final gfirstName = gfullName.split(' ').first;
    final pfullName = patientData?['name'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello $gfirstName',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Now Tracking $pfullName',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildSensorGrid() {
    return SizedBox(
      height: 250, // Fixed height to control overall size
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.4,
        shrinkWrap: true,
        children: [
          _buildMetricCard(
            title: 'Heart Rate',
            value: '75',
            unit: 'bpm',
            color: const Color(0xFFFFEEEE),
            iconData: Icons.favorite,
            iconColor: Colors.red,
          ),
          _buildMetricCard(
            title: 'SpO2',
            value: '98',
            unit: '%',
            color: const Color(0xFFE6F0FF),
            iconData: Icons.air,
            iconColor: Colors.blue,
            assetImage: 'assets/images/lungs.png',
          ),
          _buildMetricCard(
            title: 'Stress Level',
            value: 'Low',
            unit: '',
            color: const Color(0xFFFFF6E0),
            iconData: Icons.psychology,
            iconColor: Colors.orange,
            assetImage: 'assets/images/brain.png',
          ),
          _buildMetricCard(
            title: 'Activity',
            value: 'Active',
            unit: '',
            color: const Color(0xFFE6E0FF),
            iconData: Icons.directions_run,
            iconColor: Colors.purple,
          ),
        ],
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
    String? assetImage,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  color: iconColor,
                  size: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (unit.isNotEmpty)
                    Text(
                      unit,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                ],
              ),
            ],
          ),
          if (assetImage != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  assetImage,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return SizedBox(
      height: 120, // Fixed height to ensure consistent layout
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton('Patient', Icons.call, Colors.blue.shade100),
          _buildActionButton('SOS', Icons.notifications_active, Colors.red),
          _buildActionButton('Location', Icons.location_on, Colors.blue),
          _buildActionButton('Silent', Icons.notifications_off, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentAlerts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Recent Alerts',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF7080F5),
              ),
            ),
            Text(
              '...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildAlertCard(
          'Stress Detected',
          '10:30PM',
          '7th Jul',
        ),
        const SizedBox(height: 10),
        _buildAlertCard(
          'Fall Detected',
          '10:30PM',
          '7th Jul',
        ),
      ],
    );
  }

  Widget _buildAlertCard(String title, String time, String date) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.red.shade300,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Tap for Details',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
