import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppProvider with ChangeNotifier {
  bool _loading = false;
  String _token = '';
  String _profileImage = '';
  TextEditingController _usernameController = new TextEditingController();
  String _id = '';
  String _userId = '';

  bool get loading => _loading;
  String get token => _token;
  String get profileImage => _profileImage;
  TextEditingController get usernameController => _usernameController;
  String get id => _id;
  String get userId => _userId;

  void toggleLoading() {
    _loading = !_loading;
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
}
