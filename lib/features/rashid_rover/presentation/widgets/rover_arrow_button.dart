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
    return GestureDetector(
      onTap: () {
        setState(() {});
        widget.onTap();
      },
      child: Listener(
        child: Container(
          decoration: BoxDecoration(
            color: isTouching == true ? Colors.grey.shade400 : Colors.grey,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(),
          ),
          width: 100,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(size: 50.0, widget.arrowIcon),
              Text(widget.text),
            ],
          ),
        ),
        onPointerDown: (event) => setState(
          () {
            isTouching = true;
          },
        ),
        onPointerUp: (event) {
          isTouching = false;
        },
      ),
    );
  }
}
