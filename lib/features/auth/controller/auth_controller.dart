import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/features/auth/repository/auth_repository.dart';
import 'package:whatsapp_clone/features/auth/repository/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/screens/user/display_name.dart';
import 'package:whatsapp_clone/widgets/helpful_widgets/info_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authControllerProvider = Provider(
  (ref) => AuthController(
    authRepository: ref.read(authRepositoryProvider),
    ref: ref,
  ),
);

class AuthController {
  final AuthRepository _authRepository;
  final ProviderRef ref;
  AuthController({required AuthRepository authRepository, required this.ref})
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
    try {
      await _authRepository.signInWithEmail(
        context: context,
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      String message;

      switch (e.code) {
        case 'user-not-found':
          message = "User doesn't exist";
          break;

        case 'wrong-password':
          message = "Incorrect password";
          break;

        case 'invalid-credential':
          message =
              "This email is registered with Google. Please use Google Sign-In.";
          break;

        case 'invalid-email':
          message = "Invalid email address";
          break;

        case 'user-disabled':
          message = "This account has been disabled";
          break;

        case 'too-many-requests':
          message = "Too many attempts. Try again later";
          break;

        default:
          message = "Login failed. Please try again";
      }

      InfoPopup.show(context, message);
    }
  }

  Future<void> signUpWithEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await _authRepository.signUpWithEmail(email: email, password: password);

      if (!context.mounted) return;

      InfoPopup.show(
        context,
        "Account created! Please check your email to verify your account",
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DisplayName()),
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = "This email is already registered";
          break;
        case 'weak-password':
          message = "Password should be at least 6 characters";
          break;
        case 'invalid-email':
          message = "Invalid email address";
          break;
        default:
          message = e.message ?? "Signup failed";
      }

      InfoPopup.show(context, message);
      rethrow;
    } catch (e) {
      if (!context.mounted) return;
      InfoPopup.show(context, "An error occurred. Please try again");
    }
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

  Future<void> saveUserDataToFirebase(
    BuildContext context,
    String name,
    File? profilePic,
  ) async {
    _authRepository.saveUserDataToFirebase(
      name: name,
      profilePic: profilePic,
      context: context,
    );
  }
}
