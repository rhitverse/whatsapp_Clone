import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String hint;
  final bool obscure;
  final TextEditingController? controller;
  const InputField({
    super.key,
    required this.hint,
    this.obscure = false,
    this.controller,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xfff8f8ff),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Color(0xffc0c0c0), width: 2),
      ),
      child: Center(
        child: TextField(
          controller: widget.controller,
          obscureText: _isObscure,
          cursorColor: Colors.green,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.grey.shade500),
            suffixIcon: widget.obscure
                ? IconButton(
                    icon: Icon(
                      _isObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
