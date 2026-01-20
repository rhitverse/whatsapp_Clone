import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

class Password extends StatefulWidget {
  final TextEditingController? controller;
  final void Function(bool isValid)? onChanged;
  const Password({super.key, this.controller, this.onChanged});

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  late final TextEditingController passwordController;
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  bool isPasswordVisible = false;
  bool isConfirmPasswordWrong = false;
  bool isConfirmPasswordVisible = false;
  bool isPasswordFocused = false;
  bool showConfirmPassword = false;
  bool _isDisposed = false;

  String passwordStrength = "";
  final RegExp lowerCase = RegExp(r'[a-z]');
  final RegExp symbol = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  void checkPasswordStrength(String value) {
    if (_isDisposed) return;
    if (value.isEmpty) {
      passwordStrength = "";
    } else if (value.length < 8) {
      passwordStrength = "Weak";
    } else if (lowerCase.hasMatch(value) && symbol.hasMatch(value)) {
      passwordStrength = "Strong";
    } else {
      passwordStrength = "Medium";
    }

    validateConfirmPassword();
    notifyParent();
    if (mounted) {
      setState(() {});
    }
  }

  void validateConfirmPassword() {
    if (_isDisposed) return;

    if (confirmPasswordController.text.isEmpty) {
      isConfirmPasswordWrong = false;
    } else {
      isConfirmPasswordWrong =
          confirmPasswordController.text != passwordController.text;
    }
    notifyParent();
  }

  void notifyParent() {
    if (_isDisposed) return;
    final isValid =
        (passwordStrength == "Medium" || passwordStrength == "Strong") &&
        !isConfirmPasswordWrong &&
        confirmPasswordController.text.isNotEmpty;

    widget.onChanged?.call(isValid);
  }

  Color get strengthColor {
    switch (passwordStrength) {
      case "Weak":
        return Colors.red;
      case "Medium":
        return Colors.orangeAccent;
      case "Strong":
        return uiColor;
      default:
        return Colors.transparent;
    }
  }

  void _onPasswordFocusChange() {
    if (_isDisposed) return;

    if (passwordFocus.hasFocus && mounted) {
      setState(() {
        isPasswordFocused = true;
        showConfirmPassword = true;
      });
    }
  }

  void _onPasswordChange() {
    if (_isDisposed) return;
    checkPasswordStrength(passwordController.text);
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      passwordController = widget.controller!;
    } else {
      passwordController = TextEditingController();
    }

    passwordFocus.addListener(_onPasswordFocusChange);
    passwordController.addListener(_onPasswordChange);
  }

  @override
  void dispose() {
    _isDisposed = true;
    passwordFocus.removeListener(_onPasswordFocusChange);
    passwordController.removeListener(_onPasswordChange);
    if (widget.controller == null) {
      passwordController.dispose();
    }
    confirmPasswordController.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Create Password",
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 6),
        _passwordField(
          controller: passwordController,
          focusNode: passwordFocus,
          isVisible: isPasswordVisible,
          hint: "New Password",
          onToggle: () {
            if (mounted) {
              setState(() => isPasswordVisible = !isPasswordVisible);
            }
          },
          onChanged: checkPasswordStrength,
        ),
        if (isPasswordFocused && passwordStrength.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              "Password Strength : $passwordStrength",
              style: TextStyle(
                color: strengthColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        if (showConfirmPassword) ...[
          const SizedBox(height: 10),

          Transform.translate(
            offset: Offset(
              0,
              (isPasswordFocused && passwordStrength.isNotEmpty) ? -4 : 0,
            ),
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xff1e2023),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isConfirmPasswordWrong
                      ? Colors.red
                      : Colors.transparent,
                  width: 1.3,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: confirmPasswordController,
                focusNode: confirmPasswordFocus,
                obscureText: !isConfirmPasswordVisible,
                cursorColor: uiColor,
                onChanged: (_) => validateConfirmPassword(),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  hintStyle: const TextStyle(
                    color: Colors.white38,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      }
                    },
                    child: Icon(
                      isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (isConfirmPasswordWrong)
            Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 14),
                SizedBox(width: 6),
                Text(
                  "Wrong password, try again",
                  style: TextStyle(color: Colors.red, fontSize: 11),
                ),
              ],
            ),
        ],
      ],
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool isVisible,
    required String hint,
    required VoidCallback onToggle,
    required Function(String) onChanged,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xff1e2023),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: !isVisible,
        onChanged: onChanged,
        cursorColor: uiColor,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 15),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          suffixIcon: GestureDetector(
            onTap: onToggle,
            child: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white54,
            ),
          ),
        ),
      ),
    );
  }
}
