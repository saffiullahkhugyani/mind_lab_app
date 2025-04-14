import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mind_lab_app/core/flutter_blue_plus/flutter_blue_plus_manager.dart';
import 'package:mind_lab_app/core/theme/app_pallete.dart';
import 'package:mind_lab_app/features/harmonograph/presentation/widgets/rover_buttons.dart';
import '../../../../core/constants/routes.dart';
import '../widgets/bt_connection_button.dart';

class HarmonographPage extends StatefulWidget {
  const HarmonographPage({super.key});

  @override
  State<HarmonographPage> createState() => _HarmonographPageState();
}

class _HarmonographPageState extends State<HarmonographPage> {
  static const int motorCount = 4;
  static const double minSliderValue = -13;
  static const double maxSliderValue = 13;

  final List<double> _sliderValues = List.filled(motorCount, 0.0);
  final List<TextEditingController> _controllers = List.generate(
    motorCount,
    (index) => TextEditingController(text: '0'),
  );

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _syncControllersWithSliders();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  void _stopSliders(FlutterBluetoothPlus bluetoothManager) {
    _resetSliders();
    _sendSliderValues(bluetoothManager);
  }

  void _resetSliders() {
    if (mounted) {
      // Check if widget is still mounted before calling setState
      setState(() {
        for (int i = 0; i < motorCount; i++) {
          _sliderValues[i] = 0.0;
          _controllers[i].text = '0';
        }
      });
    }
  }

  void _syncControllersWithSliders() {
    for (int i = 0; i < motorCount; i++) {
      _controllers[i].text = _sliderValues[i].toStringAsFixed(0);
    }
  }

  void _sendSliderValues(FlutterBluetoothPlus bluetoothManager) {
    final Map<String, String> allMotorSpeeds = {};

    for (int i = 0; i < motorCount; i++) {
      final motor = 'M${i + 1}';
      final speed = _sliderValues[i].toInt().toString();
      allMotorSpeeds[motor] = speed;
    }

    // Log the whole command
    log(allMotorSpeeds.toString());

    // Send the entire command
    // sendBluetoothCommand(bluetoothManager, allMotorSpeeds);
  }

  Widget _buildSliderControl(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Motor ${index + 1}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Text('13',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        _buildVerticalSlider(index),
        const Text('-13',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildValueField(index),
      ],
    );
  }

  Future<void> sendBluetoothCommand(FlutterBluetoothPlus bluetoothManager,
      Map<String, String> command) async {
    // const interval = Duration(milliseconds: 50);
    // _elapsedMillis = 0;
    bluetoothManager.sendCommand(command.toString());
    log(command.toString());
  }

  Widget _buildVerticalSlider(int index) {
    return SizedBox(
      height: 200,
      child: RotatedBox(
        quarterTurns: 3,
        child: Slider(
          min: minSliderValue,
          max: maxSliderValue,
          divisions: (maxSliderValue - minSliderValue).toInt(),
          value: _sliderValues[index],
          onChanged: (value) {
            setState(() {
              _sliderValues[index] = value;
              _controllers[index].text = value.toStringAsFixed(0);
            });
          },
        ),
      ),
    );
  }

  Widget _buildValueField(int index) {
    return SizedBox(
      width: 70,
      child: TextFormField(
        controller: _controllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Value',
          labelStyle: const TextStyle(fontSize: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^-?\d{0,3}$')),
        ],
        onChanged: (value) {
          final parsed = double.tryParse(value);
          if (parsed != null &&
              parsed >= minSliderValue &&
              parsed <= maxSliderValue) {
            setState(() {
              _sliderValues[index] = parsed;
            });
          }
        },
        // onTap: _scrollToBottom,
      ),
    );
  }

  Widget _buildSlidersSection() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(motorCount, (index) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _buildSliderControl(index),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildControlButtons(bool isConnected, bool isKeyboardVisible,
      FlutterBluetoothPlus bluetoothManager) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          BluetoothConnectionButton(
            connectionStatusColor: isConnected ? Colors.green : Colors.red,
            onTap: () => Navigator.pushNamed(context, flutterBluePlusRoute),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              ProjectButton(
                onPressed: () {
                  _sendSliderValues(bluetoothManager);
                },
                buttonText: 'Start',
                buttonColor: AppPallete.contentColorGreen,
                iconData: Icons.play_circle,
              ),
              ProjectButton(
                onPressed: () {
                  _stopSliders(bluetoothManager);
                },
                buttonText: 'Stop',
                buttonColor: AppPallete.contentColorRed,
                iconData: Icons.stop_circle,
              ),
              ProjectButton(
                onPressed: _resetSliders,
                buttonText: 'Reset',
                buttonColor: AppPallete.contentColorYellow,
                iconData: Icons.refresh,
              ),
            ],
          ),
          // if (isKeyboardVisible) const SizedBox(height: 200),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Harmonograph'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: IntrinsicHeight(
              child: Consumer<FlutterBluetoothPlus>(
                builder: (context, bluetoothManager, _) {
                  final isConnected =
                      bluetoothManager.connectedDevice?.isConnected ?? false;

                  return Column(
                    children: [
                      _buildSlidersSection(),
                      _buildControlButtons(
                          isConnected, isKeyboardVisible, bluetoothManager),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
