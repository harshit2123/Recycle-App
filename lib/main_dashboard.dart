import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bill_page.dart';

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  final _canController = TextEditingController();
  final _bottleController = TextEditingController();
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Timer? _timer;
  File? _lastCapturedImage;
  bool _showConfirmation = false;

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

    _startCapturing();
  }

  void _startCapturing() {
    _timer =
        Timer.periodic(Duration(seconds: 5), (_) => _captureAndSendImage());
  }

  Future<void> _captureAndSendImage() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      _lastCapturedImage = File(image.path);
      await _sendImageToServer(_lastCapturedImage!);
    } catch (e) {
      print('Error capturing or sending image: $e');
    }
  }

  Future<void> _sendImageToServer(File imageFile) async {
    try {
      var uri = Uri.parse('http://10.0.2.2:8000/detect-objects/');
      var request = http.MultipartRequest('POST', uri);

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        filename: 'image.jpg',
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Image sent successfully');
        var jsonResponse = json.decode(response.body);

        setState(() {
          _canController.text = jsonResponse['can'].toString();
          _bottleController.text = jsonResponse['bottle'].toString();
          _showConfirmation = true;
        });

        _timer?.cancel(); // Stop the timer
      } else {
        print('Failed to send image. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            'Failed to send image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Error: Unable to process image. Please try again.")),
      );
      rethrow;
    }
  }

  // Future<void> _sendImageToServer(File imageFile) async {
  //   try {
  //     var uri = Uri.parse('http://10.0.2.2:8000/detect-objects/');
  //     var request = http.MultipartRequest('POST', uri);

  //     request.files.add(await http.MultipartFile.fromPath(
  //       'file',
  //       imageFile.path,
  //       filename: 'image.jpg',
  //     ));

  //     var streamedResponse = await request.send();
  //     var response = await http.Response.fromStream(streamedResponse);

  //     if (response.statusCode == 200) {
  //       print('Image sent successfully');
  //       var jsonResponse = json.decode(response.body);

  //       setState(() {
  //         _canController.text = jsonResponse['can'].toString();
  //         _bottleController.text = jsonResponse['bottle'].toString();
  //         _showConfirmation = true;
  //       });

  //       _timer?.cancel(); // Stop the timer
  //     } else {
  //       print('Failed to send image. Status code: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Error sending image: $e');
  //   }
  // }

  @override
  void dispose() {
    _timer?.cancel();
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
            return _showConfirmation
                ? _buildConfirmationUI()
                : _buildCameraUI();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildCameraUI() {
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
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        // Handle close button press
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
      ],
    );
  }

  Widget _buildConfirmationUI() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: _lastCapturedImage != null
                ? Image.file(_lastCapturedImage!)
                : Container(),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Is this image correct?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_canController.text.isNotEmpty &&
                            _bottleController.text.isNotEmpty) {
                          // Server response received, navigate to BillPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BillPage(
                                canController: _canController,
                                bottleController: _bottleController,
                              ),
                            ),
                          );
                        } else if (_lastCapturedImage != null) {
                          // Show loading indicator while waiting for server response
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 16),
                                    Text("Processing image..."),
                                  ],
                                ),
                              );
                            },
                          );
                          // Resend the image to the server
                          _sendImageToServer(_lastCapturedImage!).then((_) {
                            Navigator.of(context)
                                .pop(); // Close the loading dialog
                            if (_canController.text.isNotEmpty &&
                                _bottleController.text.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BillPage(
                                    canController: _canController,
                                    bottleController: _bottleController,
                                  ),
                                ),
                              );
                            } else {
                              // Show error if server response is still empty
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Error processing image. Please try again.")),
                              );
                            }
                          });
                        } else {
                          // Show error if no image was captured
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "No image captured. Please try again.")),
                          );
                        }
                      },
                      child: Text('Yes'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showConfirmation = false;
                          _lastCapturedImage = null;
                          _canController.clear();
                          _bottleController.clear();
                        });
                        _startCapturing();
                      },
                      child: Text('No'),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildConfirmationUI() {
  //   return SafeArea(
  //     child: Column(
  //       children: [
  //         Expanded(
  //           flex: 2,
  //           child: _lastCapturedImage != null
  //               ? Image.file(_lastCapturedImage!)
  //               : Container(),
  //         ),
  //         Expanded(
  //           flex: 1,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 'Is this image correct?',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(height: 20),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) => BillPage(
  //                             canController: _canController,
  //                             bottleController: _bottleController,
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                     child: Text('Yes'),
  //                     style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
  //                   ),
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       setState(() {
  //                         _showConfirmation = false;
  //                         _lastCapturedImage = null;
  //                       });
  //                       _startCapturing();
  //                     },
  //                     child: Text('No'),
  //                     style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
