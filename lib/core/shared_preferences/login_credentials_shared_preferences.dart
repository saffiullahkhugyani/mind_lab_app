import 'package:shared_preferences/shared_preferences.dart';

class LoginCredentials {
  static const _emailKey = 'save-email';
  static const _passwordKey = 'save-password';

  // save user email
  static Future<void> saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_emailKey, email);
  }

  // save user password
  static Future<void> savePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_passwordKey, password);
  }

  // get user email
  static Future<String> getUserEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? savedEmail = sharedPreferences.getString(_emailKey);
    return savedEmail ?? "";
  }

  // get user passwrod
  static Future<String> getUserPassword() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? savedPassword = sharedPreferences.getString(_passwordKey);
    return savedPassword ?? "";
  }
}
