import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final IconData icon;
  IconButton? sufixIcon;
  bool? isEnabled;
  final String? Function(String?)? validator; // Add validator parameter

  InputField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.icon,
    this.sufixIcon,
    this.isObscureText = false,
    this.isEnabled = true,
    this.validator, // Make validator optional
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: hintText,
          suffixIcon: sufixIcon,
          errorStyle: TextStyle(color: Colors.red)),
      validator: validator,
      obscureText: isObscureText,
      enabled: isEnabled,
    );
  }
}
