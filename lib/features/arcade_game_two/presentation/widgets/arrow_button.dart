import 'package:flutter/material.dart';

class ArrowButton extends StatefulWidget {
  final IconData arrowIcon;
  final Function() onTapDown;
  final Function() onTapUp;
  final String arrow;
  const ArrowButton({
    super.key,
    required this.arrowIcon,
    required this.arrow,
    required this.onTapDown,
    required this.onTapUp,
  });

  @override
  State<ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<ArrowButton> {
  void onPressEnd() {
    widget.onTapUp();
  }

  void onPressStart() {
    widget.onTapDown();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {},
          child: GestureDetector(
            onTapDown: (v) {
              onPressStart();
            },
            onTapUp: (v) {
              onPressEnd();
            },
            onTap: () {
              // onTap();
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.withOpacity(0.2)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.arrowIcon,
                    size: 40,
                  ),
                  Text(style: const TextStyle(fontSize: 20), widget.arrow),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
