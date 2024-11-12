import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome Back!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Home Screen
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text("Login"),
            ),
            TextButton(
              onPressed: () {
                // Navigate to Sign-Up Screen
              },
              child: Text("Create an Account"),
            ),
          ],
        ),
      ),
    );
  }
}
