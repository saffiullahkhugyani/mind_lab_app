import 'package:flutter/material.dart';

class MyTextbox extends StatelessWidget {
  final String text;
  final String sectionName;
  const MyTextbox({
    super.key,
    required this.text,
    required this.sectionName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.only(bottom: 10, left: 15, top: 10),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(style: TextStyle(color: Colors.grey[500]), sectionName),
          const SizedBox(height: 6),
          Text(
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              text),
        ],
      ),
    );
  }
}
