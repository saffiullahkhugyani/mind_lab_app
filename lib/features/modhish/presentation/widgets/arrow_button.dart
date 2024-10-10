import 'package:flutter/material.dart';

class ArrowButton extends StatelessWidget {
  final IconData arrowIcon;
  final Function() onTap;
  const ArrowButton({
    super.key,
    required this.arrowIcon,
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
            width: 120,
            height: 120,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.withOpacity(0.2)),
            child: Icon(
              arrowIcon,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }
}
