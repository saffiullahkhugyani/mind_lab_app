import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mind_lab_app/core/theme/app_pallete.dart';
import 'package:mind_lab_app/features/harmonograph/presentation/widgets/rover_buttons.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class HarmonographPage extends StatefulWidget {
  const HarmonographPage({super.key});

  @override
  State<HarmonographPage> createState() => _HarmonograpghPageState();
}

class _HarmonograpghPageState extends State<HarmonographPage> {
  List<double> _sliderValues = [0.0, 0.0, 0.0, 0.0];
  List<TextEditingController> _controllers = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      4,
      (index) =>
          TextEditingController(text: _sliderValues[index].toStringAsFixed(0)),
    );
  }

  void _startSliders() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        for (int i = 0; i < _sliderValues.length; i++) {
          _sliderValues[i] += 1;
          if (_sliderValues[i] > 13) _sliderValues[i] = -13;
          _controllers[i].text = _sliderValues[i].toStringAsFixed(0);
        }
      });
    });
  }

  void _stopSliders() {
    _timer?.cancel();
  }

  void _resetSliders() {
    _stopSliders();
    setState(() {
      _sliderValues = List.filled(4, 0.0);
      for (int i = 0; i < 4; i++) {
        _controllers[i].text = '0';
      }
    });
  }

  Widget _buildSlider(int index) {
    return Expanded(
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Text(
                'Motor ${index + 1}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SfSlider.vertical(
                  min: -13,
                  max: 13,
                  value: _sliderValues[index],
                  interval: 1,
                  stepSize: 1,
                  showTicks: true,
                  showLabels: true,
                  minorTicksPerInterval: 1,
                  enableTooltip: true,
                  tooltipTextFormatterCallback: (actualValue, formattedText) =>
                      actualValue.toStringAsFixed(0),
                  onChanged: (dynamic value) {
                    setState(() {
                      _sliderValues[index] = value;
                      _controllers[index].text = value.toStringAsFixed(0);
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 70,
                child: TextFormField(
                  controller: _controllers[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Value',
                    labelStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^-?\d{0,3}$')), // allows -13 and 13
                  ],
                  onChanged: (value) {
                    final numValue = double.tryParse(value);
                    if (numValue != null && numValue >= -13 && numValue <= 13) {
                      setState(() {
                        _sliderValues[index] = numValue;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stopSliders();
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // 🎨 Soft background
      appBar: AppBar(
        title: const Text('Harmonograph'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Sliders section
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _buildSlider(index)),
            ),
          ),
          // Buttons section
          Expanded(
            flex: 1,
            child: Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  ProjectButton(
                    onPressed: _startSliders,
                    buttonText: 'Start',
                    buttonColor: AppPallete.contentColorGreen,
                    iconData: Icons.play_circle,
                  ),
                  ProjectButton(
                    onPressed: _stopSliders,
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
            ),
          ),
        ],
      ),
    );
  }
}
