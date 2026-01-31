import 'dart:io';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/auth/repository/auth_providers.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/Profile/bio_screen.dart';
import 'package:whatsapp_clone/screens/Profile/display_edit_screen.dart';
import 'package:whatsapp_clone/screens/Profile/qr_screen.dart';
import 'package:whatsapp_clone/screens/Profile/username_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/widgets/helpful_widgets/profilepic.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  bool isSaving = false;
  File? image;

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
      data: (UserModel user) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                TextButton(
                  onPressed: (image == null || isSaving)
                      ? null
                      : () async {
                          setState(() {
                            isSaving = true;
                          });
                          await ref
                              .read(authControllerProvider)
                              .saveUserDataToFirebase(
                                context,
                                nameController.text.trim(),
                                image,
                              );
                        },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      }
                      return uiColor;
                    }),
                  ),
                  child: isSaving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        selectImage();
                      },
                      onLongPress: () {
                        if (image == null &&
                            (user.profilePic.isEmpty ||
                                user.profilePic ==
                                    'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png')) {
                          return;
                        }

                        showModalBottomSheet(
                          context: context,
                          backgroundColor: backgroundColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (_) => SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.white,
                                  ),
                                  title: const Text(
                                    'View',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                        child: image != null
                                            ? Image.file(
                                                image!,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                user.profilePic,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  title: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onTap: () async {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: profileAvatar(
                        radius: 66,
                        image: image,
                        photoUrl: user.profilePic,
                      ),
                    ),
                  ),
                  _tile(
                    "Display name",
                    onTap: () => _go(context, const DisplayEditScreen()),
                  ),
                  _tile("Bio", onTap: () => _go(context, const BioScreen())),

                  SizedBox(height: 4),
                  InkWell(
                    onTap: () => _go(context, const QrScreen()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: const [
                          Text(
                            "My QR code",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Spacer(),
                          Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  const Divider(),

                  _tile(
                    "MINE ID",
                    onTap: () => _go(context, const UsernameScreen()),
                  ),
                  SizedBox(height: 12),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      "Allow others to add me by ID",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "Others can add you as a friend searching your ID",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                    trailing: Switch(
                      value: false,
                      onChanged: (_) {},
                      activeThumbColor: uiColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  const Divider(),
                  SizedBox(height: 6),
                  InkWell(
                    onTap: () => _go(context, const QrScreen()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: const [
                          Text(
                            "Birthday",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Spacer(),
                          Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _tile(String title, {VoidCallback? onTap, bool showNotSet = true}) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
      subtitle: showNotSet
          ? const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                "Not set",
                style: TextStyle(color: Colors.grey, fontSize: 17),
              ),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  void _go(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}
