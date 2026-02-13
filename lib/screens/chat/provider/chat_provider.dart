import 'package:whatsapp_clone/screens/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/screens/chat/repository/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(firestore: FirebaseFirestore.instance),
);

final ChatControllerProvider = Provider(
  (ref) => ChatController(
    chatRepository: ref.read(chatRepositoryProvider),
    ref: ref,
  ),
);
