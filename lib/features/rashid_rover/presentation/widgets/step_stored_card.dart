import 'package:flutter/material.dart';

class StepStoredCard extends StatelessWidget {
  final String text;
  final IconData icon;

  const StepStoredCard({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(6),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon),
          Text(
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              text),
        ],
      ),
    );
  }
}
