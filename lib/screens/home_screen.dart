import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myp/screens/history_meeting_screen.dart';
import 'package:myp/screens/login.dart';
import 'package:myp/screens/meeting_screen.dart';
import 'package:myp/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;

  onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  List<Widget> pages = [
    MeetingScreen(),
    HistoryMeetingScreen(),
    Builder(
      builder: (context) => CustomButton(
        text: 'Log Out',
        onPressed: () => CustomButton.logout(context),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text('Meet & Chat'),
        centerTitle: true,
      ),
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: footerColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: onPageChanged,
        currentIndex: _page,
        type: BottomNavigationBarType.fixed,
        unselectedFontSize: 14,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.comment_bank,
            ),
            label: 'Meet & Char',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.lock_clock,
            ),
            label: 'Meetings',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_outlined,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final Future<void> Function() onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85, // 85% of screen width
        child: TextButton(
          onPressed: () => onPressed(),
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.redAccent, // Use a danger color
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20.0), // Adjust the border radius
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              const SizedBox(width: 10.0),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Loginscreen()),
      (Route<dynamic> route) => false,
    );
  }
}
