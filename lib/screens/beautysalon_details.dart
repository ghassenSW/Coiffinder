import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BeautySalonDetailsPage extends StatelessWidget {
  final String salonId;
  final String userId;

  BeautySalonDetailsPage({required this.salonId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('salons').doc(salonId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Text('Salon details not found.');
            }

            var salonData = snapshot.data!.data() as Map<String, dynamic>;

            return Text(salonData['name']);
          },
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('salons').doc(salonId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Salon details not found.'));
          }

          var salonData = snapshot.data!.data() as Map<String, dynamic>;

          return Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Salon Name: ${salonData['name']}',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                SizedBox(height: 24.0),
                Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                Text(
                  salonData['description'] ?? 'No description available.',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Location:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                Text(
                  salonData['location'] ?? 'No location available.',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Services Available:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                SizedBox(height: 16.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (salonData['Services'] != null)
                        ...(salonData['Services'] as Map<String, dynamic>).entries.map((entry) {
                          return GestureDetector(
                            onTap: () {
                              // Navigate to the booking page or handle the click event
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingPage(
                                    userId: userId,
                                    salonId: salonId,
                                    serviceName: entry.key,
                                    price: entry.value,
                                  ),
                                ),
                              );
                            },
                            child: ServiceCard(entry.key, entry.value),
                          );
                        }).toList(),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String serviceName;
  final dynamic price;

  ServiceCard(this.serviceName, this.price);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.0,
      margin: EdgeInsets.only(right: 16.0),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                serviceName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(price.toString()),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingPage extends StatefulWidget {
  final String serviceName;
  final dynamic price;
  final String salonId;
  final String userId; // Add user ID to the constructor

  BookingPage({
    required this.serviceName,
    required this.price,
    required this.salonId,
    required this.userId,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String selectedStylist = '';
  List<Map<String, dynamic>> stylistList = [];
  DateTime? _selectedDay;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.serviceName}'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service: ${widget.serviceName}',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Price: ${widget.price}',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Select Stylist:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('staff')
                  .where('speciality', isEqualTo: widget.serviceName)
                  .where('salon_id', isEqualTo: widget.salonId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No stylists found.');
                }

                stylistList = snapshot.data!.docs
                    .map((document) => document.data() as Map<String, dynamic>)
                    .toList();

                return Container(
                  height: 100.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: stylistList.length,
                    itemBuilder: (context, index) {
                      var stylist = stylistList[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedStylist = stylist['name'];
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: stylist['image'] != null ? null : const Color.fromARGB(255, 230, 110, 150),
                            image: stylist['image'] != null
                                ? DecorationImage(
                                    image: NetworkImage(stylist['image']),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              stylist['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: stylist['image'] != null ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Select Date:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null) {
                  setState(() {
                    _selectedDay = pickedDate;
                  });
                }
              },
              child: Text('Pick Date'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Select Time Slot:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime != null) {
                  setState(() {
                    _selectedTime = pickedTime;
                  });
                }
              },
              child: Text('Pick Time'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _bookAppointment();
              },
              child: Text('Book Appointment'),
            ),
          ],
        ),
      ),
    );
  }

  void _bookAppointment() {
    if (_selectedDay != null && _selectedTime != null) {
      FirebaseFirestore.instance.collection('reservations').add({
        'salon_id': widget.salonId,
        'stylist_id': selectedStylist,
        'time': _selectedTime!.hour,
        'date': _selectedDay!.toLocal(),
        'user_id': widget.userId,
      });


    } else {
      print('Please select both date and time.');
    }
  }
}
