import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mind_lab_app/core/flutter_blue_plus/flutter_blue_plus_manager.dart';
import 'package:mind_lab_app/core/utils/show_snackbar.dart';
import 'package:provider/provider.dart';

class ScanResultTile extends StatefulWidget {
  const ScanResultTile({super.key, required this.result, this.onTap});

  final ScanResult result;
  final VoidCallback? onTap;

  @override
  State<ScanResultTile> createState() => _ScanResultTileState();
}

class _ScanResultTileState extends State<ScanResultTile> {
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;

  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;

  @override
  void initState() {
    super.initState();
    _connectionStateSubscription =
        widget.result.device.connectionState.listen((state) {
      _connectionState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    super.dispose();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  Widget _buildConnectButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      child: isConnected ? const Text('DISCONNECT') : const Text('CONNECT'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String deviceName = widget.result.device.advName;
    return Consumer<FlutterBluetoothPlus>(
      builder: (context, bluetoothManager, child) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.only(bottom: 8, left: 8, top: 8),
          margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: ListTile(
            title: Text(
                '${widget.result.device.advName} (${widget.result.device.remoteId})'),
            leading: Text(
              '${widget.result.rssi} dBm',
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
            trailing: ElevatedButton(
              onPressed: (widget.result.advertisementData.connectable)
                  ? () async {
                      if (!isConnected) {
                        await bluetoothManager
                            .onConnectPressed(widget.result.device);
                        Navigator.pop(context);
                        showFlashBar(
                          context,
                          'Connected to ${deviceName}',
                          FlashBarAction.success,
                        );
                      } else {
                        showFlashBar(
                          context,
                          '$deviceName is Disconnected',
                          FlashBarAction.warning,
                        );
                        bluetoothManager
                            .onDisconnectPressed(widget.result.device);
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: isConnected
                  ? const Text('DISCONNECT')
                  : const Text('CONNECT'),
            ),
          ),
        );
      },
    );
  }
}
