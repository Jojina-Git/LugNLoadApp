import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Model class for PostHaul data
class PostHaul {
  final String id;
  final String name;
  final String destination;

  PostHaul({
    required this.id,
    required this.name,
    required this.destination,
  });
}

class DriverBookings extends StatefulWidget {
  const DriverBookings({Key? key}) : super(key: key);

  @override
  State<DriverBookings> createState() => _DriverBookingsState();
}

class _DriverBookingsState extends State<DriverBookings> {
  late Future<List<PostHaul>> _postHaulFuture;

  Future<List<PostHaul>> _fetchRequests() async {
    try {
      QuerySnapshot requestSnapshot =
      await FirebaseFirestore.instance.collection('driverRequest').get();

      List<PostHaul> requests = [];

      for (QueryDocumentSnapshot requestDoc in requestSnapshot.docs) {
        String driverId = requestDoc['driverId'];

        DocumentSnapshot driverDoc =
        await FirebaseFirestore.instance.collection('PostHaul').doc(driverId).get();

        if (driverDoc.exists) {
          requests.add(PostHaul(
            id: requestDoc.id,
            name: driverDoc['origin'], // Corrected to 'name'
            destination: driverDoc['destination'], // Corrected to 'destination'
          ));
        } else {
          print('Document does not exist for driverId: $driverId');
        }
      }

      return requests;
    } catch (e) {
      print('Error fetching requests: $e');
      throw Exception('Failed to fetch requests');
    }
  }

  void deleteRequest(String id) {
    FirebaseFirestore.instance.collection('driverRequest').doc(id).delete().then((_) {
      setState(() {
        _postHaulFuture = _fetchRequests();
      });
    }).catchError((error) {
      print('Error deleting request: $error');
    });
  }

  @override
  void initState() {
    super.initState();
    _postHaulFuture = _fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
      ),
      body: FutureBuilder<List<PostHaul>>(
        future: _postHaulFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching requests'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No requests found'));
          } else {
            List<PostHaul> requests = snapshot.data!;
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: Colors.white10, width: 1.0),
                  ),
                  child: ListTile(
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('From: ${request.name}'),
                        Text('Destination: ${request.destination}'),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF08B480),
                                shape: StadiumBorder(),
                                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                              ),
                              onPressed: () => deleteRequest(request.id),
                              child: Text(
                                'Delete',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
