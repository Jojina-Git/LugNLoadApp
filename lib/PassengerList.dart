import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lugnload/CardDetails.dart';

class PassengerList extends StatefulWidget {
  final String location;
  final String destination;

  const PassengerList({
    required this.location,
    required this.destination,
    Key? key,
  }) : super(key: key);

  @override
  State<PassengerList> createState() => _PassengerListState();
}

class _PassengerListState extends State<PassengerList> {
  late final Future<void> _firebaseInitialization;

  @override
  void initState() {
    super.initState();
    _firebaseInitialization = Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseInitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF79AC78),
              title: Text('Passenger List'),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('PostHaul')
                  .where('origin', isEqualTo: widget.location)
                  .where('destination', isEqualTo: widget.destination)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final data = snapshot.requireData;

                if (data.size == 0) {
                  return Center(child: Text('No passengers found.'));
                }

                return ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    var passenger = data.docs[index];
                    var items = List<Map<String, dynamic>>.from(passenger['items']);

                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CardDetails(passenger: passenger, items: items))
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.all(10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              ...items.map((item) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //Text('${item['name']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      Text('Pick Up: ${passenger['origin']}', style: TextStyle(fontSize: 16)),
                                      Text('Destination: ${passenger['destination']}', style: TextStyle(fontSize: 16)),
                                      Text('Vehicle Type: ${passenger['vehicleType']}', style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
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

        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: PassengerList(location: 'Location1', destination: 'Destination1'),
  ));
}
