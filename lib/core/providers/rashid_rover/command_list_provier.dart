import 'package:flutter/material.dart';
import 'package:mind_lab_app/core/shared_preferences/rashid_rover_shared_preferences.dart';

class CommandList with ChangeNotifier {
  List<String> commands = [];
  int moveDuration = 0;
  int turnDuration = 0;
  int delayDuration = 0;

  CommandList() {
    _loadCommands();
    _loadMoveDuration();
    _loadTurnDuration();
    _loadDelayduration();
  }

  // update move duration, whenever new duration is inserted
  Future<void> updateMoveDuration(int moveStepDuration) async {
    moveDuration = moveStepDuration;
    await RoverCommands.saveMoveDuration(moveDuration);
    notifyListeners();
  }

  // load turn duration
  Future<void> _loadMoveDuration() async {
    moveDuration = await RoverCommands.loadMoveDuration();
    notifyListeners();
  }

  // update turn duration, whemever new duration is inserted
  Future<void> updateTurnDuration(int turnStepDuration) async {
    turnDuration = turnStepDuration;
    await RoverCommands.saveMoveDuration(moveDuration);
    notifyListeners();
  }

  // load turn duration
  Future<void> _loadTurnDuration() async {
    turnDuration = await RoverCommands.loadMoveDuration();
    notifyListeners();
  }

  // update delay duration, whenever new duration is inserted
  Future<void> updateDelayDuration(int delayBetweenSteps) async {
    delayDuration = delayBetweenSteps;
    await RoverCommands.saveDelayBetweenSteps(delayBetweenSteps);
    notifyListeners();
  }

  // load delay duration
  Future<void> _loadDelayduration() async {
    delayDuration = await RoverCommands.loadDelayBetweenSteps();
    notifyListeners();
  }

  // load commands from shared preferences
  Future<void> _loadCommands() async {
    commands = await RoverCommands.loadRoverCommands();
    notifyListeners();
  }

  // save commands to shared preferneces when a new command is added
  Future<void> addCommand(String command) async {
    commands.add(command);
    await RoverCommands.saveRoverCommands(commands);
    notifyListeners();
  }

  int getForwardCount() {
    int forwardCount = 0;
    if (commands.isNotEmpty) {
      for (var fCount in commands) {
        if (fCount == 'f') {
          forwardCount++;
        }
      }
    }
    return forwardCount;
  }

  int getBackwardCount() {
    int backwardCount = 0;
    if (commands.isNotEmpty) {
      for (var bCount in commands) {
        if (bCount == 'b') {
          backwardCount++;
        }
      }
    }
    return backwardCount;
  }

  int getLeftCount() {
    int leftCount = 0;
    if (commands.isNotEmpty) {
      for (var lCount in commands) {
        if (lCount == 'l') {
          leftCount++;
        }
      }
    }
    return leftCount;
  }

  int getRightCount() {
    int rightCount = 0;
    if (commands.isNotEmpty) {
      for (var rCount in commands) {
        if (rCount == 'r') {
          rightCount++;
        }
      }
    }
    return rightCount;
  }

  void deleteLastCommand() {
    if (commands.isNotEmpty) {
      commands.removeLast();
      notifyListeners();
    }
  }

  void clearAllCommands() {
    if (commands.isNotEmpty) {
      commands.clear();
      notifyListeners();
    }
  }
}
