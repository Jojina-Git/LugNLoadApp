import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lugnload/Search.dart';
import 'haul_form.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
                      MaterialPageRoute(builder: (context) => Search()),
                    );
                  },
                  child: Text('Find Haul Post'),
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
                        MaterialPageRoute(builder: (context) => HaulForm()),//navigate to the page
                      );
                    },
                    child: Text('Create Haul Posts'),
                  ),
                )

            ],
          ),
        ),
      ),
    );
  }
}
