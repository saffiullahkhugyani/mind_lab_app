import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mind_lab_app/core/flutter_blue_plus/flutter_blue_plus_manager.dart';
import 'package:mind_lab_app/features/arcage_game_one/presentation/widgets/bt_connection_button.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/routes.dart';
import '../widgets/arrow_button.dart';

class ArcadeGameTwoPage extends StatefulWidget {
  const ArcadeGameTwoPage({super.key});

  @override
  State<ArcadeGameTwoPage> createState() => _ArcadeGameTwoPageState();
}

class _ArcadeGameTwoPageState extends State<ArcadeGameTwoPage> {
  // Timer? _timer;
  // int _elapsedMillis = 0;
  double _speedSliderValue = 0;
  // double _servoOneSliderValue = 0;
  // double _servoTwoSliderValue = 0;
  bool motorSwitch = false;
  bool servoSwitch = false;
  var sendingCommand = 's';

  // handling combined commands
  final Set<String> _pressedButtons = {};

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values); // to re-show bars
    super.dispose();
  }

  // Function to send combined commands based on current pressed buttons
  Future<void> _sendCombinedCommand(
      FlutterBluetoothPlus bluetoothManager, bool isPressed) async {
    if (_pressedButtons.containsAll(['up', 'left'])) {
      await sendBluetoothCommand(
          bluetoothManager, {"UpLeft": isPressed ? "1" : "0"});
    } else if (_pressedButtons.containsAll(['up', 'right'])) {
      await sendBluetoothCommand(
          bluetoothManager, {"UpRight": isPressed ? "1" : "0"});
    } else if (_pressedButtons.containsAll(['down', 'left'])) {
      await sendBluetoothCommand(
          bluetoothManager, {"DownLeft": isPressed ? "1" : "0"});
    } else if (_pressedButtons.containsAll(['down', 'right'])) {
      await sendBluetoothCommand(
          bluetoothManager, {"DownRight": isPressed ? "1" : "0"});
    }
  }

// Function to send individual commands
  Future<void> _sendIndividualCommand(FlutterBluetoothPlus bluetoothManager,
      String direction, bool isPressed) async {
    await sendBluetoothCommand(
        bluetoothManager, {direction: isPressed ? "1" : "0"});
  }

// Main function to manage button presses and releases
  Future<void> _updatePressedButtons(FlutterBluetoothPlus bluetoothManager,
      String direction, bool isPressed) async {
    if (isPressed) {
      _pressedButtons.add(direction);
    } else {
      if (!isPressed && _pressedButtons.length == 2) {
        await _sendCombinedCommand(bluetoothManager, isPressed);
      }
      _pressedButtons.remove(direction);
    }

    // Handle combined command if two buttons are pressed
    if (_pressedButtons.length == 2) {
      await _sendCombinedCommand(bluetoothManager, isPressed);
    }
    // Handle single button press or release
    else if (_pressedButtons.length == 1) {
      // Send the individual command for the remaining pressed button
      final remainingDirection = _pressedButtons.first;
      await _sendIndividualCommand(bluetoothManager, remainingDirection, true);
    }
    // Send release command when no buttons are pressed
    else if (!isPressed) {
      await _sendIndividualCommand(bluetoothManager, direction, false);
    }
  }

  Future<void> sendBluetoothCommand(FlutterBluetoothPlus bluetoothManager,
      Map<String, String> command) async {
    // const interval = Duration(milliseconds: 50);
    // _elapsedMillis = 0;
    bluetoothManager.sendCommand(command.toString());
    log(command.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<FlutterBluetoothPlus>(
      builder: (context, bluetoothManager, child) {
        bool isConnected =
            bluetoothManager.connectedDevice?.isConnected ?? false;

        return Stack(
          children: [
            Positioned(
              top: 30,
              left: MediaQuery.of(context).size.width / 2 - 40,
              child: BluetoothConnectionButton(
                connectionStatusColor: isConnected ? Colors.green : Colors.red,
                onTap: () =>
                    {Navigator.pushNamed(context, flutterBluePlusRoute)},
              ),
            ),
            Positioned(
              top: 10,
              bottom: 10,
              left: 20,
              right: MediaQuery.of(context).size.width / 2,
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(right: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ArrowButton(
                        arrowIcon: Icons.arrow_upward,
                        arrow: "Up",
                        onTapDown: () =>
                            _updatePressedButtons(bluetoothManager, "up", true),
                        onTapUp: () => _updatePressedButtons(
                            bluetoothManager, "up", false),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ArrowButton(
                        arrowIcon: Icons.arrow_downward,
                        arrow: "Down",
                        onTapDown: () => _updatePressedButtons(
                            bluetoothManager, "down", true),
                        onTapUp: () => _updatePressedButtons(
                            bluetoothManager, "down", false),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 20,
              bottom: 10,
              left: MediaQuery.of(context).size.width / 2,
              child: Container(
                margin: const EdgeInsets.only(left: 40),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.withOpacity(0.2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Speed Bar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Slider(
                            value: _speedSliderValue,
                            max: 100,
                            divisions: 10,
                            label: _speedSliderValue.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                _speedSliderValue = value;

                                sendBluetoothCommand(bluetoothManager, {
                                  "speed": _speedSliderValue.round().toString()
                                });
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: ArrowButton(
                              arrowIcon: Icons.arrow_back,
                              arrow: "Left",
                              onTapDown: () => _updatePressedButtons(
                                  bluetoothManager, "left", true),
                              onTapUp: () => _updatePressedButtons(
                                  bluetoothManager, "left", false),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ArrowButton(
                              arrowIcon: Icons.arrow_forward,
                              arrow: "Right",
                              onTapDown: () => _updatePressedButtons(
                                  bluetoothManager, "right", true),
                              onTapUp: () => _updatePressedButtons(
                                  bluetoothManager, "right", false),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Positioned(
            //   top: 10,
            //   bottom: 10,
            //   right: 20,
            //   left: MediaQuery.of(context).size.width / 2,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           const Text("Motor Switch"),
            //           Switch(
            //               value: motorSwitch,
            //               onChanged: (value) {
            //                 if (value) {
            //                   sendBluetoothCommand(
            //                     bluetoothManager,
            //                     {
            //                       "motor-switch": "1",
            //                     },
            //                   );
            //                 } else {
            //                   sendBluetoothCommand(
            //                     bluetoothManager,
            //                     {
            //                       "motor-switch": "0",
            //                     },
            //                   );
            //                 }
            //                 setState(() {
            //                   motorSwitch = value;
            //                 });
            //               }),
            //         ],
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           const Text("Servo switch"),
            //           Switch(
            //               value: servoSwitch,
            //               onChanged: (value) {
            //                 if (value) {
            //                   sendBluetoothCommand(
            //                     bluetoothManager,
            //                     {
            //                       "servo-switch": "1",
            //                     },
            //                   );
            //                 } else {
            //                   sendBluetoothCommand(
            //                     bluetoothManager,
            //                     {
            //                       "servo-switch": "0",
            //                     },
            //                   );
            //                 }
            //                 setState(() {
            //                   servoSwitch = value;
            //                 });
            //               }),
            //         ],
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           const Text("Servo 1 "),
            //           Slider(
            //             value: _servoTwoSliderValue,
            //             max: 360,
            //             divisions: 16,
            //             label: _servoTwoSliderValue.round().toString(),
            //             onChanged: (double value) {
            //               setState(() {
            //                 _servoTwoSliderValue = value;

            //                 sendBluetoothCommand(bluetoothManager, {
            //                   "servo-1": _servoTwoSliderValue.round().toString()
            //                 });
            //               });
            //             },
            //           ),
            //         ],
            //       ),
            //       const SizedBox(
            //         height: 20,
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           const Text("Servo 2"),
            //           Slider(
            //             value: _servoOneSliderValue,
            //             max: 360,
            //             divisions: 16,
            //             label: _servoOneSliderValue.round().toString(),
            //             onChanged: (double value) {
            //               setState(() {
            //                 _servoOneSliderValue = value;

            //                 sendBluetoothCommand(bluetoothManager, {
            //                   "servo-2": _servoOneSliderValue.round().toString()
            //                 });
            //               });
            //             },
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // )
          ],
        );
      },
    ));
  }
}
