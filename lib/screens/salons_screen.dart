import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coiffinder/main.dart';
import 'package:coiffinder/screens/beautysalon_details.dart';




class Salon {
  final String id;
  final String name;
  final String description;
  final String? backgroundImage;
  final Map<String, dynamic> services; // Add a field for the services map

  Salon({
    required this.id,
    required this.name,
    required this.description,
    this.backgroundImage,
    required this.services,
  });
}

class SalonsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Salons')),
      body: SalonList(),
      drawer: AppDrawer(),
    );
  }
}

class SalonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('salons').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Icon(
              Icons.shop,
              size: 100,
              color: Colors.grey,
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemExtent: 100,
          itemBuilder: (context, index) {
            var salonData =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            var salon = Salon(
              id: snapshot.data!.docs[index].id,
              name: salonData['name'] ?? '',
              description: salonData['description'] ?? '',
              backgroundImage: salonData['backgroundImage'],
              services: salonData['Services'] ?? {},
            );

            return Container(
              decoration: salon.backgroundImage != null
                  ? BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(salon.backgroundImage!),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.3),
                          offset: Offset(0, 2),
                          blurRadius: 3,
                          spreadRadius: 1,
                        ),
                      ],
                    )
                  : BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 240, 158, 185)
                              .withOpacity(0.3),
                          offset: Offset(0, 0),
                          blurRadius: 100,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    salon.name,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(salon.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BeautySalonDetailsPage(salonId: salon.id,userId: FirebaseAuth.instance.currentUser!.uid,)),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

