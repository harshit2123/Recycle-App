import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'prediction.dart';
import 'bill_page.dart';

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  final _canController = TextEditingController();
  final _bottleController = TextEditingController();

  File? _image;
  Prediction? _prediction;
  String? _token;

  final picker = ImagePicker();
  final dio = Dio();

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

  Future<void> sendImage() async {
    if (_image == null) return;

    FormData createFormData() {
      return FormData.fromMap({
        'file': MultipartFile.fromFileSync(
          _image!.path,
          filename: 'image.jpg',
        ),
        'token': _token ?? '',
      });
    }

    try {
      Response response = await dio.post(
        // 'https://recycle2-7.onrender.com/detect-objects',

        'http://10.0.2.2:8000/detect-objects',
        data: createFormData(),
        options: Options(
          contentType: 'multipart/form-data',
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 400;
          },
        ),
      );

      if (response.statusCode == 307) {
        String redirectedUrl = response.headers.value('location') ?? '';
        print('Redirecting to: $redirectedUrl');

        if (redirectedUrl.isNotEmpty) {
          response = await dio.post(
            redirectedUrl,
            data: createFormData(),
            options: Options(
              contentType: 'multipart/form-data',
            ),
          );
        }
      }

      print('Response data: ${response.data}');
      if (response.data is Map<String, dynamic>) {
        setState(() {
          // _prediction = Prediction.fromJson(response.data);
          // _canController.text = _prediction?.can.toString() ?? '';
          // _bottleController.text = _prediction?.bottle.toString() ?? '';
        });
      } else {
        print('Unexpected response format: ${response.data}');
      }
    } catch (error) {
      print('Error sending image: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sorting and Recycle App',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logo10.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: _image == null
                      ? Center(child: Text('No image selected.'))
                      : Image.file(
                          _image!,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: getImage,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.lightGreen),
                      elevation: MaterialStateProperty.all<double>(5),
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.grey[300]!),
                    ),
                    child: const Text(
                      ' Select Image ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await sendImage();

                        // Navigator.push(
                        //   context
                        //   // MaterialPageRoute(
                        //   //   // builder: (context) => BillPage(
                        //   //   //   canController: _canController,
                        //   //   //   bottleController: _bottleController,
                        //   //   // ),
                        //   // ),
                        // );
                      } catch (e) {
                        print('Error: $e');
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.lightGreen),
                      elevation: MaterialStateProperty.all<double>(5),
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.grey[300]!),
                    ),
                    child: const Text(
                      'Sort Now!',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 70),
              _prediction == null
                  ? Container()
                  : Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _bottleController,
                            decoration: InputDecoration(
                              labelText: 'Health',
                              labelStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 5),
                          TextField(
                            controller: _canController,
                            decoration: InputDecoration(
                              labelText: 'Confidence',
                              labelStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
