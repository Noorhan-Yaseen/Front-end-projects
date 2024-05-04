import 'package:flutter/material.dart';
// import 'package:zoom_clone/utils/colors.dart';

import '../widgets/custom_button.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foom: Video Conference App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Start or join a meeting',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Image.network(
              'https://raw.githubusercontent.com/shubhamsingh74/Zoom-Clone/master/assets/images/onboarding.png',
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Login',
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Does not have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signIn');
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 185, 213, 240)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
