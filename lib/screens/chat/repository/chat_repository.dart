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
  }) async {
    final messageRef = _firestore
        .collection('Chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    await messageRef.set({
      'senderId': senderId,
      'text': text,
      'timeSent': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('Chats').doc(chatId).update({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
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
      });
    }
  }
}
