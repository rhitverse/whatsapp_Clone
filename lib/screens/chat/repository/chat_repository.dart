import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/common/encryption/encryption_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;
  final _encryption = EncryptionService();
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
    final receiverDoc = await _firestore
        .collection('users')
        .doc(receiverId)
        .get();
    final publicKey = receiverDoc.data()?['publicKey'];
    String encryptedText = text;
    if (publicKey != null) {
      encryptedText = await _encryption.encryptMessage(text, publicKey);
    }
    await _firestore
        .collection('Chats')
        .doc(chatId)
        .collection('messages')
        .add({
          'senderId': senderId,
          'encryptedText': encryptedText,
          'isRead': false,
          'time': FieldValue.serverTimestamp(),
        });

    await _firestore.collection('Chats').doc(chatId).update({
      'lastMessage': '🔒 Message',
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

  Stream<List<Map<String, dynamic>>> getDecryptedMessages(String chatId) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return _firestore
        .collection('Chats')
        .doc(chatId)
        .collection('message')
        .orderBy('time', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final List<Map<String, dynamic>> decryptedMessage = [];

          for (final doc in snapshot.docs) {
            final data = doc.data();
            String decryptedText = '';

            if (data.containsKey('encryptedText')) {
              try {
                decryptedText = await _encryption.decryptMessage(
                  data['encryptedText'],
                  currentUserId,
                );
              } catch (_) {
                decryptedText = data['text'];
              }
            } else if (data.containsKey('text')) {
              decryptedText = data['text'];
            }

            decryptedMessage.add({
              'id': doc.id,
              'text': decryptedText,
              'senderId': data['senderId'] ?? '',
              'receiverId': data['receiverId'] ?? '',
              'isRead': data['isRead'] ?? false,
              'time': data['time'],
            });
          }
          return decryptedMessage;
        });
  }
}
