import 'package:disease/spashscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Upload Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   File? _image;
//   String? _response;

//   final picker = ImagePicker();
//   final dio = Dio();

//   Future getImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   Future sendImage() async {
//     if (_image == null) return;

//     FormData formData = FormData.fromMap({
//       'file': await MultipartFile.fromFile(
//         _image!.path,
//         filename: 'image.jpg',
//       ),
//     });

//     try {
//       Response response = await dio.post(
//         'http://10.0.2.2:8000/predict', // Change URL to your API endpoint  'http://10.0.2.2:8000/predict'
//         data: formData,
//         options: Options(
//           contentType: 'multipart/form-data',
//         ),
//       );

//       setState(() {
//         _response = response.data.toString();
//       });
//     } catch (error) {
//       print('Error sending image: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Upload Demo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _image == null
//                 ? Text('No image selected.')
//                 : Image.file(
//                     _image!,
//                     width: 300,
//                     height: 300,
//                   ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: getImage,
//               child: Text('Select Image'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: sendImage,
//               child: Text('Send Image to Server'),
//             ),
//             SizedBox(height: 20),
//             _response == null
//                 ? Container()
//                 : Text(
//                     _response!,
//                     style: TextStyle(fontSize: 16),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
