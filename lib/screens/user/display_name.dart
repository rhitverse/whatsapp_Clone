import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/screens/mobile_screen_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp_clone/widgets/helpful_widgets/app_loader.dart';

class DisplayName extends StatefulWidget {
  const DisplayName({super.key});

  @override
  State<DisplayName> createState() => _DisplayNameState();
}

class _DisplayNameState extends State<DisplayName> {
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xff040406),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "What's your name?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Display Name",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 8),
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xff1e2023),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.green,
                          decoration: const InputDecoration(
                            hintText: "Enter your name",
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      if (nameController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            nameController.clear();
                            HapticFeedback.lightImpact();
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: const BoxDecoration(
                              color: Colors.white24,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "You can use emoji and special characters.",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: nameController.text.isEmpty
                        ? null
                        : () async {
                            final loader = AppLoader.show(
                              context,
                              message: "Creating your account...",
                            );

                            try {
                              final uid =
                                  FirebaseAuth.instance.currentUser?.uid;

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
                      disabledBackgroundColor: uiColor.withOpacity(0.4),
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
        ),
      ),
    );
  }
}
