import 'package:flutter/material.dart';

class ProjectButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color buttonColor;
  final IconData? iconData;
  const ProjectButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.buttonColor,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(4),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(8),
        color: buttonColor,
        child: InkWell(
          onTap: () => onPressed(),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.transparent),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconData),
                const SizedBox(
                  width: 8,
                ),
                Text(
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    buttonText),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
