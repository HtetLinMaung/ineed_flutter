import 'package:flutter/material.dart';
import 'package:ineed_flutter/constants/colors.dart';
import 'package:ineed_flutter/screens/basic_info_screen.dart';
import 'package:ineed_flutter/screens/create_need_screen.dart';
import 'package:ineed_flutter/screens/edit_need_screen.dart';
import 'package:ineed_flutter/screens/edit_profile_screen.dart';
import 'package:ineed_flutter/screens/home_screen.dart';
import 'package:ineed_flutter/screens/landing_screen.dart';
import 'package:ineed_flutter/screens/login_screen.dart';
import 'package:ineed_flutter/screens/need_detail_screen.dart';
import 'package:ineed_flutter/screens/signup_screen.dart';
import 'package:ineed_flutter/store/app_provider.dart';
import 'package:ineed_flutter/store/need_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => AppProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => NeedProvider(),
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
      initialRoute: LandingScreen.routeName,
      routes: {
        LandingScreen.routeName: (context) => LandingScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        SignupScreen.routeName: (context) => SignupScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        BasicInfoScreen.routeName: (context) => BasicInfoScreen(),
        CreateNeedScreen.routeName: (context) => CreateNeedScreen(),
        EditNeedScreen.routeName: (context) => EditNeedScreen(),
        NeedDetailScreen.routeName: (context) => NeedDetailScreen(),
        EditProfileScreen.routeName: (context) => EditProfileScreen(),
      },
    );
  }
}
