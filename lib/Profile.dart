import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String email;
  const Profile({required this.email});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<QuerySnapshot> _userDetails;

  @override
  void initState() {
    super.initState();
    _userDetails = FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: widget.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF79AC78),
        title: Text('Profile Details'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _userDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No user details found.'));
          } else {
            // Extract the first document from the QuerySnapshot
            var userDoc = snapshot.data!.docs.first;
            var userData = userDoc.data() as Map<String, dynamic>;
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,

                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, // Adjust height based on content
                        children: [
                          Padding(padding: EdgeInsets.all(20),),
                          Text(
                            'Name: ${userData['firstName'] ?? 'N/A'} ${userData['lastName'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Email: ${userData['email'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Address: ${userData['homeAddress'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Age: ${userData['age'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Gender: ${userData['gender'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 20),
                          ),

                          SizedBox(height: 20),
                          Text(
                            'Bio',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${userData['bio'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Padding(padding: EdgeInsets.all(20),),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}