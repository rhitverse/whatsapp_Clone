import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/auth/repository/auth_providers.dart';
import 'package:whatsapp_clone/screens/user/registe_screen.dart';
import 'package:whatsapp_clone/widgets/helpful_widgets/input_field.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailOrPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isGoogleLoading = false;

  @override
  void initState() {
    super.initState();

    emailOrPhoneController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailOrPhoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool get isLoginEnabled {
    return emailOrPhoneController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  bool isEmail(String input) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(input);
  }

  Future<void> handleLogin() async {
    if (!isLoginEnabled) return;
    setState(() => isLoading = true);
    final input = emailOrPhoneController.text.trim();
    final password = passwordController.text.trim();

    try {
      final authRepo = ref.read(authRepositoryProvider);
      if (isEmail(input)) {
        await authRepo.signInWithEmail(
          context: context,
          email: input,
          password: password,
        );
      } else {
        if (mounted) {
          showSnackBar(
            context: context,
            content:
                'Phone login requires verification. Please use Register screen.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context: context,
          content: 'Login failed. Please check your credentials.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> handleGoogleSignIn() async {
    setState(() => isGoogleLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.signInWithGoogle(context: context);
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context: context,
          content: 'Google sign-in failed. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => isGoogleLoading = false);
      }
    }
  }

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
                        const SizedBox(height: 70),
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
                                "We're so excited to see you again!",
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),

                        const Text(
                          "Email or Phone Number",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        InputField(
                          hint: "Enter email or phone",
                          controller: emailOrPhoneController,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Password",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        InputField(
                          hint: "Enter password",
                          obscure: true,
                          controller: passwordController,
                        ),
                        const SizedBox(height: 6),
                        TextButton(
                          onPressed: () {
                            showSnackBar(
                              context: context,
                              content: 'Password reset feature coming soon!',
                            );
                          },
                          child: const Text(
                            "Forgot your password?",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isLoginEnabled && !isLoading
                                ? handleLogin
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: uiColor,
                              disabledBackgroundColor: uiColor.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    "Log In",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.white30,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                "OR",
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.white30,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isGoogleLoading
                                ? null
                                : handleGoogleSignIn,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),

                            child: isGoogleLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,

                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/google.png',
                                        height: 32,
                                        width: 32,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        'Sign In with Google',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisteScreen(),
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
