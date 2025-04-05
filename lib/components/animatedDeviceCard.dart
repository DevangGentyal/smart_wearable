import 'package:flutter/material.dart';

class AnimatedDeviceCard extends StatefulWidget {
  final double cardWidth;
  final String deviceName;
  final String deviceId;

  const AnimatedDeviceCard({
    super.key,
    required this.cardWidth,
    required this.deviceName,
    required this.deviceId,
  });

  @override
  State<AnimatedDeviceCard> createState() => _AnimatedDeviceCardState();
}

class _AnimatedDeviceCardState extends State<AnimatedDeviceCard>
    with TickerProviderStateMixin {
  double _imageTop = 0;
  bool _textVisible = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnim;

  @override
  void initState() {
    super.initState();

    // 3D Flip Animation Setup
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _flipAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );

    // Trigger animations after small delay
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _imageTop = -50;
        _textVisible = true;
      });
      _flipController.forward();
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flipAnim,
      builder: (context, child) {
        final flipValue = _flipAnim.value;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(3.14 * flipValue),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // White Card
              Container(
                width: widget.cardWidth,
                height: widget.cardWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 120),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 600),
                      opacity: _textVisible ? 1 : 0,
                      child: Text(
                        widget.deviceName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 700),
                      opacity: _textVisible ? 1 : 0,
                      child: Text(
                        widget.deviceId,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),

              // Animated Image Slide Up
              AnimatedPositioned(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutBack,
                top: _imageTop,
                child: SizedBox(
                  width: widget.cardWidth * 0.7,
                  height: widget.cardWidth * 0.7,
                  child: const Image(
                    image: AssetImage('assets/images/device.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
