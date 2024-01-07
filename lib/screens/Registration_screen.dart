import 'package:flutter/material.dart';
import 'package:coiffinder/screens/login_screen.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationController extends GetxController {
  var isSalonOwner = false.obs;
}

class RegistrationScreen extends StatelessWidget {
  final RegistrationController controller = Get.put(RegistrationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  controller.isSalonOwner.value = false;
                  Get.to(() => RegistrationForm(
                        title: 'Service Seeker Registration',
                        onRegister: () {
                          Get.offAll(() => LoginScreen());
                        },
                        isSalonOwner: false,
                      ));
                },
                child: Text('Service Seeker', style: TextStyle(color: Colors.pink)),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.isSalonOwner.value = true;
                  Get.to(() => RegistrationForm(
                        title: 'Salon Owner Registration',
                        onRegister: () {
                          Get.off(() => ApprovalProcessScreen());
                        },
                        isSalonOwner: true,
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  elevation: 8,
                  shadowColor: Colors.pink,
                ),
                child: Text('Salon Owner', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegistrationForm extends StatelessWidget {
  final String title;
  final VoidCallback onRegister;
  final bool isSalonOwner;

  // Add controllers for email and password
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  RegistrationForm({Key? key, required this.title, required this.onRegister, required this.isSalonOwner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextFormField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Check if passwords match
                if (passwordController.text != confirmPasswordController.text) {
                  // Passwords do not match, show an error message or handle accordingly
                  return;
                }

                try {
                  // Register the user using Firebase Authentication
                  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  // Set the user role and account activation status in the Firestore database
                  await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
                    'role': isSalonOwner,
                    'fullName': fullNameController.text,
                    'isActive': isSalonOwner ? false : true, // Set 'isActive' to false only for Salon Owners
                  });

                  // Call onRegister to navigate to the appropriate screen
                  onRegister();
                } catch (e) {
                  // Handle registration errors, e.g., display an error message
                  print('Error during registration: $e');
                }
              },
              child: Text('Register', style: TextStyle(color: Colors.pink)),
            ),
          ],
        ),
      ),
    );
  }
}

class ApprovalProcessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration Pending Approval')),
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Thank you for your registration!'),
              Text('Your registration is pending approval.'),
              Text('The approval process may take up to 3 days.'),
              ElevatedButton(
                onPressed: () {
                  Get.off(() => ContactUsScreen());
                },
                child: Text('Contact Us', style: TextStyle(color: Colors.pink)),
              ),
              ElevatedButton(
                onPressed: () {
                  // Pop until you reach the login page
                  
                    FirebaseAuth.instance.signOut();
                },
                child: Text('Go back to Login', style: TextStyle(color: Colors.pink)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Us')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('If you have any concerns or questions, please reach out to us:'),
            Text('Email: contact@example.com'),
          ],
        ),
      ),
    );
  }
}
