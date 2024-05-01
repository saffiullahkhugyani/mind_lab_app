import 'package:flutter/material.dart';
import 'package:mind_lab_app/core/shared_preferences/rashid_rover_shared_preferences.dart';

class CommandList with ChangeNotifier {
  List<String> commands = [];

  CommandList() {
    _loadCommands();
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
