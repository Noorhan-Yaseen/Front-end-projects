import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_button.dart';

class Loginscreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _signIn(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Check if user is authenticated and navigate accordingly
      if (userCredential.user != null) {
        // Navigate to HomeScreen upon successful login
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Handle unsuccessful login (invalid credentials)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid credentials. Please try again.')),
        );
      }
    } catch (e) {
      // Handle login errors here
      print('Login error: $e');
      // Show error message using SnackBar or AlertDialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Welcome Back!',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
                )),
            SizedBox(height: 50.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            CustomButton(
              text: 'Login',
              onPressed: () {
                _signIn(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
