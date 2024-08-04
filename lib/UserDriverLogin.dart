import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'shared_preferences_service.dart';
import 'registration_page.dart';
import 'login.dart';

import 'main.dart';

class UserDriverLogin extends StatefulWidget {
  const UserDriverLogin({Key? key}) : super(key: key);

  @override
  _UserDriverLoginState createState() => _UserDriverLoginState();
}

class _UserDriverLoginState extends State<UserDriverLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Registration Button
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                  );
                },
                child: const Text('Register'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF08B480),
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
            // Login Button
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text('Login'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF08B480),
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loginAsUser() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await SharedPreferencesService.saveLoginState(true, 'user');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login failed: $e'),
      ));
    }
  }

  Future<void> _loginAsDriver() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await SharedPreferencesService.saveLoginState(true, 'driver');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login failed: $e')),
      );
    }
  }
}