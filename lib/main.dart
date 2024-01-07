import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:new_flutter_project/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: SnappingList()),
    );
  }
}

class SnappingList extends StatefulWidget {
  const SnappingList({Key? key}) : super(key: key);

  @override
  _SnappingListState createState() => _SnappingListState();
}

class _SnappingListState extends State<SnappingList> {
  List<Product> productList = [
    Product('assets/images/reduc7.jpg'),
    Product('assets/images/reduc4.jpg'),
    Product('assets/images/reduc5.jpg'),
    Product('assets/images/reduc6.jpg'),
    Product('assets/images/reduc3.jpg'),
  ];
  List<Service> serviceList = [
    Service('assets/images/serives.png'),
    //Service('Massage', 'assets/images/reduc7.jpg'),
    //Service('Manicure', 'assets/images/reduc7.jpg'),
    //Service('Pedicure', 'assets/icons/pedicure_icon.png'),
    //Service('Facial', 'assets/icons/facial_icon.png'),
  ];

  Widget _buildListItem(BuildContext context, int index) {
    Product product = productList[index];
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: 350,
        height: 350,
        child: Card(
          elevation: 12,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  product.imagePath,
                  fit: BoxFit.cover,
                  width: 350,
                  height: 250,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("SPECIAL OFFER"),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Liste horizontale des promotions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  return _buildListItem(context, index);
                },
              ),
            ),

            // Liste verticale des services
            SizedBox(height: 20),

            AppBar(
              centerTitle: true,
              title: Text(
                'Services',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.pink,
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: serviceList.length,
                itemBuilder: (context, index) {
                  Service service = serviceList[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(height: 0),
                        Image.asset(
                          service.iconPath,
                          width: 380,
                          height: 380,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
