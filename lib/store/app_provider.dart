import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppProvider with ChangeNotifier {
  bool _loading = false;
  String _token = '';
  TextEditingController _profileImageController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  String _id = '';
  String _userId = '';

  bool get loading => _loading;
  String get token => _token;
  TextEditingController get profileImageController => _profileImageController;
  TextEditingController get usernameController => _usernameController;
  String get id => _id;
  String get userId => _userId;

  void toggleLoading() {
    _loading = !_loading;
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
