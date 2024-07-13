import 'package:disease/spashscreen.dart';
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
  bool _processing = false;

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
        Timer.periodic(Duration(seconds: 1), (_) => _captureAndSendImage());
  }

  Future<void> _captureAndSendImage() async {
    if (_processing) return; // Prevent multiple simultaneous captures

    setState(() {
      _processing = true;
    });

    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      _lastCapturedImage = File(image.path);
      await _sendImageToServer(_lastCapturedImage!);
    } catch (e) {
      print('Error capturing or sending image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Error: Unable to process image. Please try again.")),
      );
    } finally {
      setState(() {
        _processing = false;
      });
    }
  }

  Future<void> _sendImageToServer(File imageFile) async {
    try {
      var uri =
          Uri.parse('https://recyclethree.azurewebsites.net/detect-objects/');
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
        });

        _timer?.cancel(); // Stop the timer

        // Navigate to BillPage only if we have valid data
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No items detected. Please try again.")),
          );
          _startCapturing(); // Restart capturing if no items were detected
        }
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
      _startCapturing(); // Restart capturing if there was an error
    }
  }

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
          return snapshot.connectionState == ConnectionState.done
              ? _buildCameraUI()
              : const Center(child: CircularProgressIndicator());
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
                child: _buildTopBar(),
              ),
              Expanded(child: _buildCenterFrame()),
              _buildBottomText(),
              if (_processing) _buildProcessingIndicator(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCapturingText(),
        _buildCloseButton(),
      ],
    );
  }

  Widget _buildCapturingText() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: const Text(
        'Capturing Image...',
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
    );
  }

  Widget _buildCloseButton() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.close, color: Colors.black),
        onPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SplashScreen()),
        ),
      ),
    );
  }

  Widget _buildCenterFrame() {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildBottomText() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Please align the items within the space',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }

  Widget _buildProcessingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: CircularProgressIndicator(),
    );
  }
}
