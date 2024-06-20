import 'package:shared_preferences/shared_preferences.dart';

class RoverCommands {
  static const _listKey = 'Rover-commands';
  static const _moveDurationKey = 'Move-duration';
  static const _turnDurationKey = 'Turn-duration';
  static const _delayBetweenStepsKey = 'delay-between-steps';

  // Load commands from shared preferences
  static Future<List<String>> loadRoverCommands() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedCommands = prefs.getStringList(_listKey);
    return storedCommands ?? [];
  }

  // Save commands into shared preferences
  static Future<void> saveRoverCommands(List<String> commands) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_listKey, commands);
  }

  // load move duration from shared preferences
  static Future<int> loadMoveDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? moveDuration = prefs.getInt(_moveDurationKey);
    return moveDuration ?? 1000;
  }

  // save move duration into shared preferences
  static Future<void> saveMoveDuration(int moveDuration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_moveDurationKey, moveDuration);
  }

  // load turn duration from shared preferences
  static Future<int> loadTurnDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? turnDuration = prefs.getInt(_turnDurationKey);
    return turnDuration ?? 1000;
  }

  // save turn duration into shared preferences
  static Future<void> saveTurnDuration(int turnDuration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_turnDurationKey, turnDuration);
  }

  // load delay between steps from shared preferences
  static Future<int> loadDelayBetweenSteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? delay = prefs.getInt(_delayBetweenStepsKey);
    return delay ?? 0;
  }

  // save delay between steps into shared preferences
  static Future<void> saveDelayBetweenSteps(int delay) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_delayBetweenStepsKey, delay);
  }
}
