import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:disease/spashscreen.dart';
import 'bill_card.dart';
import 'prediction.dart';

class BillPage extends StatefulWidget {
  final Prediction prediction;

  const BillPage({Key? key, required this.prediction}) : super(key: key);
  @override
  State<BillPage> createState() => _BillPageState();
}

class SemiCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..addArc(Rect.fromLTRB(0, 0, size.height, size.height), -1.57, 3.14);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _BillPageState extends State<BillPage> {
  // Prediction _getPrediction() {
  //   // This is where you would normally fetch data from an API
  //   // For this example, I'm creating a dummy prediction
  //   return Prediction.fromJson({
  //     'objects': [
  //       {'name': 'Can', 'count': 5, 'price': 0.10},
  //       {'name': 'Bottle', 'count': 3, 'price': 0.15},
  //       {'name': 'Paper', 'count': 10, 'price': 0.05},
  //     ]
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('E d MMM                             h:mm a')
            .format(DateTime.now());

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SplashScreen()));
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
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
                  _buildTopCard(context),
                  _buildBillGeneratedCard(),
                  _buildDateCard(formattedDate),
                  BillCardUI(
                      prediction: widget.prediction,
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildTopCard(BuildContext context) {
    return Card(
      color: Colors.teal[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      elevation: 3.0,
      margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: Container(
        height: 60,
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SplashScreen())),
            ),
            const Text(
              'Recycle Bill',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.share, color: Colors.black),
              onPressed: () => print('Share button pressed!'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillGeneratedCard() {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      elevation: 3.0,
      margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal[50],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              spreadRadius: 8,
              offset: Offset(0, 5),
            ),
          ],
        ),
        height: 80,
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            const SizedBox(width: 50),
            const Text(
              'Bill Generated',
              style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
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
    );
  }

  Widget _buildDateCard(String formattedDate) {
    return Stack(
      children: [
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0.0),
              topRight: Radius.circular(0.0),
            ),
          ),
          elevation: 3.0,
          margin: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: SizedBox(
            width: 350,
            height: 33,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formattedDate,
                  style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        _buildSemiCircle(left: -2),
        _buildSemiCircle(right: -2),
      ],
    );
  }

  Widget _buildSemiCircle({double? left, double? right}) {
    return Positioned(
      left: left,
      right: right,
      top: 0,
      bottom: 0,
      child: Transform(
        alignment: Alignment.center,
        transform:
            right != null ? Matrix4.rotationY(3.14159) : Matrix4.identity(),
        child: ClipPath(
          clipper: SemiCircleClipper(),
          child: Container(
            width: 80,
            height: 80,
            color: const Color(0xFF006a6a),
          ),
        ),
      ),
    );
  }

