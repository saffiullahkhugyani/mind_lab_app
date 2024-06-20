import 'package:flutter/material.dart';
import 'package:mind_lab_app/core/providers/rashid_rover/command_list_provier.dart';
import 'package:provider/provider.dart';

class StepDurationPage extends StatefulWidget {
  const StepDurationPage({super.key});

  @override
  State<StepDurationPage> createState() => _StepDurationPageState();
}

class _StepDurationPageState extends State<StepDurationPage> {
  late final TextEditingController _moveController;
  late final TextEditingController _turnController;
  late final TextEditingController _delayController;

  @override
  void dispose() {
    _moveController.dispose();
    _turnController.dispose();
    _delayController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _moveController = TextEditingController();
    _turnController = TextEditingController();
    _delayController = TextEditingController();

    _moveController.addListener(_onMoveStepTextChanged);
    _turnController.addListener(_onTurnStepTextChanged);
    _delayController.addListener(_onDelayDurationTextChanged);

    // Fetch initial values from the notifier and set them to the controllers
    final notifier = Provider.of<CommandList>(context, listen: false);
    _initializeControllers(notifier);
  }

  void _initializeControllers(CommandList notifier) {
    _moveController.text = notifier.moveDuration.toString();
    _turnController.text = notifier.turnDuration.toString();
    _delayController.text = notifier.delayDuration.toString();
  }

  void _onMoveStepTextChanged() {
    final notifier = Provider.of<CommandList>(context, listen: false);

    if (_moveController.text.isNotEmpty) {
      notifier.updateMoveDuration(int.parse(_moveController.text));
    }
  }

  void _onTurnStepTextChanged() {
    final notifier = Provider.of<CommandList>(context, listen: false);

    if (_turnController.text.isNotEmpty) {
      notifier.updateTurnDuration(int.parse(_turnController.text));
    }
  }

  void _onDelayDurationTextChanged() {
    final notifier = Provider.of<CommandList>(context, listen: false);

    if (_delayController.text.isNotEmpty) {
      notifier.updateDelayDuration(int.parse(_delayController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step Duration'),
      ),
      body: Consumer<CommandList>(
        builder: (BuildContext context, CommandList value, Widget? child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Move Step Duration',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _moveController,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Turn Step Duration',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _turnController,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Delay Between Steps',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _delayController,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
