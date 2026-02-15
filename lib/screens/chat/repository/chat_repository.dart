import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  Stream<QuerySnapshot> getUserChats(String uid) {
    return _firestore
        .collection('Chats')
        .where('participants', arrayContains: uid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    required String receiverId,
  }) async {
    await _firestore.collection('Chats').doc(chatId).collection('messages').add(
      {
        'senderId': senderId,
        'text': text,
        'time': FieldValue.serverTimestamp(),
      },
    );

    await _firestore.collection('Chats').doc(chatId).update({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastMessageSenderId': senderId,
      'unreadCount_$receiverId': FieldValue.increment(1),
    });
  }

  Future<void> markAsRead(String chatId, String userId) async {
    await _firestore.collection('Chats').doc(chatId).update({
      'unreadCount_$userId': 0,
    });
  }

  Future<void> updateOnlineStatus(String uid, bool isOnline) async {
    await _firestore.collection('users').doc(uid).update({
      'isOnline': isOnline,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  Future<void> createChat({
    required String chatId,
    required List<String> participants,
  }) async {
    final doc = await _firestore.collection('Chats').doc(chatId).get();

    if (!doc.exists) {
      await _firestore.collection('Chats').doc(chatId).set({
        'participants': participants,
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSenderId': '',
        for (var uid in participants) 'unreadCount_$uid': 0,
      });
    }
  }

  Stream<QuerySnapshot> getChatMessages(String chatId) {
    return _firestore
        .collection('Chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots();
  }
}
