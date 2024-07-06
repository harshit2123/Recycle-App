import 'package:flutter/material.dart';
import 'dart:async';
import 'package:disease/main_dashboard.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 100.0),
                  child: Image.asset(
                    'assets/images/logo4.png',
                    width: 300,
                    height: 300,
                  ),
                ),
                const Positioned(
                  left: 160, // Adjust the left position of the text
                  bottom: 80, // Adjust the bottom position of the text
                  child: Text(
                    'Hey,  I  am  EcoRanger.\nLet\'s  Sort and \nRecycle it Together!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.brown,
                      fontWeight: FontWeight.bold,
                      // fontFamily: 'Nunito',
                      // backgroundColor: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0.0, bottom: 60),
              child: Image.asset(
                'assets/images/recycle.png',
                width: 550,
                height: 300,
              ),
            ),
            // Text(
            //   'Your Recycler',
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.green[400],
            //   ),
            // ),
            // SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainDashboard()),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.lightGreen),
                elevation: MaterialStateProperty.all<double>(
                    5), // Adjust the elevation as needed
                shadowColor: MaterialStateProperty.all<Color>(
                    Colors.grey[300]!), // Light grey shadow color
              ),
              child: const Text(
                ' Tap To Sort ',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
