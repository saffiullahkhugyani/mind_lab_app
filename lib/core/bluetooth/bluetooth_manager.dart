import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';

class BluetoothManager with ChangeNotifier {
  final FlutterBlueClassic _flutterBlueClassicPlugin = FlutterBlueClassic();

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  StreamSubscription? _adapterStateSubscription;

  final Set<BluetoothDevice> _scanResults = {};
  StreamSubscription? _scanSubscription;

  bool _isScanning = false;
  StreamSubscription? _scanningStateSubscription;

  BluetoothAdapterState get adapterState => _adapterState;
  Set<BluetoothDevice> get scanResults => _scanResults;
  bool get isScanning => _isScanning;

  BluetoothDevice? _connectedDevice;
  BluetoothConnection? _bluetoothConnection;

  BluetoothDevice? get connectedDevice => _connectedDevice;
  BluetoothConnection? get bluetoothConnection => _bluetoothConnection;

  BluetoothManager() {
    // Initialize Bluetooth state when the manager is created
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      _adapterState = await _flutterBlueClassicPlugin.adapterStateNow;
      _adapterStateSubscription =
          _flutterBlueClassicPlugin.adapterState.listen((current) {
        _adapterState = current;
        notifyListeners();
      });

      _scanSubscription =
          _flutterBlueClassicPlugin.scanResults.listen((device) {
        _scanResults.add(device);
        notifyListeners();
      });

      _scanningStateSubscription =
          _flutterBlueClassicPlugin.isScanning.listen((isScanning) {
        _isScanning = isScanning;
        notifyListeners();
      });
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  void startScan() {
    print('start scan');
    _scanResults.clear();
    _flutterBlueClassicPlugin.startScan();
    _isScanning = true;
    notifyListeners();
  }

  void stopScan() {
    _flutterBlueClassicPlugin.stopScan();
    _isScanning = false;
    notifyListeners();
  }

  void turnOnBlutooth() {
    _flutterBlueClassicPlugin.turnOn();
    notifyListeners();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      _bluetoothConnection =
          await _flutterBlueClassicPlugin.connect(device.address);

      _connectedDevice = device;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Failed to connect to device: $e');
    }
  }

  void disconnectDevice() {
    _bluetoothConnection?.close();
    _connectedDevice = null;
    _bluetoothConnection = null;
    notifyListeners();
  }

  void sendCommands(String command) async {
    if (bluetoothConnection!.isConnected) {
      bluetoothConnection?.output
          .add(Uint8List.fromList(utf8.encode("$command\r\n")));
    }
    await bluetoothConnection!.output.allSent;
    notifyListeners();
  }

  @override
  void dispose() {
    _adapterStateSubscription?.cancel();
    _scanSubscription?.cancel();
    _scanningStateSubscription?.cancel();
    super.dispose();
    notifyListeners();
  }
}
