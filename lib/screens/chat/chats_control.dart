import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/screens/chat/contacts_list_screen.dart';
import 'package:whatsapp_clone/screens/chat/empty_contacts_screen.dart';

class ChatControl extends StatelessWidget {
  final String userId;

  const ChatControl({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Chats')
          .where('participants', arrayContains: userId)
          .orderBy('lastMessageTime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const EmptyContactsScreen();
        }
        for (var doc in docs) {}
        return FutureBuilder<List<ChatContact>>(
          future: Future.wait(
            docs.map((doc) async {
              final data = doc.data() as Map<String, dynamic>;

              final participants = data['participants'] as List<dynamic>? ?? [];

              if (participants.isEmpty) {
                return null;
              }

              final otherUid = participants.firstWhere(
                (uid) => uid != userId,
                orElse: () => null,
              );

              if (otherUid == null) {
                return null;
              }
              final otherUserDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(otherUid)
                  .get();

              if (!otherUserDoc.exists) {
                return null;
              }
              final otherUserData = otherUserDoc.data() ?? {};

              return ChatContact.fromMap(data, doc.id, userId, otherUserData);
            }),
          ).then((list) => list.whereType<ChatContact>().toList()),
          builder: (context, chatSnapshot) {
            if (chatSnapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading chats: ${chatSnapshot.error}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
            if (!chatSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final chats = chatSnapshot.data!;

            if (chats.isEmpty) {
              return const EmptyContactsScreen();
            }
            return ContactsListScreen(contacts: chats);
          },
        );
      },
    );
  }
}
