import 'dart:async';
import 'package:flutter/material.dart';
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
  Timer? _timer;

  void _startSliders() {
    _timer?.cancel(); // Avoid duplicate timers
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        for (int i = 0; i < _sliderValues.length; i++) {
          _sliderValues[i] += 1;
          if (_sliderValues[i] > 13) _sliderValues[i] = -13;
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
    });
  }

  Widget _buildSlider(int index) {
    return SfSlider.vertical(
      min: -13,
      max: 13,
      value: _sliderValues[index],
      interval: 1,
      stepSize: 1,
      showTicks: true,
      showLabels: true,
      enableTooltip: true,
      minorTicksPerInterval: 1,
      onChanged: (dynamic value) {
        setState(() {
          _sliderValues[index] = value;
        });
      },
    );
  }

  @override
  void dispose() {
    _stopSliders(); // Cancel timer when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harmonograph'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Sliders section
          Expanded(
            flex: 2,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => _buildSlider(index)),
              ),
            ),
          ),

          // Buttons section
          Expanded(
            flex: 1,
            child: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProjectButton(
                      onPressed: _startSliders,
                      buttonText: 'start',
                      buttonColor: AppPallete.contentColorGreen,
                      iconData: Icons.play_circle,
                    ),
                    ProjectButton(
                      onPressed: _stopSliders,
                      buttonText: 'stop',
                      buttonColor: AppPallete.contentColorRed,
                      iconData: Icons.stop_circle,
                    ),
                    ProjectButton(
                      onPressed: _resetSliders,
                      buttonText: 'reset',
                      buttonColor: AppPallete.contentColorYellow,
                      iconData: Icons.refresh,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
