import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'PassengerList.dart';

class DriverLocation extends StatefulWidget {
  const DriverLocation({super.key});

  @override
  State<DriverLocation> createState() => _DriverLocationState();
}

class _DriverLocationState extends State<DriverLocation> {

  final TextEditingController _pickuplocation = TextEditingController();
  final TextEditingController _destination = TextEditingController();

  void searchPassenger(){
    String location = _pickuplocation.text.toString();
    String destination = _destination.text.toString();
    if(location != "" && destination != ""){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PassengerList(location: location, destination: destination),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF79AC78),
        title:const Text("LugNload"),
      ),
      body: Container(
        child: Column(
          children: [
        Padding(
        padding: const EdgeInsets.only(top: 50, left: 8.0, right: 8.0, bottom: 8.0),
        child: TextFormField(
          controller: _pickuplocation,
          decoration: InputDecoration(
            hintText: 'Pickup Location',
            filled: true,
          ),
        ),
      ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _destination,
            decoration: InputDecoration(
              hintText: 'Destination',
              filled: true,
            ),
          ),
        ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF08B480),
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              ),
              onPressed: searchPassenger,
              child: Text(
                'Search',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
