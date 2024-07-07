import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'driverhaulList_detailsview.dart';

class DriverHaulList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posted Hauls'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('DriverPostHaul').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final hauls = snapshot.data!.docs;
          return ListView.builder(
            itemCount: hauls.length,
            itemBuilder: (context, index) {
              final haul = hauls[index].data();
              final origin = haul['origin'] ?? 'Unknown';
              final destination = haul['destination'] ?? 'Unknown';
              final date = (haul['date'] as Timestamp?)?.toDate() ?? DateTime.now();
              final time = haul['time'] ?? 'Unknown';
              final vehicleType = haul['vehicleType'] ?? 'Unknown';
              final driverName = haul['driverName'] ?? 'Unknown';
              final profileImageUrl = haul['profileImageUrl'];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DriverHaulListDetailsView(snapshot: hauls[index])),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (profileImageUrl != null && profileImageUrl.isNotEmpty)
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(profileImageUrl),
                                ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Origin: $origin',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Destination: $destination',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text('Date: ${date.toString().substring(0, 10)}'),
                                    Text('Time: $time'),
                                    Text('Vehicle Type: $vehicleType'),
                                    Text('Driver Name: $driverName'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FloatingActionButton(
                                onPressed: () {
                                  FirebaseFirestore.instance.collection('DriverPostHaul').doc(hauls[index].id).delete().then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Post deleted successfully!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }).catchError((error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to delete post: $error'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  });
                                },
                                child: Icon(Icons.delete),
                                backgroundColor: Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
