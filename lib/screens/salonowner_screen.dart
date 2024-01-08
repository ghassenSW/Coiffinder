import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coiffinder/screens/login_screen.dart';

class SalonOwnerScreen extends StatelessWidget {
  // Sign-out method
  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salon Owner Screen'),
        actions: [
          // Logout Icon
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, Salon Owner!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Add more widgets as needed for Salon Owner features
          ],
        ),
      ),
    );
  }
}
