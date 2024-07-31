import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bill_page.dart';

class TestMainDashboard extends StatefulWidget {
  @override
  _TestMainDashboardState createState() => _TestMainDashboardState();
}

class _TestMainDashboardState extends State<TestMainDashboard> {
  final _aluminiumCansController = TextEditingController();
  final _gableTopController = TextEditingController();
  final _glassBottleController = TextEditingController();
  final _milkGallonController = TextEditingController();
  final _plasticController = TextEditingController();
  final _tetrapackController = TextEditingController();
  final _objectController = TextEditingController();

  File? _image;
  final picker = ImagePicker();
  bool _processing = false;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _sendImageToServer() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an image first.")),
      );
      return;
    }

    setState(() {
      _processing = true;
    });

    try {
      var uri = Uri.parse('https://recycle22.azurewebsites.net/detect-objects/');
      var request = http.MultipartRequest('POST', uri);

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        _image!.path,
        filename: 'image.jpg',
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Image sent successfully');
        var jsonResponse = json.decode(response.body);
        print('Server response: ${response.body}');

        setState(() {
          _aluminiumCansController.text = jsonResponse['Aluminium Cans'].toString();
          _gableTopController.text = jsonResponse['Gable Top'].toString();
          _glassBottleController.text = jsonResponse['Glass Bottle'].toString();
          _milkGallonController.text = jsonResponse['Milk Gallon'].toString();
          _plasticController.text = jsonResponse['Plastic'].toString();
          _tetrapackController.text = jsonResponse['Tetrapack'].toString();
          _objectController.text = jsonResponse['Object'].toString();
        });

        bool allZero = jsonResponse.values.every((value) => value == 0);

        if (!allZero) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BillPage(
                aluminiumCansController: _aluminiumCansController,
                gableTopController: _gableTopController,
                glassBottleController: _glassBottleController,
                milkGallonController: _milkGallonController,
                plasticController: _plasticController,
                tetrapackController: _tetrapackController,
                objectController: _objectController,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No items detected. Please try again.")),
          );
        }
      } else {
        print('Failed to send image. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to send image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: Unable to process image. Please try again.")),
      );
    } finally {
      setState(() {
        _processing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Recycle Image Uploader'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              _image == null
                  ? Text('No image selected.')
                  : Image.file(_image!),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: getImage,
                child: Text('Select Image from Gallery'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _processing ? null : _sendImageToServer,
                child: _processing
                    ? CircularProgressIndicator()
                    : Text('Send Image to Server'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}