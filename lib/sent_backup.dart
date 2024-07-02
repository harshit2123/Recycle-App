import 'package:disease/spashscreen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:io';
import 'bill_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  final _canController = TextEditingController();
  final _bottleController = TextEditingController();
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late Timer _timer;
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller.initialize();

    await _initializeControllerFuture;

    if (!mounted) return;

    setState(() {});

    _timer =
        Timer.periodic(Duration(seconds: 5), (_) => _captureAndSendImage());
  }

  Future<void> _captureAndSendImage() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      await _sendImageToServer(File(image.path));
    } catch (e) {
      print('Error capturing or sending image: $e');
    }
  }

  Future<void> _sendImageToServer(File imageFile) async {
    try {
      var uri = Uri.parse(
        'http://10.0.2.2:8000/detect-objects/',
      );
      var request = http.MultipartRequest('POST', uri);

      if (kIsWeb) {
        // For web
        List<int> imageBytes = await imageFile.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: 'image.jpg',
        ));
      } else {
        // For mobile
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          filename: 'image.jpg',
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Image sent successfully');
        // Navigate to BillPage with the controllers
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BillPage(
                      canController: _canController,
                      bottleController: _bottleController,
                    )));
      } else {
        print('Failed to send image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending image: $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(_controller),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Scan Any QR Code',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.white),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SplashScreen()),
                                ); // Navigate to SplashScreen
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Please align the QR within the scanner',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        heroTag: "btn1",
                        child: Icon(Icons.flashlight_on),
                        onPressed: () {
                          // Toggle flashlight
                        },
                      ),
                      SizedBox(height: 16),
                      FloatingActionButton(
                        heroTag: "btn2",
                        child: Icon(Icons.image),
                        onPressed: () {
                          // Handle gallery selection
                        },
                      ),
                      SizedBox(height: 16),
                      FloatingActionButton(
                        heroTag: "btn3",
                        child: Icon(Icons.qr_code),
                        onPressed: () {
                          // Handle My QR action
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
