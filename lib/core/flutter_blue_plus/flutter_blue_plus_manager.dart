import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mind_lab_app/core/constants/bluetooth_constant.dart';
import 'package:mind_lab_app/core/utils/flutter_blue_plus_extra.dart';

class FlutterBluetoothPlus with ChangeNotifier {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  // List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultSubscription;
  late StreamSubscription<bool> _isScanningSubsctiption;

  BluetoothAdapterState get adapterState => _adapterState;
  List<ScanResult> get scanResults => _scanResults;
  bool get isScanning => _isScanning;

  List<BluetoothService> _services = [];

  BluetoothCharacteristic? controlCharacteristic;
  BluetoothDevice? _connectedDevice;

  BluetoothDevice? get connectedDevice => _connectedDevice;

  FlutterBluetoothPlus() {
    initState();
  }

  void initState() {
    try {
      _adapterStateStateSubscription =
          FlutterBluePlus.adapterState.listen((current) {
        _adapterState = current;
        notifyListeners();
      });

      _scanResultSubscription = FlutterBluePlus.scanResults.listen((results) {
        _scanResults = results;
        notifyListeners();
      });

      _isScanningSubsctiption = FlutterBluePlus.isScanning.listen((state) {
        _isScanning = state;
        notifyListeners();
      });
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    _isScanningSubsctiption.cancel();
    _scanResultSubscription.cancel();
    super.dispose();
    notifyListeners();
  }

  // method to start scan
  Future onPressedScan() async {
    // getting system devices
    // try {
    //   _systemDevices = await FlutterBluePlus.systemDevices;
    // } catch (e) {
    //   if (kDebugMode) print(e);
    // }

    // scanning for devices
    try {
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
      );
    } catch (e) {
      if (kDebugMode) print(e);
    }

    notifyListeners();
  }

  // method to stop scan
  Future onStopPressed() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  // method to connect to selected device
  Future onConnectPressed(BluetoothDevice device) async {
    await device.connectAndUpdateStream().catchError((e) async {
      if (kDebugMode) print(e);
    });
    _connectedDevice = device;
    try {
      await onDiscoverServicesPressed(device);
    } catch (e) {
      if (kDebugMode) print(e);
    }
    notifyListeners();
  }

  void onDisconnectPressed(BluetoothDevice device) {
    device.disconnectAndUpdateStream().catchError((e) {
      if (kDebugMode) print(e);
    });
    _connectedDevice = null;
    notifyListeners();
  }

  Future onDiscoverServicesPressed(BluetoothDevice device) async {
    try {
      _services = await device.discoverServices();
      for (BluetoothService service in _services) {
        if (service.uuid.toString() == serviceUuid) {
          for (BluetoothCharacteristic characteristic
              in service.characteristics) {
            if (characteristic.uuid.toString() == charUuidRx) {
              controlCharacteristic = characteristic;
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future sendCommand(String command) async {
    if (controlCharacteristic != null) {
      print('sending.. ${command}');
      await controlCharacteristic?.write(command.codeUnits,
          allowLongWrite: true);
    }
  }

  // returning bluetooth on state
  bool adapterStateOn() {
    bool adapterState = _adapterState == BluetoothAdapterState.on;
    return adapterState;
  }

  // returning bluetooth off state
  bool adapterStateOff() {
    bool adapterState = _adapterState == BluetoothAdapterState.off;
    return adapterState;
  }

  // turning bluetooth on
  Future<void> turnOnBluetooth() async {
    try {
      await FlutterBluePlus.turnOn();
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }
}
