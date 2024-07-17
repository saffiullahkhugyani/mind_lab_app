import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final String text;
  final String image;
  final Function() onTap;
  final Color color;
  final double elevation;

  const CardItem(
      {super.key,
      required this.text,
      required this.image,
      required this.color,
      required this.elevation,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(8),
      child: Material(
        elevation: elevation,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            onTap();
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(height: 80, width: 80, image),
                const SizedBox(height: 10),
                Text(
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
