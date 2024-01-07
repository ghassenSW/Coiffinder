import 'package:coiffinder/screens/login_screen.dart';
import 'package:coiffinder/screens/salonowner_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coiffinder/screens/home_screen.dart';
import 'package:coiffinder/screens/Registration_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading state while checking authentication state
            return CircularProgressIndicator();
          }

          // Check if user is logged in
          if (snapshot.hasData) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  // Loading state while fetching user data
                  return CircularProgressIndicator();
                }

                if (userSnapshot.hasData) {
                  // Access the user's role and isActive status
                  var userData =
                      userSnapshot.data?.data() as Map<String, dynamic>;
                  var isSalonOwner = userData['role'] ?? false;
                  var isActive = userData['isActive'] ?? false;

                  // Check if the account is active
                  if (isActive) {
                    // Use the user's role to navigate
                    if (isSalonOwner) {
                      // Navigate to salon owner screen
                      print('User is a Salon Owner');
                      return SalonOwnerScreen();
                    } else {
                      // Navigate to regular user screen
                      print('User is a Regular User');
                      return HomePage();
                    }
                  } else {
                    // Account is not active, show an appropriate message or take necessary action
                    // For example, show an error message or navigate to an inactive account screen
                    print('Account is not active');
                    return ApprovalProcessScreen();
                  }
                } else {
                  // Handle the case where user data is null
                  print('User data not found');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Trigger sign-out when the button is pressed
                            FirebaseAuth.instance.signOut();
                          },
                          child: Text('Logout'),
                        ),
                        Text('You are not logged in.'),
                        // Add other login options or widgets as needed
                      ],
                    ),
                  );
                }
              },
            );
          } else {
            // User not logged in
            print('User not logged in');
            return LoginScreen();
          }
        },
      ),
    );
  }
}