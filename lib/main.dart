import 'package:coiffinder/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coiffinder/screens/home_screen.dart';
import 'package:coiffinder/screens/reservations_screen.dart';
import 'package:coiffinder/screens/salons_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context)  {
    return Container (
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.pink, Colors.deepPurple], // Example gradient colors
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 29.0,
                        color: Colors.pink,
                      ),
                    )),
              ),
              ListTile(
                title: Text('Home'),
                onTap: () {
                  Get.to(() => HomePage());
                },
              ),
              ListTile(
                title: Text('My Reservations'),
                onTap: () {
                  Get.to(() => MyReservationsPage(userId: FirebaseAuth.instance.currentUser!.uid,));
                },
              ),
              ListTile(
                title: Text('Salons'),
                onTap: () {
                  Get.to(() => SalonsPage());
                },
              ),
              ListTile(
                title: Text('Logout'), // Add a logout option
                onTap: () {
                  // Implement your logout logic here
                  // For example, you can clear user authentication and navigate to the login screen
                  // Replace the next line with your actual logout implementation
                 FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
        ));
  }
}
