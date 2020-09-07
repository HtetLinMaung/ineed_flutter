import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ineed_flutter/constants/colors.dart';
import 'package:ineed_flutter/screens/home_screen.dart';
import 'package:ineed_flutter/screens/login_screen.dart';
import 'package:ineed_flutter/store/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingScreen extends StatefulWidget {
  static const routeName = 'LandingScreen';

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    try {
      final store = context.read<AppProvider>();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isNotEmpty && store.token.isEmpty) {
        store.setToken(token);
      }
      final profileImage = prefs.getString('profileImage') ?? '';
      if (profileImage.isNotEmpty && store.profileImage.isNotEmpty) {
        store.setProfileImage(profileImage);
      }
      final username = prefs.getString('username') ?? '';
      if (username.isNotEmpty && store.usernameController.text.isEmpty) {
        store.usernameController.text = username;
      }
      final userId = prefs.getString('userId') ?? '';
      if (userId.isNotEmpty && store.userId.isEmpty) {
        store.setUserId(userId);
      }

      if (store.token.isEmpty) {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      } else {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SpinKitChasingDots(
          color: kLabelColor,
          size: 60.0,
        ),
      ),
    );
  }
}
