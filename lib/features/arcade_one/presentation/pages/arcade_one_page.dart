import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:mind_lab_app/core/flutter_blue_plus/flutter_blue_plus_manager.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/routes.dart';

class ArcadeOnePage extends StatefulWidget {
  const ArcadeOnePage({super.key});

  @override
  State<ArcadeOnePage> createState() => _ArcadeOnePageState();
}

class _ArcadeOnePageState extends State<ArcadeOnePage> {
  // bool _isPressing = false;

  // Function to start continuous action
  // void _startPrinting() async {
  //   _isPressing = true;
  //   while (_isPressing) {
  //     log('Pressing continuously...');
  //     await Future.delayed(
  //         const Duration(milliseconds: 100)); // Delay between prints
  //   }
  // }

  // Function to stop continuous action
  // void _stopPrinting() {
  //   _isPressing = false;
  //   log('Stopped pressing.');
  // }

  @override
  void initState() {
    super.initState();

    // setting orientation to landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Reset the orientation back to default when leaving this page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _rowWidth = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Arcade One"),
      ),
      body: Consumer<FlutterBluetoothPlus>(
        builder: (context, bluetoothManager, child) {
          return Stack(
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, flutterBluePlusRoute);
                  },
                  child: const Text("Bluetooth"),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: _rowWidth,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    height: double.infinity,
                    child: Joystick(
                      mode: JoystickMode.vertical,
                      listener: (details) {
                        if (details.y < 0) {
                          log("moving forward: ${details.y}");
                          bluetoothManager.sendCommand("f");
                        }

                        if (details.y > 0) {
                          log("moving backward: ${details.y}");
                          bluetoothManager.sendCommand("b");
                        }
                        // log("value of y: ${details.y}");
                      },
                      onStickDragStart: () {
                        log("y axis moved");
                        // _isSendingDC = true;
                      },
                      onStickDragEnd: () {
                        // _isSendingDC = false;
                      },
                    ),
                  ),
                  Container(
                    width: _rowWidth,
                    height: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Joystick(
                      mode: JoystickMode.horizontal,
                      listener: (details) {
                        if (details.x > 0) {
                          log("moving right: ${details.x}");
                          bluetoothManager.sendCommand("r");
                        }

                        if (details.x < 0) {
                          log("moving left: ${details.x}");
                          bluetoothManager.sendCommand("l");
                        }
                        // log("value of x:${details.x}");
                      },
                      onStickDragStart: () {
                        log("x axis moved");
                        //  _isSendingSERVO = true;
                      },
                      onStickDragEnd: () {
                        // _isSendingSERVO = false;
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
