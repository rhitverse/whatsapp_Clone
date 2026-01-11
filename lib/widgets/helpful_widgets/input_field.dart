import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hint;
  final bool obscure;
  final Widget? suffix;
  final TextEditingController? controller;
  const InputField({
    super.key,
    required this.hint,
    this.obscure = false,
    this.suffix,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1012),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38),
            suffixIcon: suffix,
          ),
        ),
      ),
    );
  }
}
