import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/screens/user/registe_screen.dart';
import 'package:whatsapp_clone/widgets/helpful_widgets/input_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xff040406),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Center(
                          child: Column(
                            children: [
                              Text(
                                "Welcome Back!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "We'r so excited to see you again!",
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),

                        const Text(
                          "Email or Phone Number",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        InputField(hint: "Enter email or phone"),
                        const SizedBox(height: 22),
                        const Text(
                          "Password",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        InputField(hint: "Enter password", obscure: true),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forget your password?",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: uiColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Log In",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    children: [
                      const TextSpan(text: "Don't have an account?"),
                      TextSpan(
                        text: " Sign Up",
                        style: const TextStyle(color: uiColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RegisteScreen(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
