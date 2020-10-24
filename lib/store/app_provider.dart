import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  String _token = '';
  String _profileImage = '';
  String _username = '';
  String _id = '';
  String _userId = '';
  bool _loading = true;

  String get token => _token;
  String get profileImage => _profileImage;
  String get username => _username;
  String get id => _id;
  String get userId => _userId;
  bool get loading => _loading;

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

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

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void reset() async {
    _token = '';
    _profileImage = '';
    _username = '';
    _id = '';
    _userId = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('profileImage');
    await prefs.remove('username');
    await prefs.remove('userId');
  }
}
