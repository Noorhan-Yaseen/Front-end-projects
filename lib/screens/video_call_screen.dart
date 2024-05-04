import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late TextEditingController roomText;
  late TextEditingController subjectText;
  late TextEditingController userDisplayNameText;
  late TextEditingController userEmailText;

  bool isAudioMuted = true;
  bool isVideoMuted = true;

  @override
  void initState() {
    roomText = TextEditingController();
    subjectText = TextEditingController();
    userDisplayNameText = TextEditingController();
    userEmailText = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    roomText.dispose();
    subjectText.dispose();
    userDisplayNameText.dispose();
    userEmailText.dispose();
    super.dispose();
  }

  _joinMeeting() async {
    Map<String, Object> featureFlags = {};

    // Define meetings options here
    var options = JitsiMeetingOptions(
      roomNameOrUrl: roomText.text,
      serverUrl: "https://meet.ur.de",
      subject: subjectText.text,
      isAudioMuted: isAudioMuted,
      isVideoMuted: isVideoMuted,
      userDisplayName: userDisplayNameText.text,
      userEmail: userEmailText.text,
      featureFlags: featureFlags,
    );

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeetWrapper.joinMeeting(
      options: options,
      listener: JitsiMeetingListener(
        onOpened: () => debugPrint("onOpened"),
        onConferenceWillJoin: (url) {
          debugPrint("onConferenceWillJoin: url: $url");
        },
        onConferenceJoined: (url) {
          debugPrint("onConferenceJoined: url: $url");
        },
        onConferenceTerminated: (url, error) {
          debugPrint("onConferenceTerminated: url: $url, error: $error");
        },
        onAudioMutedChanged: (isMuted) {
          debugPrint("onAudioMutedChanged: isMuted: $isMuted");
        },
        onVideoMutedChanged: (isMuted) {
          debugPrint("onVideoMutedChanged: isMuted: $isMuted");
        },
        onScreenShareToggled: (participantId, isSharing) {
          debugPrint(
            "onScreenShareToggled: participantId: $participantId, "
            "isSharing: $isSharing",
          );
        },
        onParticipantJoined: (email, name, role, participantId) {
          debugPrint(
            "onParticipantJoined: email: $email, name: $name, role: $role, "
            "participantId: $participantId",
          );
        },
        onParticipantLeft: (participantId) {
          debugPrint("onParticipantLeft: participantId: $participantId");
        },
        onParticipantsInfoRetrieved: (participantsInfo, requestId) {
          debugPrint(
            "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
            "requestId: $requestId",
          );
        },
        onChatMessageReceived: (senderId, message, isPrivate) {
          debugPrint(
            "onChatMessageReceived: senderId: $senderId, message: $message, "
            "isPrivate: $isPrivate",
          );
        },
        onChatToggled: (isOpen) => debugPrint("onChatToggled: isOpen: $isOpen"),
        onClosed: () => debugPrint("onClosed"),
      ),
    );
    User? user = FirebaseAuth.instance.currentUser;
    // Store the details in Firestore
    await FirebaseFirestore.instance.collection('meetings').add({
      'roomName': roomText.text,
      'userEmail': userEmailText.text,
      'userId': user?.uid, // Replace with actual user id
      'userName': userDisplayNameText.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Meeting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              labelText: "Room",
              controller: roomText,
            ),
            _buildTextField(
              labelText: "Subject",
              controller: subjectText,
            ),
            _buildTextField(
              labelText: "User Display Name",
              controller: userDisplayNameText,
            ),
            _buildTextField(
              labelText: "User Email",
              controller: userEmailText,
            ),
            CheckboxListTile(
              title: const Text("Audio Muted"),
              value: isAudioMuted,
              onChanged: (value) =>
                  setState(() => isAudioMuted = value ?? false),
            ),
            CheckboxListTile(
              title: const Text("Video Muted"),
              value: isVideoMuted,
              onChanged: (value) =>
                  setState(() => isVideoMuted = value ?? false),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _joinMeeting,
              child: const Text("Join Meeting"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
