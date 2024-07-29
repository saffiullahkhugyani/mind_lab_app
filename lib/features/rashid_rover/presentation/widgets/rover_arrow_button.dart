import 'package:flutter/material.dart';

class RoverArrowButton extends StatefulWidget {
  final String text;
  final IconData arrowIcon;
  final Function() onTap;

  const RoverArrowButton(
      {super.key,
      required this.text,
      required this.arrowIcon,
      required this.onTap});

  @override
  State<RoverArrowButton> createState() => _RoverArrowButtonState();
}

class _RoverArrowButtonState extends State<RoverArrowButton> {
  bool isTouching = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(8),
      child: Material(
        color: Colors.grey[300],
        elevation: 2,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.transparent),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.arrowIcon),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(widget.text),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
