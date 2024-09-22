import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mind_lab_app/core/flutter_blue_plus/flutter_blue_plus_manager.dart';
import 'package:mind_lab_app/features/arcage_game_one/presentation/widgets/bt_connection_button.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/routes.dart';
import '../widgets/arrow_button.dart';

class ArcadeGameOnePage extends StatefulWidget {
  const ArcadeGameOnePage({super.key});

  @override
  State<ArcadeGameOnePage> createState() => _ArcadeGameOnePageState();
}

class _ArcadeGameOnePageState extends State<ArcadeGameOnePage> {
  // Timer? _timer;
  // int _elapsedMillis = 0;
  double _currentSliderValue = 0;
  var sendingCommand = 's';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Arcade game one"),
        ),
        body: Consumer<FlutterBluetoothPlus>(
          builder: (context, bluetoothManager, child) {
            bool isConnected =
                bluetoothManager.connectedDevice?.isConnected ?? false;

            return Stack(
              children: [
                Positioned(
                  top: 30,
                  left: MediaQuery.of(context).size.width / 2 - 50,
                  child: BluetoothConnectionButton(
                    connectionStatusColor:
                        isConnected ? Colors.green : Colors.red,
                    onTap: () =>
                        {Navigator.pushNamed(context, flutterBluePlusRoute)},
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ArrowButton(
                          arrowIcon: Icons.arrow_upward,
                          onTap: () {
                            sendBluetoothCommand(
                                bluetoothManager, {"up-left": "1"});
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        ArrowButton(
                          arrowIcon: Icons.arrow_downward,
                          onTap: () {
                            sendBluetoothCommand(
                                bluetoothManager, {"down-left": "2"});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ArrowButton(
                          arrowIcon: Icons.arrow_upward,
                          onTap: () {
                            sendBluetoothCommand(
                                bluetoothManager, {"up-right": "1"});
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        ArrowButton(
                          arrowIcon: Icons.arrow_downward,
                          onTap: () {
                            sendBluetoothCommand(
                                bluetoothManager, {"down-right": "2"});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  left: 10,
                  child: Slider(
                      value: _currentSliderValue,
                      max: 255,
                      divisions: 20,
                      label: _currentSliderValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;

                          sendBluetoothCommand(bluetoothManager,
                              {"speed": _currentSliderValue.toString()});
                        });
                      }),
                )
              ],
            );
          },
        ));
  }
}
