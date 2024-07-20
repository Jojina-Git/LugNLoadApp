import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lugnload/DriverBookings.dart';

class CardDetails extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> passenger;
  final List<Map<String, dynamic>> items;

  const CardDetails({Key? key, required this.passenger, required this.items}) : super(key: key);

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {

  void _showToast(String id) async {
    try {
      await FirebaseFirestore.instance.collection('driverRequest').add({
        'driverId': id,
      });
      Fluttertoast.showToast(
        msg: "Request Sent",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
        webPosition: "center",
      );
    } catch (e) {
      print('Error sending request: $e');
      Fluttertoast.showToast(
        msg: "Failed to send request",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
        webPosition: "center",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var passenger = widget.passenger;
    var items = widget.items;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF79AC78),
        title: Text('Card Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var item = items[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('From: ${passenger['origin']}', style: TextStyle(fontSize: 16)),
                        Text('Destination: ${passenger['destination']}', style: TextStyle(fontSize: 16)),

                        Text('Name Of Item: ${item['name']}', style: TextStyle(fontSize: 16)),
                        Text('Number of items: ${item['number']}', style: TextStyle(fontSize: 16)),
                        Text('Height: ${item['height']}', style: TextStyle(fontSize: 16)),
                        Text('Width: ${item['width']}', style: TextStyle(fontSize: 16)),
                        Text('Length: ${item['length']}', style: TextStyle(fontSize: 16)),

                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () => _showToast(passenger.id),
                            child: Text('Request Passenger'),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DriverBookings())
                              );
                            },
                            child: Text('View Sent Requests'),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
