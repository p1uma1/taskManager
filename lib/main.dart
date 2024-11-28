import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager_new/screens/home_screen.dart';
import 'package:taskmanager_new/screens/login_screen.dart';
import 'package:taskmanager_new/screens/singup_screen.dart';
import 'package:taskmanager_new/screens/splash_screen.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    initialRoute: '/splash',
    routes: {
      '/splash': (context) => SplashScreen(),
      '/login': (context) => LoginScreen(),
      '/home': (context) => HomeScreen(),
      '/signup': (context) => SignupScreen()
    },
    debugShowCheckedModeBanner: false,
  ));
}
