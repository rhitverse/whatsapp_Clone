import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/otp_page.dart';
import 'package:whatsapp_clone/screens/user/display_name.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  }) : _auth = auth,
       _firestore = firestore,
       _googleSignIn = googleSignIn;

  Future<void> signInWithGoogle({required BuildContext context}) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return; // User cancelled

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Save user to Firestore if new user
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await saveUserToFirestore(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email,
        );
      }

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DisplayName()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context: context,
          content: 'Google sign-in failed: ${e.toString()}',
        );
      }
    }
  }

  Future<void> signInWithPhone({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),

        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },

        verificationFailed: (FirebaseAuthException e) {
          showSnackBar(
            context: context,
            content: e.message ?? "Phone verification failed",
          );
        },

        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OtpPage(
                phoneNumber: phoneNumber,
                verificationId: verificationId,
              ),
            ),
          );
        },

        codeAutoRetrievalTimeout: (_) {},
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<void> verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String otp,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DisplayName()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message ?? "Invalid OTP");
    }
  }

  Future<void> signInWithEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DisplayName()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.message ?? "Login failed");
      }
      rethrow;
    }
  }

  Future<void> saveUserToFirestore({
    required String uid,
    String? email,
    String? phone,
  }) async {
    await _firestore.collection("users").doc(uid).set({
      "uid": uid,
      "email": email,
      "phone": phone,
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Sign Out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
