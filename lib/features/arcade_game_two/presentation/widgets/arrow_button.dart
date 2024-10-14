import 'dart:async';

import 'package:flutter/material.dart';

class ArrowButton extends StatefulWidget {
  final IconData arrowIcon;
  final Function() onTap;
  const ArrowButton({
    super.key,
    required this.arrowIcon,
    required this.onTap,
  });

  @override
  State<ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<ArrowButton> {
  //how often method will be called
  Duration delay = const Duration(milliseconds: 10);

  // decalring timer
  Timer? timer;

  void continuousWork() {
    debugPrint("I am working c ${timer!.tick}");
  }

  void onPressEnd() {
    debugPrint("Job END");
    timer?.cancel();
    timer = null;
  }

  void onPressStart() {
    if (timer != null) return;
    debugPrint("Job started");
    timer = Timer.periodic(delay, (timer) {
      // continuousWork();
      widget.onTap();
    });
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
              padding: const EdgeInsets.all(20),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.withOpacity(0.2)),
              child: Icon(
                widget.arrowIcon,
                size: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
