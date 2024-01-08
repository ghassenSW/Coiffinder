import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coiffinder/main.dart';
import 'package:coiffinder/screens/home_screen.dart';




class MyReservationsPage extends StatelessWidget {
  final String userId;

  MyReservationsPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Reservations')),
      drawer: AppDrawer(),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('reservations')
            .where('user_id', isEqualTo: userId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var reservations = snapshot.data?.docs ?? [];

          if (reservations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No reservations found.'),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    child: Text('Explore Salons'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              var reservationData = reservations[index].data() as Map<String, dynamic>;
              return ReservationCard(
                salonId: reservationData['salon_id'],
                date: reservationData['date'].toDate(),
                time: reservationData['time'],
              );
            },
          );
        },
      ),
      
    );
  }
}

class ReservationCard extends StatelessWidget {
  final String salonId;
  final DateTime date;
  final int time;

  ReservationCard({required this.salonId, required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('salons').doc(salonId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Loading...'),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Error loading salon details'),
            ),
          );
        }

        var salonData = snapshot.data!.data() as Map<String, dynamic>;

        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            title: Text('Salon: ${salonData['name']}'),
            subtitle: Text('Date: ${date.toString()}, Time: $time'),
            // TODO: Add onTap functionality to navigate to SalonDetailsPage or a similar page
            onTap: () {
              // Navigate to salon details or handle the tap event
            },
          ),
        );
      },
    );
  }
}
