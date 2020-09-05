import 'package:flutter/material.dart';

const kHeaderStyle = TextStyle(
  fontSize: 35,
  fontWeight: FontWeight.bold,
);

const kTextFieldDecoration = InputDecoration(
  border: OutlineInputBorder(),
  isDense: true,
);

class LoginScreen extends StatelessWidget {
  static const routeName = 'LoginScreen';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                ),
                child: Text(
                  'Login',
                  style: kHeaderStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              Image(
                image: AssetImage(
                  'assets/images/sign_in.png',
                ),
                height: 300,
                fit: BoxFit.fitHeight,
              ),
              TextField(
                decoration: kTextFieldDecoration,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
