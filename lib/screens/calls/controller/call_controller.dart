import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_clone/models/call_state.dart';
import 'package:whatsapp_clone/screens/calls/repository/call_repository.dart';

class CallController extends StateNotifier<CallState> {
  final CallRepository _repo;
  StreamSubscription? _incomingCallSub;

  CallController({required CallRepository repo, required Ref ref})
    : _repo = repo,
      super(const CallState()) {
    _initAgora();
    _listenIncomingCalls();
  }

  Future<void> _initAgora() async {
    await _repo.initAgora();

    _repo.agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          state = state.copyWith(isCallActive: true);
        },
        onUserJoined: (connection, uid, elapsed) {
          state = state.copyWith(remoteUid: uid);
        },
        onUserOffline: (connection, uid, reason) {
          state = state.copyWith(clearRemoteUid: true);
          endCall(null);
        },
        onLeaveChannel: (connection, stats) {
          state = state.copyWith(isCallActive: false);
        },
      ),
    );
  }

  void _listenIncomingCalls() {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isEmpty) return;

    _incomingCallSub = _repo.listenForIncomingCall(userId).listen((call) {
      if (call != null) {
        state = state.copyWith(incomingCall: call);
      }
    });
  }

  Future<void> startCall({
    required String receiverId,
    required bool isVideo,
    required BuildContext context,
  }) async {
    final callId = await _repo.startCall(
      receiverId: receiverId,
      isVideo: isVideo,
    );
    state = state.copyWith(currentCallId: callId, isVideoOn: isVideo);
    await _repo.enableVideo(isVideo);
    if (context.mounted) {
      Navigator.pushNamed(context, '/call-screen');
    }
  }

  Future<void> acceptCall(BuildContext context) async {
    if (state.incomingCall == null) return;

    state = state.copyWith(isVideoOn: state.incomingCall!.isVideo);
    await _repo.enableVideo(state.incomingCall!.isVideo);
    await _repo.acceptCall(state.incomingCall!);
    state = state.copyWith(currentCallId: state.incomingCall!.callId);

    if (context.mounted) {
      context.pushReplacementNamed('call-screen');
    }
  }

  Future<void> endCall(BuildContext? context) async {
    if (state.currentCallId.isEmpty) return;
    await _repo.endCall(state.currentCallId);
    state = state.copyWith(
      isCallActive: false,
      clearRemoteUid: true,
      clearIncomingCall: true,
      currentCallId: '',
    );
    if (context != null && context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> toggleMute() async {
    state = state.copyWith(isMuted: !state.isMuted);
    await _repo.muteAudio(state.isMuted);
  }

  Future<void> toggleVideo() async {
    state = state.copyWith(isVideoOn: !state.isVideoOn);
    await _repo.enableVideo(state.isVideoOn);
  }

  Future<void> switchCamera() async {
    await _repo.switchCamera();
  }

  @override
  void dispose() {
    _incomingCallSub?.cancel();
    _repo.dispose();
    super.dispose();
  }
}
