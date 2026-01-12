import 'package:flutter/material.dart';
import 'package:whatsapp_clone/widgets/helpful_widgets/toggle_button_item.dart';

class RegisteScreen extends StatefulWidget {
  const RegisteScreen({super.key});

  @override
  State<RegisteScreen> createState() => _RegisteScreenState();
}

class _RegisteScreenState extends State<RegisteScreen> {
  bool isEmailisSelected = true;

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
                const SizedBox(height: 10),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Enter phone or email",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Color(0xff1e2023),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      ToggleButtonItem(
                        text: "Phone",
                        selected: !isEmailisSelected,
                        onTap: () {
                          setState(() {
                            isEmailisSelected = false;
                          });
                        },
                      ),
                      ToggleButtonItem(
                        text: "Email",
                        selected: isEmailisSelected,
                        onTap: () {
                          setState(() {
                            isEmailisSelected = true;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
