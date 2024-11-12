import 'package:flutter/material.dart';
import 'main_screen.dart'; // Import the MainScreen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMainScreen();
  }

  void _navigateToMainScreen() async {
    await Future.delayed(Duration(seconds: 3)); // Show splash for 3 seconds
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => MainScreen()), // Navigate to MainScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black background
      body: Center(
        child: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.pink,
                Colors.purple,
                Colors.blue
              ], // Gradient from pink to violet to blue
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: Text(
            'Movies',
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
