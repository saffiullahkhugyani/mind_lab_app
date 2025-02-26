import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final String text;
  final bool isAddCard;
  final Function() onTap;
  final Color color;
  final double elevation;

  const CardItem({
    super.key,
    required this.text,
    this.isAddCard = false,
    required this.color,
    required this.elevation,
    required this.onTap,
  });

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
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isAddCard)
                  const Icon(
                    Icons.add_outlined,
                    size: 60,
                    color: Colors.black54,
                  )
                else
                  Image.asset(
                    'lib/assets/icons/child-profile-icon.png',
                    height: 100,
                    width: 200,
                  ),
                // Image.network(
                //   image!,
                //   height: 100,
                //   width: 200,
                //   fit: BoxFit.cover,
                //   errorBuilder: (context, error, stackTrace) =>
                //       const Icon(Icons.image_not_supported, size: 60),
                // ),
                const SizedBox(height: 10),
                Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
