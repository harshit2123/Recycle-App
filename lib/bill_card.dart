import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'prediction.dart';
import 'package:image_picker/image_picker.dart';

class BillCardUI extends StatefulWidget {
  final TextEditingController canController;
  final TextEditingController bottleController;

  const BillCardUI({
    Key? key,
    required this.canController,
    required this.bottleController,
  }) : super(key: key);

  @override
  _BillCardUIState createState() => _BillCardUIState();
}

class _BillCardUIState extends State<BillCardUI> {
  late final TextEditingController canController;
  late final TextEditingController bottleController;

  @override
  void initState() {
    super.initState();
    // Assign the provided controllers or initialize new ones if not provided
    canController = widget.canController;
    bottleController = widget.bottleController;
  }

  Card _buildBreakdownCard(String itemName, int count, double price) {
    return Card(
      color: Colors.lightGreen,
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                '$itemName',
                style: TextStyle(fontSize: 16, color: Colors.white),
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
            Expanded(
              child: Text(
                '$count',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Spacer(),
            Expanded(
              child: Text(
                '\$${price.toStringAsFixed(2)}', // Show price with two decimal places
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Spacer(),
            Expanded(
              child: Text(
                '\$${(price * count).toStringAsFixed(2)}', // Show total with two decimal places
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'prediction.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Bill Card UI'),
//         ),
//         body: BillCardUI(),
//         // floatingActionButton: FloatingActionButton(
//         //   onPressed: () async {
//         //     // Fetch prediction data
//         //     final prediction = await fetchPrediction();
//         //   },
//         //   backgroundColor: Colors.teal[50],
//         //   child: const Icon(Icons.share, color: Colors.black),
//         // ),
//       ),
//     );
//   }

//   // Future<Prediction> fetchPrediction() async {
//   //   final response =
//   //       await http.get(Uri.parse('http://10.0.2.2:8000/detect-objects'));
//   //   if (response.statusCode == 200) {
//   //     return Prediction.fromJson(jsonDecode(response.body));
//   //   } else {
//   //     throw Exception('Failed to load prediction');
//   //   }
//   // }

// }

// class BillCardUI extends StatefulWidget {
//   @override
//   _BillCardUIState createState() => _BillCardUIState();
// }

// class _BillCardUIState extends State<BillCardUI> {
//   // Define the map for item names and their frequencies
//   Map<String, int> frequencyMap = {};

//   int totalSquaredFrequency = 0;

//   @override
//   void initState() {
//     super.initState();
//   }

//   Card _buildBreakdownCard(String itemName, int frequency) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(25),
//       ),
//       color: Colors.lightGreen,
//       elevation: 5,
//       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Padding(
//         padding: EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Item: $itemName',
//               style: TextStyle(fontSize: 16, color: Colors.white),
//             ),
//             SizedBox(height: 5),
//             Text(
//               'Frequency: $_prediction!.can',
//               style: TextStyle(fontSize: 16, color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

  // Card _buildBreakdownCard(String itemName, int frequency) {
  //   return Card(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
  //     color: Colors.teal[50],
  //     elevation: 0.0, // Remove shadow
  //     child: Padding(
  //       padding: EdgeInsets.all(8.0),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Expanded(
  //             child: Text(
  //               itemName, // Use itemName from frequencyMap
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //           Expanded(
  //             child: Text(
  //               '$frequency', // Display frequency
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //           Expanded(
  //             child: Text(
  //               '$frequency', // Display frequency
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //           Expanded(
  //             child: Text(
  //               '${(frequency * frequency).toStringAsFixed(2)}',
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0),
      height: 490,
      decoration: BoxDecoration(
        color: Colors.teal[50], // Replace with your desired color
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 8,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 8,
            offset: const Offset(-5, 0), // Shadow on the left
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 10),
          // Table header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Article',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Qty.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Price/Qty',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Price',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey),
          Container(
            height: 350,
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                late String itemName;
                late int count;
                late double price;

                // We only have one item (Bottle) for now, so we assume index is always 0
                itemName = 'Bottle';
                // Check if the text is empty or not a valid integer before parsing
                count = bottleController.text.isNotEmpty
                    ? int.tryParse(bottleController.text) ?? 0
                    : 0;
                price = 0.2; // Assuming the price for the bottle is $2.99

                return _buildBreakdownCard(itemName, count, price);
              },
              // itemBuilder: (context, index) {
              //   late String itemName;
              //   late int count;
              //   late double price;

              //   // Assigning price in dollars for both items
              //   if (index == 0) {
              //     itemName = 'Bottle';
              //     // Check if the text is empty or not a valid integer before parsing
              //     count = bottleController.text.isNotEmpty
              //         ? int.tryParse(bottleController.text) ?? 0
              //         : 0;
              //     price = 2.99; // Assuming the price for the bottle is $2.99
              //   } else {
              //     itemName = 'Can';
              //     // Check if the text is empty or not a valid integer before parsing
              //     count = canController.text.isNotEmpty
              //         ? int.tryParse(canController.text) ?? 0
              //         : 0;
              //     price = 1.99; // Assuming the price for the can is $1.99
              //   }

              //   return _buildBreakdownCard(itemName, count, price);
              // },
            ),
          ),
          SizedBox(height: 10),
          // Text(
          //   'Prediction Result:',
          //   style: TextStyle(fontWeight: FontWeight.bold),
          //   textAlign: TextAlign.center,
          // ),
        ],
      ),
    );
  }
}
