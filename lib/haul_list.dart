import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HaulList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posted Hauls'),
        backgroundColor: Color(0xFF08B480),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('PostHaul').snapshots(),
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
              final haul = hauls[index];
              final origin = haul['origin'] ?? 'Unknown Origin';
              final destination = haul['destination'] ?? 'Unknown Destination';
              final date = haul['date'] as Timestamp?;
              final time = haul['time'] ?? 'Unknown Time';
              final vehicleType = haul['vehicleType'] ?? 'Unknown Vehicle Type';

              DateTime? parsedDate;
              if (date != null) {
                parsedDate = date.toDate(); // Convert Timestamp to DateTime
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: GestureDetector(
                  onTap: () {
                    print("Click");
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
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
                          Text('Date: ${parsedDate != null ? DateFormat('yyyy-MM-dd').format(parsedDate) : 'Unknown Date'}'), // Format the date
                          Text('Time: $time'),
                          Text('Vehicle Type: $vehicleType'),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FloatingActionButton(
                                onPressed: () {
                                  FirebaseFirestore.instance.collection('PostHaul').doc(haul.id).delete()
                                      .then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Post deleted successfully'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  })
                                      .catchError((error) => print('Failed to delete document: $error'));
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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Add Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}