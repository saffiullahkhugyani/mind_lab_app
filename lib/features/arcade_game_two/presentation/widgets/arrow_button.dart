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
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTapUp: (_) => onPressEnd(),
            onTapDown: (_) => onPressStart(),
            child: GestureDetector(
              child: Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.withOpacity(0.2)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.arrowIcon, size: 100), // Adjust icon size
                    Text(
                      widget.arrow,
                      style: TextStyle(fontSize: 40),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
