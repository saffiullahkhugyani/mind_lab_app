import 'package:flutter/material.dart';
import 'package:mind_lab_app/core/providers/rashid_rover/command_list_provier.dart';
import 'package:mind_lab_app/core/theme/app_pallete.dart';
import 'package:mind_lab_app/features/rashid_rover/presentation/widgets/rover_arrow_button.dart';
import 'package:mind_lab_app/features/rashid_rover/presentation/widgets/rover_buttons.dart';
import 'package:mind_lab_app/features/rashid_rover/presentation/widgets/step_stored_card.dart';
import 'package:provider/provider.dart';

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
      body: Consumer<CommandList>(builder: (context, commandList, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  commandList.commands.length.toString(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 20),
                RoverButton(
                  buttonColor: AppPallete.errorColor,
                  onPressed: () {
                    commandList.deleteLastCommand();
                  },
                  buttonText: 'Cancel last step',
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StepStoredCard(
                    text: commandList.getForwardCount().toString(),
                    icon: Icons.arrow_upward),
                StepStoredCard(
                    text: commandList.getBackwardCount().toString(),
                    icon: Icons.arrow_downward),
                StepStoredCard(
                    text: commandList.getLeftCount().toString(),
                    icon: Icons.arrow_back),
                StepStoredCard(
                    text: commandList.getRightCount().toString(),
                    icon: Icons.arrow_forward),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoverArrowButton(
                  text: 'Forward',
                  arrowIcon: Icons.arrow_upward,
                  onTap: () {
                    commandList.addCommand('f');
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                RoverArrowButton(
                    text: 'Backward',
                    arrowIcon: Icons.arrow_downward,
                    onTap: () {
                      commandList.addCommand('b');
                    }),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoverArrowButton(
                  text: 'Left',
                  arrowIcon: Icons.arrow_back,
                  onTap: () {
                    commandList.addCommand('l');
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                RoverArrowButton(
                  text: 'Right',
                  arrowIcon: Icons.arrow_forward,
                  onTap: () {
                    commandList.addCommand('r');
                  },
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
