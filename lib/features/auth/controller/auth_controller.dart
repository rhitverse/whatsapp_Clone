import 'package:flutter/material.dart';
import 'package:whatsapp_clone/features/auth/repository/auth_repository.dart';
import 'package:whatsapp_clone/features/auth/repository/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = Provider(
  (ref) => AuthController(authRepository: ref.read(authRepositoryProvider)),
);

class AuthController {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<void> signInWithGoogle({required BuildContext context}) async {
    await _authRepository.signInWithGoogle(context: context);
  }

  Future<void> signInWithPhone({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    await _authRepository.signInWithPhone(
      context: context,
      phoneNumber: phoneNumber,
    );
  }

  Future<void> signInWithEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    await _authRepository.signInWithEmail(
      context: context,
      email: email,
      password: password,
    );
  }

  Future<void> signUpWithEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    await _authRepository.signUpWithEmail(
      context: context,
      email: email,
      password: password,
    );
  }

  Future<void> verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String otp,
  }) async {
    await _authRepository.verifyOtp(
      context: context,
      verificationId: verificationId,
      otp: otp,
    );
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}
