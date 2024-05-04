import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryMeetingScreen extends StatelessWidget {
  const HistoryMeetingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('meetings')
          .where('userId', isEqualTo: user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text('No data available'),
          );
        }

        final List<DocumentSnapshot> documents = snapshot.data!.docs;

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final meetingData = documents[index].data() as Map<String, dynamic>;

            final roomName = meetingData['roomName'] ?? '';
            final userEmail = meetingData['userEmail'] ?? '';
            final userId = meetingData['userId'] ?? '';
            final userName = meetingData['userName'] ?? '';
            final meetingName = meetingData['meetingName'] ?? '';
            final createdAt = meetingData['createdAt'] != null
                ? (meetingData['createdAt'] as Timestamp).toDate()
                : null;
            final formattedDate =
                createdAt != null ? DateFormat.yMMMd().format(createdAt) : '';

            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: ListTile(
                title: Text('Room Name: $roomName'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User Email: $userEmail'),
                    Text('User ID: $userId'),
                    Text('User Name: $userName'),
                    Text('Joined on $formattedDate'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.red, // Danger color
                  onPressed: () async {
                    // Show a confirmation dialog
                    bool shouldDelete = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Meeting'),
                        content: Text(
                            'Are you sure you want to delete this meeting?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    // Delete the meeting if the user confirmed
                    if (shouldDelete == true) {
                      try {
                        await FirebaseFirestore.instance
                            .collection('meetings')
                            .doc(documents[index].id)
                            .delete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Meeting deleted successfully'),
                          ),
                        );
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error deleting meeting: $error'),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
