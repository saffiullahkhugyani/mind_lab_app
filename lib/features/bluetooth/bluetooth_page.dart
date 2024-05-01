// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_classic/flutter_blue_classic.dart';

// class BluetoothPage extends StatefulWidget {
//   const BluetoothPage({super.key});

//   @override
//   State<BluetoothPage> createState() => _BluetoothPageState();
// }

// class _BluetoothPageState extends State<BluetoothPage> {
//   final _flutterBlueClassicPlugin = FlutterBlueClassic();

//   BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
//   StreamSubscription? _adapterStateSubscription;

//   final Set<BluetoothDevice> _scanResults = {};
//   StreamSubscription? _scanSubscription;

//   bool _isScanning = false;
//   StreamSubscription? _scanningStateSubscription;

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }

//   Future<void> initPlatformState() async {
//     BluetoothAdapterState adapterState = _adapterState;

//     try {
//       adapterState = await _flutterBlueClassicPlugin.adapterStateNow;
//       _adapterStateSubscription =
//           _flutterBlueClassicPlugin.adapterState.listen((current) {
//         if (mounted) setState(() => _adapterState = current);
//       });
//       _scanSubscription =
//           _flutterBlueClassicPlugin.scanResults.listen((device) {
//         if (mounted) setState(() => _scanResults.add(device));
//       });
//       _scanningStateSubscription =
//           _flutterBlueClassicPlugin.isScanning.listen((isScanning) {
//         if (mounted) setState(() => _isScanning = isScanning);
//       });
//     } catch (e) {
//       if (kDebugMode) print(e);
//     }

//     if (!mounted) return;

//     setState(() {
//       _adapterState = adapterState;
//     });
//   }

//   @override
//   void dispose() {
//     _adapterStateSubscription?.cancel();
//     _scanSubscription?.cancel();
//     _scanningStateSubscription?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<BluetoothDevice> scanResults = _scanResults.toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('FlutterBluePlus example app'),
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             title: const Text("Bluetooth Adapter state"),
//             subtitle: const Text("Tap to enable"),
//             trailing: Text(_adapterState.name),
//             leading: const Icon(Icons.settings_bluetooth),
//             onTap: () => _flutterBlueClassicPlugin.turnOn(),
//           ),
//           const Divider(),
//           if (scanResults.isEmpty)
//             const Center(child: Text("No devices found yet"))
//           else
//             for (var result in scanResults)
//               ListTile(
//                 title: Text("${result.name ?? "???"} (${result.address})"),
//                 subtitle: Text(
//                     "Bondstate: ${result.bondState.name}, Device type: ${result.type.name}"),
//                 trailing: Text("${result.rssi} dBm"),
//                 onTap: () async {
//                   BluetoothConnection? connection;
//                   try {
//                     connection =
//                         await _flutterBlueClassicPlugin.connect(result.address);
//                     if (!this.context.mounted) return;
//                     if (connection != null && connection.isConnected) {
//                       Navigator.pop(context, connection);
//                       print('Device found ${result.name}');
//                     }
//                   } catch (e) {
//                     print('exception: ${e}');
//                     connection?.dispose();
//                     ScaffoldMessenger.maybeOf(context)?.showSnackBar(
//                         const SnackBar(
//                             content: Text("Error connecting to device")));
//                   }
//                 },
//               )
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           if (_isScanning) {
//             _flutterBlueClassicPlugin.stopScan();
//           } else {
//             _scanResults.clear();
//             _flutterBlueClassicPlugin.startScan();
//           }
//         },
//         label: Text(_isScanning ? "Scanning..." : "Start device scan"),
//         icon: Icon(_isScanning ? Icons.bluetooth_searching : Icons.bluetooth),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mind_lab_app/core/bluetooth/bluetooth_manager.dart';
import 'package:provider/provider.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bluetooth'),
        ),
        body: Consumer<BluetoothManager>(
            builder: (context, bluetoothManager, child) {
          return ListView(
            children: [
              ListTile(
                title: const Text("Bluetooth Adapter state"),
                subtitle: const Text("Tap to enable"),
                trailing: Text(bluetoothManager.adapterState.name),
                leading: const Icon(Icons.settings_bluetooth),
                onTap: () {
                  bluetoothManager.turnOnBlutooth();
                },
              ),
              const Divider(color: Colors.black54),
              if (bluetoothManager.scanResults.isEmpty)
                const Center(child: Text('No devices found yet'))
              else
                for (var device in bluetoothManager.scanResults)
                  ListTile(
                    title: Text("${device.name ?? "???"} (${device.address})"),
                    subtitle: Text(
                        "Bondstate: ${device.bondState.name}, Device type: ${device.type.name}"),
                    trailing: Text("${device.rssi} dBm"),
                    onTap: () async {
                      if (bluetoothManager.bluetoothConnection != null &&
                          bluetoothManager.bluetoothConnection!.isConnected) {
                        bluetoothManager.disconnectDevice();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Device disconnected')));
                      } else {
                        await bluetoothManager.connectToDevice(device);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Connected to ${device.name}')));
                      }
                    },
                  )
            ],
          );
        }),
        floatingActionButton: Consumer<BluetoothManager>(
          builder: (context, bluetoothManager, child) {
            return FloatingActionButton.extended(
              onPressed: () {
                if (bluetoothManager.isScanning) {
                  bluetoothManager.stopScan();
                } else {
                  bluetoothManager.startScan();
                }
              },
              label: Text(bluetoothManager.isScanning
                  ? 'Scanning...'
                  : 'Start device scan'),
              icon: Icon(bluetoothManager.isScanning
                  ? Icons.bluetooth_searching
                  : Icons.bluetooth),
            );
          },
        ));
  }
}
