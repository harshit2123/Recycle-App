import 'package:flutter/material.dart';
import 'package:disease/main_dashboard.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 80),
          _buildHeader(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogo(),
                  _buildRecycleImage(),
                  _buildStartButton(context),
                  const SizedBox(height: 71),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF0431A6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400]!,
            offset: const Offset(4, 4),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5.5),
        child: Text(
          'Vik-Ram Environmental',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF49B03),
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/companylogo.png',
      width: 400,
      height: 250,
    );
  }

  Widget _buildRecycleImage() {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0, bottom: 0),
      child: Image.asset(
        'assets/images/recycle.png',
        width: 550,
        height: 350,
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainDashboard()),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
        elevation: MaterialStateProperty.all<double>(5),
        shadowColor: MaterialStateProperty.all<Color>(Colors.grey[300]!),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 0),
        child: const Text(
          'Tap To  Start',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
