import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String imagePath;
  final Function() onTap;
  const SocialLoginButton({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            onTap();
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.withOpacity(0.2)),
            child: Image.asset(
              imagePath,
              height: 40,
            ),
          ),
        ),
      ),
    );
  }
}
