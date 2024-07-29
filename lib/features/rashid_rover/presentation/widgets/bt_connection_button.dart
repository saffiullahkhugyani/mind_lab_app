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
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(8),
      child: Material(
        color: Colors.grey[300],
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            onTap();
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
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
      ),
    );
  }
}
