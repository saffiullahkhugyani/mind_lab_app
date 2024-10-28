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
  double _servoOneSliderValue = 0;
  double _servoTwoSliderValue = 0;
  bool motorSwitch = false;
  bool servoSwitch = false;
  var sendingCommand = 's';

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

  Future<void> sendBluetoothCommand(FlutterBluetoothPlus bluetoothManager,
      Map<String, String> command) async {
    // const interval = Duration(milliseconds: 50);
    // _elapsedMillis = 0;
    bluetoothManager.sendCommand(command.toString());
    log(command.toString());

    // await Future.doWhile(() async {
    //   await Future.delayed(interval, () {
    //     bluetoothManager.sendCommand(command);
    //     setState(() {
    //       sendingCommand = command;
    //     });
    //   });

    //   log(_elapsedMillis.toString());
    //   _elapsedMillis += interval.inMilliseconds;
    //   return _elapsedMillis < duration;
    // });
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
              bottom: 10,
              left: 20,
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ArrowButton(
                            arrowIcon: Icons.arrow_upward,
                            arrow: "Up",
                            onTapDown: () {
                              sendBluetoothCommand(
                                  bluetoothManager, {"up": "1"});
                            },
                            onTapUp: () {
                              sendBluetoothCommand(
                                  bluetoothManager, {"up": "0"});
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ArrowButton(
                                arrowIcon: Icons.arrow_back,
                                arrow: "Left",
                                onTapDown: () {
                                  sendBluetoothCommand(
                                      bluetoothManager, {"left": "3"});
                                },
                                onTapUp: () {
                                  sendBluetoothCommand(
                                      bluetoothManager, {"left": "0"});
                                },
                              ),
                              const SizedBox(
                                width: 80,
                              ),
                              ArrowButton(
                                arrowIcon: Icons.arrow_forward,
                                arrow: "Right",
                                onTapDown: () {
                                  sendBluetoothCommand(
                                      bluetoothManager, {"right": "4"});
                                },
                                onTapUp: () {
                                  sendBluetoothCommand(
                                      bluetoothManager, {"right": "0"});
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ArrowButton(
                            arrowIcon: Icons.arrow_downward,
                            arrow: "Down",
                            onTapDown: () {
                              sendBluetoothCommand(
                                  bluetoothManager, {"down": "2"});
                            },
                            onTapUp: () {
                              sendBluetoothCommand(
                                  bluetoothManager, {"down": "0"});
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                ],
              ),
            ),
            Positioned(
              top: 10,
              bottom: 10,
              right: 20,
              left: MediaQuery.of(context).size.width / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Motor Switch"),
                      Switch(
                          value: motorSwitch,
                          onChanged: (value) {
                            if (value) {
                              sendBluetoothCommand(
                                bluetoothManager,
                                {
                                  "motor-switch": "1",
                                },
                              );
                            } else {
                              sendBluetoothCommand(
                                bluetoothManager,
                                {
                                  "motor-switch": "0",
                                },
                              );
                            }
                            setState(() {
                              motorSwitch = value;
                            });
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Servo switch"),
                      Switch(
                          value: servoSwitch,
                          onChanged: (value) {
                            if (value) {
                              sendBluetoothCommand(
                                bluetoothManager,
                                {
                                  "servo-switch": "1",
                                },
                              );
                            } else {
                              sendBluetoothCommand(
                                bluetoothManager,
                                {
                                  "servo-switch": "0",
                                },
                              );
                            }
                            setState(() {
                              servoSwitch = value;
                            });
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Servo 1 "),
                      Slider(
                        value: _servoTwoSliderValue,
                        max: 360,
                        divisions: 16,
                        label: _servoTwoSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _servoTwoSliderValue = value;

                            sendBluetoothCommand(bluetoothManager, {
                              "servo-1": _servoTwoSliderValue.round().toString()
                            });
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Servo 2"),
                      Slider(
                        value: _servoOneSliderValue,
                        max: 360,
                        divisions: 16,
                        label: _servoOneSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _servoOneSliderValue = value;

                            sendBluetoothCommand(bluetoothManager, {
                              "servo-2": _servoOneSliderValue.round().toString()
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        );
      },
    ));
  }
}
