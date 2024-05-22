import 'package:flutter/material.dart';
import 'package:mind_lab_app/core/constants/routes.dart';
import 'package:mind_lab_app/core/flutter_blue_plus/flutter_blue_plus_manager.dart';
import 'package:mind_lab_app/core/providers/rashid_rover/command_list_provier.dart';
import 'package:mind_lab_app/features/rashid_rover/presentation/widgets/bt_connection_button.dart';
import 'package:mind_lab_app/features/rashid_rover/presentation/widgets/rover_buttons.dart';
import 'package:provider/provider.dart';

class RoverMainPage extends StatefulWidget {
  const RoverMainPage({super.key});

  @override
  State<RoverMainPage> createState() => _RoverMainPageState();
}

class _RoverMainPageState extends State<RoverMainPage> {
  var sendingCommand = 's';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rashid Rover'),
      ),
      body: Consumer2<FlutterBluetoothPlus, CommandList>(
        builder: (context, bluetoothManager, commandList, child) {
          bool isConnected = false;
          var commands = commandList.commands;
          if (bluetoothManager.connectedDevice != null) {
            isConnected = bluetoothManager.connectedDevice!.isConnected;
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BluetoothConnectionButton(
                  connectionStatusColor:
                      isConnected ? Colors.green : Colors.red,
                  image: 'lib/assets/images/rashid_rover.png',
                  onTap: () {
                    Navigator.pushNamed(context, flutterBluePlusRoute);
                  },
                  icon: sendingCommand == 'f'
                      ? Icons.arrow_upward
                      : sendingCommand == 'b'
                          ? Icons.arrow_downward
                          : sendingCommand == 'l'
                              ? Icons.arrow_back
                              : sendingCommand == 'r'
                                  ? Icons.arrow_forward
                                  : Icons.play_arrow,
                ),
                const SizedBox(height: 10),
                if (isConnected)
                  Text(
                      'Connected to ${bluetoothManager.connectedDevice?.advName}')
                else
                  const Text('Disconnected'),
                const SizedBox(height: 40),
                RoverButton(
                  buttonText: 'Start',
                  onPressed: () async {
                    if (commands.isNotEmpty && isConnected) {
                      for (var command in commands) {
                        await Future.delayed(const Duration(seconds: 1), () {
                          bluetoothManager.sendCommand(command);
                          setState(() {
                            // print(sendingCommand);
                            sendingCommand = command;
                          });
                        });
                      }

                      sendingCommand = 's';
                    }
                    await Future.delayed(const Duration(seconds: 1));
                    bluetoothManager.sendCommand(sendingCommand);
                  },
                  buttonColor: Colors.green,
                ),
                const SizedBox(height: 30),
                RoverButton(
                  buttonText: 'Clear all',
                  onPressed: () {
                    commandList.clearAllCommands();
                  },
                  buttonColor: Colors.red,
                ),
                const SizedBox(height: 30),
                RoverButton(
                    buttonText: 'Record',
                    onPressed: () {
                      Navigator.pushNamed(context, roverControllerRoute);
                    },
                    buttonColor: Colors.blue)
              ],
            ),
          );
        },
      ),
    );
  }
}
