import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myp/screens/MainScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foom: Video Conference App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.blueGrey[900],
      ),
      home: StreamBuilder(
        stream: Stream.value(false), // Replace with your authentication stream
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data == true) {
            return const MainScreen(); // Replace with your authenticated screen
          }
          return const ZoomSplashScreen(); // Splash screen shown for non-authenticated users
        },
      ),
    );
  }
}

class ZoomSplashScreen extends StatefulWidget {
  const ZoomSplashScreen({Key? key}) : super(key: key);

  @override
  _ZoomSplashScreenState createState() => _ZoomSplashScreenState();
}

class _ZoomSplashScreenState extends State<ZoomSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(14, 114, 236, 1),
              Color.fromRGBO(46, 46, 46, 1)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam,
              size: 120,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              'Foom: Video Conference App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
