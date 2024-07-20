import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lugnload/DriverLogin.dart';
import 'package:lugnload/main.dart';

class UserDriverLogin extends StatefulWidget {
  const UserDriverLogin({super.key});

  @override
  State<UserDriverLogin> createState() => _DriverLoginState();
}

class _DriverLoginState extends State<UserDriverLogin> {
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF08B480),
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              child: Text('Login as user'),
            ),

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
                  MaterialPageRoute(builder: (context) => DriverLogin()),
                );
              },
              child: Text('Login as Driver'),
            ),
            )
          ],
        ),
      ),
    );
  }
}
