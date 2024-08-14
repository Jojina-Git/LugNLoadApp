import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'DriverLogin.dart';
import 'UserDriverLogin.dart';
import 'shared_preferences_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _loginUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    bool loginSuccessful = await _authenticateUser(email, password);
    if (loginSuccessful) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserTypeSelectionPage()),
      );
    } else {
      _showErrorDialog('Invalid login credentials');
    }
  }

  Future<bool> _authenticateUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user != null;
    } catch (e) {
      return false;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Color(0xFF08B480),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Login',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF08B480),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            _buildTextField(
              controller: _emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _passwordController,
              labelText: 'Password',
              obscureText: true,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loginUser,
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color(0xFF08B480),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                elevation: 5, // Adds shadow to the button
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(color: Colors.black54),
      ),
    );
  }
}




class UserTypeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF08B480), // Updated color for consistency
        title: Text("LugNload"),
        centerTitle: true, // Center the title
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Center the column's children horizontally
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF08B480), // Button color
                  foregroundColor: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Updated text style
                ),
                onPressed: () async {
                  await SharedPreferencesService.saveLoginState(true, 'user');
                  Navigator.pushReplacementNamed(context, '/userHomePage');
                },

                
                child: Text('Continue as User'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF08B480), // Button color
                  foregroundColor: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Updated text style
                ),
                onPressed: () async {
                  await SharedPreferencesService.saveLoginState(true, 'driver');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DriverLogin()),
                  );
                },
                child: Text('Continue as Driver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}