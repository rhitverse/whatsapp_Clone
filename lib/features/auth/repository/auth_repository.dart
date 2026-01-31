import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whatsapp_clone/common/utils/common_cloudinary_repository.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/otp_page.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/mobile_screen_layout.dart';
import 'package:whatsapp_clone/screens/user/display_name.dart';
import 'package:whatsapp_clone/widgets/helpful_widgets/info_popup.dart';

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
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) return;

      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      if (isNewUser) {
        await saveUserToFirestore(uid: user.uid, email: user.email);

        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const DisplayName()),
            (_) => false,
          );
        }
      } else {
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MobileScreenLayout()),
            (_) => false,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        InfoPopup.show(context, "Google sign-in failed");
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

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MobileScreenLayout()),
      );
    } on FirebaseAuthException {
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

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-null',
        message: 'User creation failed',
      );
    }

    await user.sendEmailVerification();

    await saveUserToFirestore(uid: user.uid, email: user.email);
  }

  Future<bool> isEmailVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  Future<void> resendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required BuildContext context,
  }) async {
    try {
      final uid = _auth.currentUser!.uid;

      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      if (profilePic != null) {
        final userDoc = await _firestore.collection('users').doc(uid).get();
        final userData = userDoc.data();
        final oldProfilePic = userData?['profilePic'] as String?;

        if (oldProfilePic != null &&
            !oldProfilePic.contains('katie-notopoulos') &&
            oldProfilePic.contains('cloudinary')) {
          final cloudRepo = CommonCloudinaryRepository();
          try {
            await cloudRepo.deleteFileFromCloudinary(oldProfilePic);
          } catch (e) {
            debugPrint('Failed to delete old image: $e');
          }
        }

        final cloudRepo = CommonCloudinaryRepository();
        final uploaderUrl = await cloudRepo.storeFileToCloudinary(profilePic);

        if (uploaderUrl != null) {
          photoUrl = uploaderUrl;
        }
      }

      final user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        username: uid,
        groupId: [],
      );

      await _firestore
          .collection('users')
          .doc(uid)
          .set(user.toMap(), SetOptions(merge: true));

      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  Future<void> deleteProfilePicture({required BuildContext context}) async {
    try {
      final uid = _auth.currentUser!.uid;

      final userDoc = await _firestore.collection('users').doc(uid).get();
      final userData = userDoc.data();

      if (userData == null) return;

      final oldProfilePic = userData['profilePic'] as String?;

      if (oldProfilePic != null &&
          !oldProfilePic.contains('katie-notopoulos') &&
          oldProfilePic.contains('cloudinary')) {
        final cloudRepo = CommonCloudinaryRepository();
        await cloudRepo.deleteFileFromCloudinary(oldProfilePic);
      }
      const defaultPhotoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
      await _firestore.collection('users').doc(uid).update({
        'profilePic': defaultPhotoUrl,
      });

      if (context.mounted) {
        showSnackBar(context: context, content: 'Profile picture removed');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context: context,
          content: 'Failed to delete profile picture: ${e.toString()}',
        );
      }
    }
  }

  Stream<UserModel> getUserData() {
    final uid = _auth.currentUser!.uid;

    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      return UserModel.fromMap(snapshot.data()!);
    });
  }
}
