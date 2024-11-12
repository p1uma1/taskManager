import 'package:flutter/material.dart';
import 'package:taskmanager_new/screens/home_screen.dart';
import 'package:taskmanager_new/screens/login_screen.dart';
import 'package:taskmanager_new/screens/splash_screen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/splash',
    routes: {
      '/splash': (context) => SplashScreen(),
      '/login': (context) => LoginScreen(),
      '/home': (context) => HomeScreen(),
    },
  ));
}