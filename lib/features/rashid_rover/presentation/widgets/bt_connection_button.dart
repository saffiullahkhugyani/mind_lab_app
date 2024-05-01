import 'package:flutter/material.dart';

class BluetoothConnectionButton extends StatelessWidget {
  final Color connectionStatusColor;
  final String image;
  final Function() onTap;
  final IconData icon;

  const BluetoothConnectionButton(
      {super.key,
      required this.connectionStatusColor,
      required this.image,
      required this.onTap,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all()),
        height: 150,
        width: 150,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: connectionStatusColor,
                    ),
                  ),
                  Icon(icon)
                ],
              ),
              Image.asset(height: 100, width: 100, image),
            ],
          ),
        ),
      ),
    );
  }
}
