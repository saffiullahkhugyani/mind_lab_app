import 'package:flutter/material.dart';

class BluetoothConnectionButton extends StatelessWidget {
  final Color connectionStatusColor;
  final Function() onTap;

  const BluetoothConnectionButton({
    super.key,
    required this.connectionStatusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
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
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: connectionStatusColor,
                      ),
                    ),
                  ],
                ),
                const Positioned(
                    child: Center(
                        child: Icon(
                  Icons.bluetooth,
                  size: 40,
                  color: Colors.blue,
                )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
