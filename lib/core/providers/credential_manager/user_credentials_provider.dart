import 'package:flutter/material.dart';
import 'package:mind_lab_app/core/shared_preferences/login_credentials_shared_preferences.dart';

class UserCredentials with ChangeNotifier {
  String email = "";
  String password = "";

  UserCredentials() {
    _loadEmail();
    _loadPassword();
  }

  // load email
  Future<void> _loadEmail() async {
    email = await LoginCredentials.getUserEmail();
    print("Email: ${email}");
    notifyListeners();
  }

  // load password
  Future<void> _loadPassword() async {
    password = await LoginCredentials.getUserPassword();
    print("Password: ${password}");
    notifyListeners();
  }

  // update user email
  Future<void> updateUserEmail(String updatedEmail) async {
    email = updatedEmail;
    await LoginCredentials.saveEmail(updatedEmail);
    notifyListeners();
  }

  // update user password
  Future<void> updateUserPassword(String updatedPassword) async {
    password = updatedPassword;
    await LoginCredentials.savePassword(updatedPassword);
    notifyListeners();
  }
}
