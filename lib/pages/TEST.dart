import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Tracking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const HealthTrackingPage(),
    );
  }
}

class HealthTrackingPage extends StatelessWidget {
  const HealthTrackingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              const Text(
                'Sensor Data',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF7080F5),
                ),
              ),
              const SizedBox(height: 16),
              _buildSensorGrid(),
              const SizedBox(height: 24),
              _buildActionButtons(),
              const SizedBox(height: 24),
              _buildRecentAlerts(),
              const Spacer(),
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Hello Drax',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF7080F5).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Guardian',
                style: TextStyle(
                  color: Color(0xFF7080F5),
                ),
              ),
            ),
          ],
        ),
        const Text(
          'Now Tracking Devang Gentyal',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSensorGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildSensorCard(
          color: const Color(0xFFFFEEEE),
          iconColor: Colors.red,
          icon: Icons.favorite,
          title: 'Heart Rate',
          value: '75',
          unit: 'bpm',
        ),
        _buildSensorCard(
          color: const Color(0xFFE6F0FF),
          iconColor: Colors.blue,
          icon: Icons.air,
          title: 'SpO2',
          value: '98',
          unit: '%',
          additionalWidget: Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/lungs.png',
              width: 80,
              color: Colors.black.withOpacity(0.1),
            ),
          ),
        ),
        _buildSensorCard(
          color: const Color(0xFFFFF6E0),
          iconColor: Colors.orange,
          icon: Icons.psychology,
          title: 'Stress Level',
          value: 'Low',
          additionalWidget: Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/brain.png',
              width: 80,
              color: Colors.black.withOpacity(0.1),
            ),
          ),
        ),
        _buildSensorCard(
          color: const Color(0xFFE6E0FF),
          iconColor: Colors.purple,
          icon: Icons.directions_run,
          title: 'Activity',
          value: 'Active',
        ),
      ],
    );
  }

  Widget _buildSensorCard({
    required Color color,
    required Color iconColor,
    required IconData icon,
    required String title,
    required String value,
    String? unit,
    Widget? additionalWidget,
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (unit != null)
                    Text(
                      unit,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                ],
              ),
            ],
          ),
          if (additionalWidget != null) additionalWidget,
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton('Patient', Icons.call, Colors.blue.shade100),
        _buildActionButton('SOS', Icons.notifications_active, Colors.red),
        _buildActionButton('Location', Icons.location_on, Colors.blue),
        _buildActionButton('Silent', Icons.notifications_off, Colors.orange),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return Column(
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
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentAlerts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Recent Alerts',
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFF7080F5),
              ),
            ),
            Text(
              '...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildAlertCard(
          'Stress Detected',
          '10:30PM',
          '7th Jul',
        ),
        const SizedBox(height: 16),
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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.red.shade300,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Tap for Details',
                  style: TextStyle(
                    fontSize: 16,
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
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNavItem(Icons.home, true),
        _buildNavItem(Icons.bar_chart, false),
        _buildNavItem(Icons.bar_chart, false),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.black : Colors.grey,
        size: 28,
      ),
    );
  }
}
