import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lugnload/Profile.dart';
import 'DriverLogin.dart';
import 'UserDriverLogin.dart';
import 'main.dart';
import 'shared_preferences_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserTypeSelectionPage(email: _emailController.text.trim())),
        );
        break;
      case 1:
      // Add navigation logic for Search
        break;
      case 2:
      // Add navigation logic for Add Post
        break;
      case 3:
      // Add navigation logic for History
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile(email: _emailController.text.trim())),
        );
        break;
    }
  }

  void _loginUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    bool loginSuccessful = await _authenticateUser(email, password);
    if (loginSuccessful) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserTypeSelectionPage(email: email)),
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
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginUser,
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF08B480),
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserTypeSelectionPage extends StatefulWidget {
  final String email;

  UserTypeSelectionPage({required this.email});

  @override
  _UserTypeSelectionPageState createState() => _UserTypeSelectionPageState();
}

class _UserTypeSelectionPageState extends State<UserTypeSelectionPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserTypeSelectionPage(email: widget.email)),
        );
        break;
      case 1:
      // Add navigation logic for Search
        break;
      case 2:
      // Add navigation logic for Add Post
        break;
      case 3:
      // Add navigation logic for History
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile(email: widget.email)),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF79AC78),
        title: const Text("LugNload"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF08B480),
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
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
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF08B480),
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
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
                  SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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


class _DriverLoginState extends State<UserDriverLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF79AC78),
        title: const Text("LugNload"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              child: Text('Login as User'),
            ),
            SizedBox(height: 20),
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
                  MaterialPageRoute(builder: (context) => DriverLogin()),
                );
              },
              child: Text('Login as Driver'),
            ),
          ],
        ),
      ),
    );
  }
}
