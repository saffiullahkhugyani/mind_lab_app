import 'package:shared_preferences/shared_preferences.dart';

class RoverCommands {
  static const _listKey = 'Rover-commands';

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
}
