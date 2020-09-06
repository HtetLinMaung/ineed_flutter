import 'package:flutter/material.dart';
import 'package:ineed_flutter/constants/colors.dart';
import 'package:ineed_flutter/screens/login_screen.dart';
import 'package:ineed_flutter/screens/signup_screen.dart';
import 'package:ineed_flutter/store/app_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => AppProvider(),
      ),
    ], child: App()));

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
        SignupScreen.routeName: (context) => SignupScreen(),
      },
    );
  }
}
