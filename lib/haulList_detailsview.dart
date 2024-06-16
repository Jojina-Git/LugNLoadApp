import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HaulListDetailsView extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> snapshot;

  HaulListDetailsView({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    // Extract data from the snapshot
    final origin = snapshot['origin'] ?? 'Unknown Origin';
    final destination = snapshot['destination'] ?? 'Unknown Destination';
    final date = snapshot['date'] as Timestamp?;
    final time = snapshot['time'] ?? 'Unknown Time';
    final message = snapshot['message'] ?? 'No message';
    final vehicleType = snapshot['vehicleType'] ?? 'Unknown Vehicle Type';
    final items = List<Map<String, dynamic>>.from(snapshot['items'] ?? []);
    final shared = snapshot['shared'] ?? 'Unknown';
    final seat = snapshot['seat'] ?? 'Unknown';
    final created = snapshot['created'] as Timestamp?;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Haul Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF08B480),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Origin: $origin',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Destination: $destination',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${date != null ? date.toDate().toString().substring(0, 10) : 'Unknown Date'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Time: $time',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Message: $message',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Vehicle Type: $vehicleType',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Items:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            if (items.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items
                    .map((item) => Text(
                  '- Name: ${item['name']}, Number: ${item['number']}, Size: ${item['length']}x${item['width']}x${item['height']}',
                  style: TextStyle(fontSize: 16),
                ))
                    .toList(),
              ),
            SizedBox(height: 8),
            Text(
              'Shared: $shared',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Seat: $seat',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Created: ${created != null ? created.toDate().toString() : 'Unknown'}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}