import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/models/call_state.dart';
import 'package:whatsapp_clone/screens/calls/controller/call_controller.dart';
import 'package:whatsapp_clone/screens/calls/repository/call_repository.dart';

final callRepositoryProvider = Provider((ref) => CallRepository());

final callControllerProvider = StateNotifierProvider<CallController, CallState>(
  (ref) {
    return CallController(repo: ref.watch(callRepositoryProvider), ref: ref);
  },
);
