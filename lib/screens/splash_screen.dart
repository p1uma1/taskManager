import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check user authentication after a delay
    Future.delayed(Duration(seconds: 2), () {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Navigate to HomeScreen if user is authenticated
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Navigate to LoginScreen if user is not authenticated
        Navigator.pushReplacementNamed(context, '/login');
      }
    });

    // Splash screen UI
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text(
          'Task Manager',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
