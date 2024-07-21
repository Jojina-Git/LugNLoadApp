import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverHaulListDetailsView extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> snapshot;

  DriverHaulListDetailsView({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final data = snapshot.data();
    final origin = data['origin'] ?? 'Unknown';
    final destination = data['destination'] ?? 'Unknown';
    final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();
    final time = data['time'] ?? 'Unknown';
    final fare = data['fare'] ?? 'Unknown';
    final vehicleType = data['vehicleType'] ?? 'Unknown';
    final driverName = data['driverName'] ?? 'Unknown';
    final carName = data['carName'] ?? 'Unknown';
    final shared = data['shared'] ?? false;
    final seat = data['seat'] ?? false;
    final profileImageUrl = data['profileImageUrl'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Haul Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: profileImageUrl != null
                        ? ClipOval(
                      child: Image.network(
                        profileImageUrl,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Origin: $origin', style: TextStyle(fontSize: 18)),
                  Text('Destination: $destination', style: TextStyle(fontSize: 18)),
                  Text('Date: ${date.toString().substring(0, 10)}', style: TextStyle(fontSize: 18)),
                  Text('Time: $time', style: TextStyle(fontSize: 18)),
                  Text('Fare: \$${fare.toString()}', style: TextStyle(fontSize: 18)),
                  Text('Vehicle Type: $vehicleType', style: TextStyle(fontSize: 18)),
                  Text('Driver Name: $driverName', style: TextStyle(fontSize: 18)),
                  Text('Car Name: $carName', style: TextStyle(fontSize: 18)),
                  Text('Shared: ${shared ? 'Yes' : 'No'}', style: TextStyle(fontSize: 18)),
                  Text('Seat: ${seat ? 'Yes' : 'No'}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete Confirmation'),
                                content: Text('Are you sure you want to delete this haul?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Delete'),
                                    onPressed: () {
                                      // Perform delete operation
                                      FirebaseFirestore.instance.collection('DriverPostHaul').doc(snapshot.id).delete().then((_) {
                                        Navigator.pop(context); // Close dialog
                                        Navigator.pop(context); // Pop details view screen
                                      }).catchError((error) {
                                        print('Failed to delete document: $error');
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
