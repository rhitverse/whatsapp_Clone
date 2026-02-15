import 'package:whatsapp_clone/screens/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/screens/chat/repository/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return ChatRepository(firestore: firestore);
});

final chatControllerProvider = Provider<ChatController>((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});
