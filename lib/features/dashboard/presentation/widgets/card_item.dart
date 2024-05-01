import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final String text;
  final String image;
  final Function() onTap;

  CardItem(
      {super.key,
      required this.text,
      required this.image,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all()),
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
    );
  }
}
