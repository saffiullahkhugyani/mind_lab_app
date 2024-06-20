// import 'dart:async';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:mind_lab_app/core/constants/routes.dart';
// import 'package:mind_lab_app/core/flutter_blue_plus/flutter_blue_plus_manager.dart';
// import 'package:mind_lab_app/core/providers/rashid_rover/command_list_provier.dart';
// import 'package:mind_lab_app/features/rashid_rover/presentation/widgets/bt_connection_button.dart';
// import 'package:mind_lab_app/features/rashid_rover/presentation/widgets/rover_buttons.dart';
// import 'package:provider/provider.dart';

// class RoverMainPage extends StatefulWidget {
//   const RoverMainPage({super.key});

//   @override
//   State<RoverMainPage> createState() => _RoverMainPageState();
// }

// class _RoverMainPageState extends State<RoverMainPage> {
//   Timer? _timer;
//   int _elapsedSeconds = 0;

//   var sendingCommand = 's';

//   void sendBluetoothCommand(int millisec) {
//     log(millisec.toString());
//     log('Sending command');
//   }

//   void startSendingCommand() {
//     const duration = Duration(milliseconds: 50);
//     _elapsedSeconds = 0;
//     _timer = Timer.periodic(duration, (timer) {
//       sendBluetoothCommand(_elapsedSeconds);

//       _elapsedSeconds += duration.inMilliseconds;

//       if (_elapsedSeconds >= 3000) {
//         _timer?.cancel();
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Rashid Rover'),
//       ),
//       body: Consumer2<FlutterBluetoothPlus, CommandList>(
//         builder: (context, bluetoothManager, commandList, child) {
//           bool isConnected = false;
//           var commands = commandList.commands;
//           int moveDuration = commandList.moveDuration;
//           int turnDuration = commandList.turnDuration;
//           int delayStep = commandList.delayDuration;
//           if (bluetoothManager.connectedDevice != null) {
//             isConnected = bluetoothManager.connectedDevice!.isConnected;
//           }
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 BluetoothConnectionButton(
//                   connectionStatusColor:
//                       isConnected ? Colors.green : Colors.red,
//                   image: 'lib/assets/images/rashid_rover.png',
//                   onTap: () {
//                     Navigator.pushNamed(context, flutterBluePlusRoute);
//                   },
//                   icon: sendingCommand == 'f'
//                       ? Icons.arrow_upward
//                       : sendingCommand == 'b'
//                           ? Icons.arrow_downward
//                           : sendingCommand == 'l'
//                               ? Icons.arrow_back
//                               : sendingCommand == 'r'
//                                   ? Icons.arrow_forward
//                                   : Icons.play_arrow,
//                 ),
//                 const SizedBox(height: 10),
//                 if (isConnected)
//                   Text(
//                       'Connected to ${bluetoothManager.connectedDevice?.advName}')
//                 else
//                   const Text('Disconnected'),
//                 const SizedBox(height: 40),
//                 RoverButton(
//                   buttonText: 'Start',
//                   onPressed: () async {
//                     if (commands.isNotEmpty && isConnected) {
//                       for (var command in commands) {
//                         // await Future.delayed(const Duration(seconds: 1), () {
//                         //   bluetoothManager.sendCommand(command);
//                         //   setState(() {
//                         //     // print(sendingCommand);
//                         //     sendingCommand = command;
//                         //   });
//                         // });

//                         var duration = const Duration(milliseconds: 50);
//                         _elapsedSeconds = 0;
//                         await Future.doWhile(() async {
//                           // condition for 'f' and 'b'
//                           if (command == 'f' || command == 'b') {
//                             await Future.delayed(duration, () {
//                               bluetoothManager.sendCommand(command);
//                               setState(() {
//                                 // print(sendingCommand);
//                                 sendingCommand = command;
//                               });
//                             });

//                             log(_elapsedSeconds.toString());
//                             _elapsedSeconds += duration.inMilliseconds;
//                             if (_elapsedSeconds >= moveDuration) {
//                               return false;
//                             }
//                             // condition for 'r' and 'l'
//                           } else if (command == 'r' || command == 'l') {
//                             await Future.delayed(duration, () {
//                               bluetoothManager.sendCommand(command);
//                               setState(() {
//                                 // print(sendingCommand);
//                                 sendingCommand = command;
//                               });
//                             });

//                             log(_elapsedSeconds.toString());
//                             _elapsedSeconds += duration.inMilliseconds;
//                             if (_elapsedSeconds >= turnDuration) {
//                               return false;
//                             }
//                           }
//                           return true;
//                         });

//                         // const duration = Duration(milliseconds: 50);
//                         // _elapsedSeconds = 0;
//                         // _timer = Timer.periodic(duration, (timer) {
//                         //   log(_elapsedSeconds.toString());
//                         //   log(command);
//                         //   bluetoothManager.sendCommand(command);
//                         //   setState(() {
//                         //     // print(sendingCommand);
//                         //     sendingCommand = command;
//                         //   });

//                         //   _elapsedSeconds += duration.inMilliseconds;
//                         //   if (_elapsedSeconds >= 1000) {
//                         //     _timer?.cancel();
//                         //   }
//                         // });
//                       }
//                       print('it after the loop');
//                       sendingCommand = 's';
//                     }
//                     // await Future.delayed(const Duration(seconds: 1));
//                     bluetoothManager.sendCommand(sendingCommand);
//                   },
//                   buttonColor: Colors.green,
//                 ),
//                 const SizedBox(height: 30),
//                 RoverButton(
//                   buttonText: 'Clear all',
//                   onPressed: () {
//                     commandList.clearAllCommands();
//                   },
//                   buttonColor: Colors.red,
//                 ),
//                 const SizedBox(height: 30),
//                 RoverButton(
//                     buttonText: 'Record',
//                     onPressed: () {
//                       Navigator.pushNamed(context, roverControllerRoute);
//                     },
//                     buttonColor: Colors.blue)
//               ],
//             ),
//           );
//         },
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, stepDurationRoute);
//         },
//         child: const Icon(Icons.settings),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:developer';

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
  Timer? _timer;
  int _elapsedMillis = 0;
  var sendingCommand = 's';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> sendBluetoothCommand(FlutterBluetoothPlus bluetoothManager,
      String command, int duration) async {
    const interval = Duration(milliseconds: 50);
    _elapsedMillis = 0;

    await Future.doWhile(() async {
      await Future.delayed(interval, () {
        bluetoothManager.sendCommand(command);
        setState(() {
          sendingCommand = command;
        });
      });

      log(_elapsedMillis.toString());
      _elapsedMillis += interval.inMilliseconds;
      return _elapsedMillis < duration;
    });

    // Add delay after command execution
    await Future.delayed(Duration(milliseconds: duration));
  }

  Future<void> executeCommands(
      FlutterBluetoothPlus bluetoothManager, CommandList commandList) async {
    for (var command in commandList.commands) {
      if (command == 'f' || command == 'b') {
        await sendBluetoothCommand(
            bluetoothManager, command, commandList.moveDuration);
      } else if (command == 'r' || command == 'l') {
        await sendBluetoothCommand(
            bluetoothManager, command, commandList.turnDuration);
      }

      // Send stop command and wait for delay duration before the next command
      if (commandList.delayDuration > 0) {
        await sendBluetoothCommand(
            bluetoothManager, 's', commandList.delayDuration);
      }
    }

    // Reset the command to stop
    bluetoothManager.sendCommand('s');
    setState(() {
      sendingCommand = 's';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rashid Rover'),
      ),
      body: Consumer2<FlutterBluetoothPlus, CommandList>(
        builder: (context, bluetoothManager, commandList, child) {
          bool isConnected =
              bluetoothManager.connectedDevice?.isConnected ?? false;
          var commands = commandList.commands;

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
                      await executeCommands(bluetoothManager, commandList);
                    }
                  },
                  buttonColor: Colors.green,
                ),
                const SizedBox(height: 30),
                RoverButton(
                  buttonText: 'Clear all',
                  onPressed: commandList.clearAllCommands,
                  buttonColor: Colors.red,
                ),
                const SizedBox(height: 30),
                RoverButton(
                  buttonText: 'Record',
                  onPressed: () {
                    Navigator.pushNamed(context, roverControllerRoute);
                  },
                  buttonColor: Colors.blue,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, stepDurationRoute);
        },
        child: const Icon(Icons.settings),
      ),
    );
  }
}
