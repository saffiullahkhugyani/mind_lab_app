import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mind_lab_app/core/flutter_blue_plus/flutter_blue_plus_manager.dart';
import 'package:mind_lab_app/features/flutter_blue_plus/presentation/widgets/scan_result_title.dart';
import 'package:provider/provider.dart';

class BluetoothPlusPage extends StatefulWidget {
  const BluetoothPlusPage({super.key});

  @override
  State<BluetoothPlusPage> createState() => _BluetoothPlusState();
}

class _BluetoothPlusState extends State<BluetoothPlusPage> {
  List<Widget> _buildScanResultTiles(
      BuildContext context, List<ScanResult> scanResult) {
    return scanResult
        .map(
          (r) => ScanResultTile(
            result: r,
            onTap: null,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bluetooth Plus'),
        ),
        body: Consumer<FlutterBluetoothPlus>(
          builder: (context, bluetoothManager, child) {
            return ListView(
              children: [
                ListTile(
                  title: const Text("Bluetooth Adapter state"),
                  subtitle: const Text("Tap to enable"),
                  leading: const Icon(Icons.settings_bluetooth),
                  trailing: Text(bluetoothManager.adapterState.name),
                  onTap: () {
                    bluetoothManager.turnOnBluetooth();
                  },
                ),
                const Divider(color: Colors.black54),
                if (bluetoothManager.scanResults.isEmpty ||
                    bluetoothManager.adapterState.name == 'off')
                  const Center(child: Text('No devices found yet'))
                else
                  ..._buildScanResultTiles(
                      context, bluetoothManager.scanResults)
              ],
            );
          },
        ),
        floatingActionButton: Consumer<FlutterBluetoothPlus>(
          builder: (context, bluetoothManager, child) {
            return FloatingActionButton.extended(
              onPressed: () {
                if (bluetoothManager.isScanning) {
                  bluetoothManager.onStopPressed();
                } else {
                  bluetoothManager.onPressedScan();
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
