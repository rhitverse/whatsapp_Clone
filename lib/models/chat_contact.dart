import 'package:cloud_firestore/cloud_firestore.dart';

class ChatContact {
  final String chatId;
  final String otherUid;
  final String otherUserName;
  final String otherUserProfilePic;
  final DateTime lastMessageTime;
  final String lastMessage;

  ChatContact({
    required this.chatId,
    required this.otherUid,
    required this.otherUserName,
    required this.otherUserProfilePic,
    required this.lastMessageTime,
    required this.lastMessage,
  });

  factory ChatContact.fromMap(
    Map<String, dynamic> map,
    String chatId,
    String currentUid,
    Map<String, dynamic> otherUserData,
  ) {
    final participants = List<String>.from(map['participants'] ?? []);

    final otherUid = participants.firstWhere(
      (uid) => uid != currentUid,
      orElse: () => '',
    );

    DateTime messageTime;
    try {
      if (map['lastMessageTime'] != null) {
        messageTime = (map['lastMessageTime'] as Timestamp).toDate();
      } else {
        messageTime = DateTime.now();
      }
    } catch (e) {
      messageTime = DateTime.now();
    }

    return ChatContact(
      chatId: chatId,
      otherUid: otherUid,
      otherUserName:
          otherUserData['displayname'] ??
          otherUserData['username'] ??
          'Unknown User',
      otherUserProfilePic: otherUserData['profilePic'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: messageTime,
    );
  }
}
