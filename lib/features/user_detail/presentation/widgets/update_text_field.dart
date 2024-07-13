import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UpdateTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  VoidCallback? onTap;
  IconData? iconData;
  bool? readOnly;
  UpdateTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.onTap,
    this.iconData,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hintText,
        prefixIcon: Icon(iconData),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is missing";
        }
        return null;
      },
      onTap: onTap,
      readOnly: readOnly!,
    );
  }
}
