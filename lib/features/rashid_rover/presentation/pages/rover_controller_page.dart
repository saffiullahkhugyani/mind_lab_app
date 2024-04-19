import 'package:flutter/material.dart';
import 'package:mind_lab_app/features/rashid_rover/presentation/widgets/rover_arrow_button.dart';
import 'package:mind_lab_app/features/rashid_rover/presentation/widgets/step_stored_card.dart';

class RoverControllerPage extends StatefulWidget {
  const RoverControllerPage({super.key});

  @override
  State<RoverControllerPage> createState() => _RoverControllerPageState();
}

class _RoverControllerPageState extends State<RoverControllerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rover Controller Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StepStoredCard(text: '0', icon: Icons.arrow_upward),
              StepStoredCard(text: '0', icon: Icons.arrow_downward),
              StepStoredCard(text: '0', icon: Icons.arrow_back),
              StepStoredCard(text: '0', icon: Icons.arrow_forward),
            ],
          ),
          const SizedBox(
            height: 60,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoverArrowButton(
                text: 'Forward',
                arrowIcon: Icons.arrow_upward,
                onTap: () {
                  print('farward');
                },
              ),
              const SizedBox(
                width: 20,
              ),
              RoverArrowButton(
                  text: 'Backward',
                  arrowIcon: Icons.arrow_downward,
                  onTap: () {
                    print('Backward');
                  }),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoverArrowButton(
                text: 'Left',
                arrowIcon: Icons.arrow_back,
                onTap: () {
                  print('Left');
                },
              ),
              const SizedBox(
                width: 20,
              ),
              RoverArrowButton(
                text: 'Right',
                arrowIcon: Icons.arrow_forward,
                onTap: () {
                  print('Right');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
