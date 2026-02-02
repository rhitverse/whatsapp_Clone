import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/auth/repository/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/widgets/helpful_widgets/info_popup.dart';

class BioScreen extends ConsumerStatefulWidget {
  const BioScreen({super.key});

  @override
  ConsumerState<BioScreen> createState() => _BioScreenState();
}

class _BioScreenState extends ConsumerState<BioScreen> {
  final TextEditingController nameController = TextEditingController();
  bool _isInitialized = false;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            fontWeight: FontWeight.w100,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Your Bio",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),

        data: (user) {
          if (!_isInitialized) {
            nameController.text = user.displayname;
            _isInitialized = true;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),

                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  cursorColor: uiColor,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Enter yours",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: uiColor, width: 1.2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: uiColor, width: 1.2),
                    ),
                    suffixIcon: nameController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              nameController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      final name = nameController.text.trim();

                      if (name.isEmpty) {
                        InfoPopup.show(context, "Enter your name");
                        return;
                      }

                      await ref
                          .read(authControllerProvider)
                          .saveUserDataToFirebase(context, name, null);

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: uiColor,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          );
        },
      ),
    );
  }
}
