import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _checkLoginStatus(context);

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _checkLoginStatus(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    // Check if user is logged in
    User? user = auth.currentUser;

    // Navigate based on login status
    if (user != null) {
      // If user is logged in, navigate to HomeScreen
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // If not logged in, navigate to LoginScreen
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
