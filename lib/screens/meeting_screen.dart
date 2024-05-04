import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import '../widgets/home_meeting_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({Key? key}) : super(key: key);

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  final JitsiMeetWrapper _jitsiMeetWrapper = JitsiMeetWrapper();

  createNewMeeting() async {
    try {
      var random = Random();
      String roomName = (random.nextInt(10000000) + 10000000).toString();

      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Join the meeting as a host
        var options = JitsiMeetingOptions(
          roomNameOrUrl: roomName,
          serverUrl: "https://meet.ur.de",
          isAudioMuted: false,
          isVideoMuted: false,
          userDisplayName: "Host User",
        );

        await JitsiMeetWrapper.joinMeeting(
          options: options,
        );

        // Store the meeting details in Firestore and return the document ID
        DocumentReference docRef =
            await FirebaseFirestore.instance.collection('meetings').add({
          'roomName': roomName,
          'userId': user.uid,
          'userName': user.displayName ?? '',
          'userEmail': user.email ?? '',
        });

        return docRef.id;
      }
    } catch (error) {
      print('Error creating meeting: $error');
      // Handle the error gracefully, e.g., show a snackbar or dialog to the user
    }
  }

  joinMeeting(BuildContext context) {
    Navigator.pushNamed(context, '/video-call');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            HomeMeetingButton(
              onPressed: () => createNewMeeting(),
              text: 'New Meeting',
              icon: Icons.videocam,
            ),
            HomeMeetingButton(
              onPressed: () => joinMeeting(context),
              text: 'Join Meeting',
              icon: Icons.add_box_rounded,
            ),
          ],
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Create/Join Video Conference with just a click',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
