import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_wearable/components/animatedDeviceCard.dart';

enum ConnectionStatus {
  initial,
  checkingPermissions,
  scanning,
  deviceFound,
  connecting,
  connected,
  failed
}

class ConnectDevicePage extends StatefulWidget {
  const ConnectDevicePage({
    Key? key,
  }) : super(key: key);

  @override
  State<ConnectDevicePage> createState() => _ConnectDevicePageState();
}

class _ConnectDevicePageState extends State<ConnectDevicePage>
    with SingleTickerProviderStateMixin {
  // BLE variables
  List<ScanResult> _scanResults = [];
  BluetoothDevice? _targetDevice;
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _characteristic;
  String _deviceData = "Waiting for Data...";

  // The device name we're looking for
  final String _targetDeviceName = "FireBoltt 100";

  // Device info to display
  String _deviceName = "";
  String _deviceId = "";

  // UI state variables
  bool _deviceFound = false;
  bool _isConnected = false;

  // Enhanced status tracking
  ConnectionStatus _status = ConnectionStatus.initial;
  String _errorMessage = "";
  bool _bluetoothAvailable = true;

  @override
  void initState() {
    super.initState();

    // Check if any devices are already connected
    List<BluetoothDevice> devices = FlutterBluePlus.connectedDevices;
    for (var device in devices) {
      if (device.platformName == _targetDeviceName) {
        print("Device Connected: " + device.platformName);
        setState(() {
          _connectedDevice = device;
          _targetDevice = device;
          _deviceName = device.platformName;
          _deviceId = device.remoteId.str;
          _deviceFound = true;
          _isConnected = true;
          _status = ConnectionStatus.connected;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Enhanced BLE Process with proper status tracking
  Future<void> _checkBluetoothAndStart() async {
    setState(() {
      _status = ConnectionStatus.checkingPermissions;
      _errorMessage = "";
    });

    // Check if Bluetooth is available
    try {
      // Check Bluetooth permission
      var bleStatus = await Permission.bluetooth.request();
      var bleConnectStatus = await Permission.bluetoothConnect.request();
      var bleScanStatus = await Permission.bluetoothScan.request();

      if (bleStatus.isDenied ||
          bleConnectStatus.isDenied ||
          bleScanStatus.isDenied) {
        setState(() {
          _status = ConnectionStatus.failed;
          _errorMessage =
              "Bluetooth permissions denied. Please grant permissions to continue.";
          _bluetoothAvailable = false;
        });
        return;
      }

      // Check location permission (needed for BLE scanning on Android)
      var locationStatus = await Permission.location.request();
      if (locationStatus.isDenied) {
        setState(() {
          _status = ConnectionStatus.failed;
          _errorMessage = "Location permission required for device scanning.";
        });
        return;
      }

      // Ensure Bluetooth is ON
      try {
        await FlutterBluePlus.turnOn();
      } catch (e) {
        setState(() {
          _status = ConnectionStatus.failed;
          _errorMessage =
              "Unable to turn on Bluetooth. Please enable Bluetooth manually.";
          _bluetoothAvailable = false;
        });
        return;
      }

      // If all checks pass, start scanning
      _startScan();
    } catch (e) {
      setState(() {
        _status = ConnectionStatus.failed;
        _errorMessage = "Error initializing Bluetooth: $e";
      });
    }
  }

  void _startScan() async {
    setState(() {
      _scanResults.clear();
      _status = ConnectionStatus.scanning;
      _errorMessage = "";
      _deviceFound = false;
    });

    try {
      // Start scanning
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

      // Listen for scan results
      FlutterBluePlus.scanResults.listen((results) {
        if (mounted) {
          setState(() {
            _scanResults = results;
            print("Updated scan results: ${_scanResults.length} devices");
          });

          // Print detected devices in console
          for (var result in results) {
            print(
                "🔍 Found Device: ${result.device.platformName} - ${result.device.remoteId.str}");

            // Check if we found the target device
            if (result.device.platformName == _targetDeviceName) {
              _selectDevice(result);
            }
          }
        }
      });

      // Handle scan completion
      FlutterBluePlus.isScanning.listen((isScanning) {
        if (!isScanning && mounted) {
          setState(() {
            // If we're still in scanning status but not scanning anymore,
            // it means the scan completed
            if (_status == ConnectionStatus.scanning) {
              if (_scanResults.isEmpty) {
                _status = ConnectionStatus.failed;
                _errorMessage =
                    "No Bluetooth devices found. Make sure your device is turned on and nearby.";
              } else if (!_deviceFound) {
                _status = ConnectionStatus.failed;
                _errorMessage = "Device not found. Please try again.";
              }
            }
          });
        }
      });

      // Add a timeout safety net
      await Future.delayed(const Duration(seconds: 12));
      if (_status == ConnectionStatus.scanning && !_deviceFound && mounted) {
        await FlutterBluePlus.stopScan();
        setState(() {
          _status = ConnectionStatus.failed;
          _errorMessage = "Scan timed out. FireBoltt 100 not found.";
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _status = ConnectionStatus.failed;
          _errorMessage = "Error scanning for devices: $e";
        });
      }

      print("Scan error: $e");
    }
  }

  void _selectDevice(ScanResult result) {
    setState(() {
      _targetDevice = result.device;
      _deviceName = result.device.platformName;
      _deviceId = "ID:" + result.device.remoteId.str.substring(0, 8);
      _deviceFound = true;
      _status = ConnectionStatus.deviceFound;
    });
  }

  Future<void> _connectToDevice() async {
    if (_targetDevice == null) return;

    setState(() {
      _status = ConnectionStatus.connecting;
    });

    try {
      // Connect to the device
      await _targetDevice!.connect();

      setState(() {
        _connectedDevice = _targetDevice;
        _isConnected = true;
        _status = ConnectionStatus.connected;
      });
    } catch (e) {
      setState(() {
        _status = ConnectionStatus.failed;
        _errorMessage = "Failed to connect: $e";
      });
    }
  }

  void _disconnectFromDevice() async {
    if (_connectedDevice != null) {
      try {
        await _connectedDevice!.disconnect();
      } catch (e) {
        print("Error disconnecting: $e");
      }
    }

    setState(() {
      _isConnected = false;
      _status = ConnectionStatus.deviceFound;
    });
  }

  void _retryConnection() {
    _checkBluetoothAndStart();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width * 0.8;

    return Scaffold(
      // Updated background with gradient
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // actions: _deviceFound
        //     ? [
        //         // Refresh button in the top right corner
        //         IconButton(
        //           icon: const Icon(Icons.refresh, color: Color(0xFF5E90F2)),
        //           onPressed: _startScan,
        //           tooltip: "Rescan for devices",
        //         ),
        //       ]
        //     : [],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF0F4FF), Color(0xFFEEF1F8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Section
              _deviceFound
                  ? Text(
                      'Device Connected',
                      style: TextStyle(
                        fontSize: 34,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    )
                  : Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Connect Device',
                            style: TextStyle(
                              fontSize: 34,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Tap to scan devices available',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6E83F5),
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),

              // Error message Section
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    color: Colors.red.shade50,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _errorMessage,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Main content area
              Expanded(
                child: Center(
                  child: _deviceFound
                      ? AnimatedDeviceCard(
                          cardWidth: cardWidth,
                          deviceName: _deviceName,
                          deviceId: _deviceId)
                      : _buildScanButton(),
                ),
              ),

              // Connect button at the bottom when device is found
              if (_deviceFound)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: ElevatedButton(
                    onPressed:
                        (_status == ConnectionStatus.connecting || _isConnected)
                            ? (_isConnected ? _disconnectFromDevice : null)
                            : _connectToDevice,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isConnected
                          ? Colors.red.shade400
                          : const Color(0xFF5E90F2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size(double.infinity, 56),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_status == ConnectionStatus.connecting)
                          Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(right: 12),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        Text(
                          _status == ConnectionStatus.connecting
                              ? 'Connecting...'
                              : _isConnected
                                  ? 'Disconnect'
                                  : 'Connect',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Bottom Divider
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Divider(
                  height: 40,
                  thickness: 1,
                  color: Color(0xFFE0E0E0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for the scan button
  Widget _buildScanButton() {
    return _status == ConnectionStatus.scanning
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  color: const Color(0xFF5E90F2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Scanning for devices...",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF5E90F2),
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          )
        : ElevatedButton(
            onPressed: _checkBluetoothAndStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5E90F2),
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(32),
              elevation: 10,
              shadowColor: const Color(0xFF5E90F2).withOpacity(0.5),
            ),
            child: const Icon(
              Icons.bluetooth_searching_rounded,
              size: 50,
              color: Colors.white,
            ),
          );
  }

  // Widget for the device card
  // Widget _buildDeviceCard(double cardWidth) {
  //   return Stack(
  //     clipBehavior: Clip.none,
  //     alignment: Alignment.center,
  //     children: [
  //       // Name ID
  //       Container(
  //         width: cardWidth,
  //         height: cardWidth,
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(20),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.05),
  //               blurRadius: 10,
  //               offset: const Offset(0, 5),
  //             ),
  //           ],
  //         ),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             const SizedBox(height: 120),
  //             Text(
  //               _deviceName,
  //               style: const TextStyle(
  //                 fontSize: 24,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             const SizedBox(height: 5),
  //             Text(
  //               _deviceId,
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 color: Colors.black.withOpacity(0.6),
  //               ),
  //             ),
  //             const SizedBox(height: 40),
  //           ],
  //         ),
  //       ),

  //       // Watch Image
  //       Positioned(
  //         top: -50,
  //         child: SizedBox(
  //           width: cardWidth * 0.7,
  //           height: cardWidth * 0.7,
  //           child: const Image(
  //             image: AssetImage('assets/images/device.png'),
  //             fit: BoxFit.contain,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
