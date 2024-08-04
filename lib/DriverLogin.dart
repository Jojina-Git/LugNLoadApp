import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lugnload/DriverLocation.dart';

import 'DriverHaulForm.dart';

class DriverLogin extends StatefulWidget {
  const DriverLogin({super.key});

  @override
  State<DriverLogin> createState() => _DriverLoginState();
}

class _DriverLoginState extends State<DriverLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF79AC78),
        title:const Text("LugNload"),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(top: 20),

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF08B480),
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(builder: (context) =>DriverHaulForm()),
                    );
                  },
                  child: Text('Create Post'),
                ),

              ),
              Padding(padding: EdgeInsets.only(top: 20),
                child:ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF08B480),
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DriverLocation()),//navigate to the page
                    );
                  },
                  child: Text('Request Passenger'),
                ),
              )

            ],
          ),
        ),
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
