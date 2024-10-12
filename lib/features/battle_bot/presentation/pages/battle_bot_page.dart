import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mind_lab_app/core/flutter_blue_plus/flutter_blue_plus_manager.dart';
import 'package:mind_lab_app/features/arcage_game_one/presentation/widgets/bt_connection_button.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/routes.dart';
import '../widgets/arrow_button.dart';

class BattleBotPage extends StatefulWidget {
  const BattleBotPage({super.key});

  @override
  State<BattleBotPage> createState() => _BattleBotPageState();
}

class _BattleBotPageState extends State<BattleBotPage> {
  var sendingCommand = 's';

  List<String> botModes = ['Off', 'Medium', 'Strong', 'Kill'];
  int id = 0;
  int _selectedRadioIndex = 0;

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
          title: const Text("Battle bot"),
        ),
        body: Consumer<FlutterBluetoothPlus>(
          builder: (context, bluetoothManager, child) {
            bool isConnected =
                bluetoothManager.connectedDevice?.isConnected ?? false;

            return Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                BluetoothConnectionButton(
                  connectionStatusColor:
                      isConnected ? Colors.green : Colors.red,
                  onTap: () =>
                      {Navigator.pushNamed(context, flutterBluePlusRoute)},
                ),
                SizedBox(
                  height: 50,
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
                            sendBluetoothCommand(bluetoothManager, {"up": "1"});
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        ArrowButton(
                          arrowIcon: Icons.arrow_downward,
                          onTap: () {
                            sendBluetoothCommand(
                                bluetoothManager, {"down": "2"});
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
                          arrowIcon: Icons.arrow_back,
                          onTap: () {
                            sendBluetoothCommand(
                                bluetoothManager, {"left": "1"});
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        ArrowButton(
                          arrowIcon: Icons.arrow_forward,
                          onTap: () {
                            sendBluetoothCommand(
                                bluetoothManager, {"right": "2"});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: botModes
                        .map((mode) => RadioListTile.adaptive(
                            title: Text(mode),
                            value: botModes.indexOf(mode),
                            groupValue: id,
                            onChanged: (val) {
                              setState(() {
                                id = botModes.indexOf(mode);
                                _selectedRadioIndex = val!;
                                sendBluetoothCommand(
                                    bluetoothManager, {"mode": mode});
                              });
                            }))
                        .toList())
              ],
            );
          },
        ));
  }
}
