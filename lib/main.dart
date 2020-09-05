import 'package:flutter/material.dart';
import 'package:ineed_flutter/constants/colors.dart';
import 'package:ineed_flutter/screens/login_screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'Poppins',
          textTheme: TextTheme(
            bodyText2: TextStyle(
              color: kLabelColor,
            ),
          )),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
      },
    );
  }
}
