import 'dart:ui';
import 'package:disease/prediction.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

import 'bill_card.dart';

class BillPage extends StatefulWidget {
  final TextEditingController canController;
  final TextEditingController bottleController;

  BillPage({
    Key? key,
    required this.canController,
    required this.bottleController,
  }) : super(key: key);

  @override
  State<BillPage> createState() => _BillPageState();
}

class SemiCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..addArc(Rect.fromLTRB(0, 0, size.height, size.height), -1.57, 3.14);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

void _printBill() {
  // Implement your printing logic here
  print("Printing bill...");
}

class _BillPageState extends State<BillPage> {
  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('E d MMM                             h:mm a')
            .format(DateTime.now());

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF027f80), Color(0xFF004242)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //1st card

                Card(
                  color: Colors.teal[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  elevation: 3.0,
                  margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      // Distribute space evenly between elements
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'Recycle Bill',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Add the share button with no text label
                        IconButton(
                          icon: Icon(Icons.share, color: Colors.black),
                          onPressed: () {
                            // Implement your share functionality here (e.g., using the Share plugin)
                            print(
                                'Share button pressed!'); // Placeholder for now
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // First additional card centre time
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    ),
                  ),
                  elevation: 3.0,
                  margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          spreadRadius: 8,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    height: 80,
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          'Bill Generated',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Center(
                          child: Lottie.asset(
                            'assets/images/tick2.json',
                            width: 100,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Second additional card
                Stack(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0.0),
                          topRight: Radius.circular(0.0),
                        ),
                      ),
                      elevation: 3.0,
                      margin: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Container(
                        width: 350,
                        height: 33,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight:
                                    FontWeight.bold, // Make the text bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: -2,
                      top: 0,
                      bottom: 0,
                      child: ClipPath(
                        clipper: SemiCircleClipper(),
                        child: Container(
                          width: 80,
                          height: 80,
                          color: Color(0xFF006a6a),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -2,
                      top: 0,
                      bottom: 0,
                      child: Transform(
                        alignment: Alignment.center,
                        transform:
                            Matrix4.rotationY(3.14159), // Mirror horizontally
                        child: ClipPath(
                          clipper: SemiCircleClipper(),
                          child: Container(
                            width: 80,
                            height: 80,
                            color: Color(0xFF006a6a),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                BillCardUI(
                  canController: widget.canController,
                  bottleController: widget.bottleController,
                ),

                SizedBox(
                  height: 25,
                ),
                // Row(
                //   children: [
                //     SizedBox(
                //       width: 15,
                //     ),
                //     // ElevatedButton.icon(
                //     //   onPressed: _printBill,
                //     //   icon: const Icon(Icons.print),
                //     //   label: const Text('Print Bill'),
                //     //   style: ElevatedButton.styleFrom(
                //     //     backgroundColor: Colors.teal[50],
                //     //     padding: const EdgeInsets.symmetric(
                //     //       horizontal: 20,
                //     //       vertical: 10,
                //     //     ),
                //     //     textStyle: const TextStyle(
                //     //       fontSize: 18,
                //     //       fontWeight: FontWeight.bold,
                //     //     ),
                //     //   ),
                //     // ),
                //     // SizedBox(
                //     //   width: 70,
                //     // ),
                //     // ElevatedButton.icon(
                //     //   onPressed: _printBill,
                //     //   icon: const Icon(Icons.list),
                //     //   label: const Text('New Bill'),
                //     //   style: ElevatedButton.styleFrom(
                //     //     backgroundColor: Colors.teal[50], // Add teal color here
                //     //     padding: const EdgeInsets.symmetric(
                //     //       horizontal: 20,
                //     //       vertical: 10,
                //     //     ),
                //     //     textStyle: const TextStyle(
                //     //       fontSize: 18,
                //     //       fontWeight: FontWeight.bold,
                //     //     ),
                //     //   ),
                //     // )
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
