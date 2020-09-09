import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  String _token = '';
  String _profileImage = '';
  TextEditingController _usernameController = new TextEditingController();
  String _id = '';
  String _userId = '';

  String get token => _token;
  String get profileImage => _profileImage;
  TextEditingController get usernameController => _usernameController;
  String get id => _id;
  String get userId => _userId;

  void setProfileImage(String profileImage) {
    _profileImage = profileImage;
    notifyListeners();
  }

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void setId(String id) {
    _id = id;
    notifyListeners();
  }

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }

  void reset() async {
    _token = '';
    _profileImage = '';
    _usernameController.text = '';
    _id = '';
    _userId = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('profileImage');
    await prefs.remove('username');
    await prefs.remove('userId');
  }
}
