import 'package:flutter/material.dart';
import 'package:mind_lab_app/core/constants/routes.dart';
import 'package:mind_lab_app/features/rashid_rover/presentation/widgets/bt_connection_button.dart';
import 'package:mind_lab_app/features/rashid_rover/presentation/widgets/rover_buttons.dart';

class RoverMainPage extends StatelessWidget {
  const RoverMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rashid Rover'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BluetoothConnectionButton(
              connectionStatusColor: Colors.red,
              image: 'lib/assets/images/rashid_rover.png',
              onTap: () {
                Navigator.pushNamed(context, bluetoothDevicesRoute);
              },
            ),
            const SizedBox(height: 60),
            RoverButton(
              buttonText: 'Start',
              onPressed: () {
                print('Start');
              },
              buttonColor: Colors.green,
            ),
            const SizedBox(height: 30),
            RoverButton(
              buttonText: 'Clear all',
              onPressed: () {
                print('Clear all');
              },
              buttonColor: Colors.red,
            ),
            const SizedBox(height: 30),
            RoverButton(
                buttonText: 'Record',
                onPressed: () {
                  print('Record');
                  Navigator.pushNamed(context, roverControllerRoute);
                },
                buttonColor: Colors.blue)
          ],
        ),
      ),
    );
  }
}
