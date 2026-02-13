import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/screens/chat/repository/chat_repository.dart';

class ChatController {
  final ChatRepository _chatRepository;
  final ProviderRef ref;

  ChatController({required ChatRepository chatRepository, required this.ref})
    : _chatRepository = chatRepository;

  Stream<QuerySnapshot> getUserChats(String uid) {
    return _chatRepository.getUserChats(uid);
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    await _chatRepository.sendMessage(
      chatId: chatId,
      senderId: senderId,
      text: text,
    );
  }

  Future<void> createChat({
    required String chatId,
    required List<String> participants,
  }) async {
    await _chatRepository.createChat(
      chatId: chatId,
      participants: participants,
    );
  }
}
