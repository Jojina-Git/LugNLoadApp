import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Requests extends StatefulWidget {
  const Requests({Key? key}) : super(key: key);

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  Future<List<Map<String, dynamic>>> _fetchRequests() async {
    try {
      QuerySnapshot requestSnapshot = await FirebaseFirestore.instance.collection('userrequest').get();

      List<Map<String, dynamic>> requests = [];

      for (QueryDocumentSnapshot requestDoc in requestSnapshot.docs) {
        String driverId = requestDoc['driverId'];

        DocumentSnapshot driverDoc = await FirebaseFirestore.instance.collection('Driver').doc(driverId).get();

        requests.add({
          'id': requestDoc.id,
          'driverName': driverDoc['DriverName'],
          'car': driverDoc['Car'],
          'from': driverDoc['From'],
          'to': driverDoc['Destination'],
        });
      }

      return requests;
    } catch (e) {
      print('Error fetching requests: $e');
      return [];
    }
  }

  void deleteRequest(String id) {
    FirebaseFirestore.instance.collection('userrequest').doc(id).delete().then((_) {
      setState(() {
        _fetchRequests();
      });
    }).catchError((error) {
      print('Error deleting request: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching requests'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No requests found'));
          } else {
            List<Map<String, dynamic>> requests = snapshot.data!;
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
                    title: Text('Driver Name: ${request['driverName']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Car: ${request['car']}'),
                        Text('From: ${request['from']}'),
                        Text('To: ${request['to']}'),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Color(0xFF08B480),
                                    shape: StadiumBorder(),
                                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                  ),
                                  onPressed: () => deleteRequest(request['id']), child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                ),
                              ],
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
