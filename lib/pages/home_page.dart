import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello Devang',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Are you feeling good?',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 50,
                    height: 50,
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
              const SizedBox(height: 32),

              // Health metrics grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    // Heart Rate Card
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

                    // SpO2 Card
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

                    // Stress Level Card
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

                    // Activity Card
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

              const SizedBox(height: 16),

              // Voice Command Button
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE8F1FE),
                      ),
                      child: const Icon(Icons.mic, color: Colors.blue),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Voice Command',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Tap to speak',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Emergency SOS Button
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: const Icon(Icons.phone, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Emergency SOS',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Press for help',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Divider
              Container(
                height: 1,
                color: Colors.grey.withOpacity(0.3),
              ),

              const SizedBox(height: 24),

              // Bottom Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.home, true),
                  _buildNavItem(Icons.bar_chart, false),
                  _buildNavItem(Icons.settings, false),
                ],
              ),
            ],
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

  Widget _buildNavItem(IconData icon, bool isSelected) {
    return Container(
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
    );
  }
}
