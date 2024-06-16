
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'DriverDetails.dart';

class Searchresult extends StatefulWidget {
  final String pickup;
  final String destination;
  final String selectedVehicleType;
  final String date;
  final String time;

  const Searchresult(
      this.pickup,
      this.destination,
      this.selectedVehicleType,
      this.date,
      this.time, {
        Key? key,
      }) : super(key: key);

  @override
  State<Searchresult> createState() => _SearchresultState();
}

class _SearchresultState extends State<Searchresult> {
  List<DriverData> filteredData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData(widget.pickup, widget.destination, widget.selectedVehicleType, widget.date, widget.time);
  }

  Future<void> fetchData(String pickup, String destination, String selectedVehicleType, String date, String time) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('Driver')
          .where('From', isEqualTo: pickup)
          .where('Destination', isEqualTo: destination)
          .where('VType', isEqualTo: selectedVehicleType)
          .where('Date', isEqualTo: date)
          .get();

      List<QueryDocumentSnapshot> docs = querySnapshot.docs;
      List<DriverData> drivers = docs.map((doc) => DriverData.fromFirestore(doc)).toList();
      print(drivers);

      setState(() {
        filteredData = drivers;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF79AC78),
        title: Text("LugNload"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: filteredData.length,
          itemBuilder: (context, index) {
            final data = filteredData[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DriverDetails(data: data),
                  ),
                );
              },
              child: Card(
                elevation: 4.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(color: Colors.white10, width: 1.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.driverName,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Car Name: ${data.car}',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            Text(
                              'Starting Location: ${data.pickupLocation}',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              'Destination: ${data.destination}',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Fare: \$${data.fare}',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage: NetworkImage(data.imageUrl),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


class SearchData {
  final String pickupLocation;
  final String destination;
  final DateTime date;
  final TimeOfDay time;
  final String vehicleType;
  final String car;
  final String fare;
  final String drivername;

  SearchData({
    required this.pickupLocation,
    required this.destination,
    required this.date,
    required this.time,
    required this.vehicleType,
    required this.car,
    required this.fare,
    required this.drivername,
  });
}

class DriverData {
  final String id;
  final String driverName;
  final String car;
  final String pickupLocation;
  final String destination;
  final double fare;
  final String imageUrl;

  DriverData({
    required this.id,
    required this.driverName,
    required this.car,
    required this.pickupLocation,
    required this.destination,
    required this.fare,
    required this.imageUrl,
  });

  factory DriverData.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return DriverData(
      id: doc.id,
      driverName: data['DriverName'] ?? '',
      car: data['Car'] ?? '',
      pickupLocation: data['From'] ?? '',
      destination: data['Destination'] ?? '',
      fare: data['Price'] ?? 0.0,
      imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150',
    );
  }
}
