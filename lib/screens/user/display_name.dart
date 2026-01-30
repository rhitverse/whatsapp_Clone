import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/screens/mobile_screen_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp_clone/widgets/helpful_widgets/app_loader.dart';
import 'package:whatsapp_clone/widgets/helpful_widgets/info_popup.dart';
import 'package:whatsapp_clone/widgets/helpful_widgets/input_field.dart';

class DisplayName extends StatefulWidget {
  const DisplayName({super.key});

  @override
  State<DisplayName> createState() => _DisplayNameState();
}

class _DisplayNameState extends State<DisplayName> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Text(
          "Create a new account",
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Other people on MINE can see your display name and \n profile media.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    image == null
                        ? const CircleAvatar(
                            radius: 34,
                            backgroundImage: NetworkImage(
                              'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                            ),
                          )
                        : CircleAvatar(
                            backgroundImage: FileImage(image!),
                            radius: 34,
                          ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: const Icon(
                          Icons.add_a_photo_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Display Name",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),

                const SizedBox(height: 8),
                InputField(
                  hint: "What's your name?",
                  controller: nameController,
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Text(
              "You can use emoji and special characters.",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  if (nameController.text.trim().isEmpty) {
                    InfoPopup.show(context, "Please enter a display name");
                    return;
                  }
                  final loader = AppLoader.show(
                    context,
                    message: "Creating your account...",
                  );

                  try {
                    final uid = FirebaseAuth.instance.currentUser?.uid;

                    if (uid == null) {
                      loader.remove();
                      return;
                    }

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .set({
                          'displayName': nameController.text.trim(),
                        }, SetOptions(merge: true));

                    loader.remove();

                    if (!mounted) return;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MobileScreenLayout(),
                      ),
                    );
                  } catch (e) {
                    loader.remove();
                    debugPrint("Display name save error: $e");
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: uiColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
