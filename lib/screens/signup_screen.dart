import 'package:flutter/material.dart';
import 'package:ineed_flutter/components/container/absolute_container.dart';
import 'package:ineed_flutter/components/form/input_label.dart';
import 'package:ineed_flutter/components/form/text_input.dart';
import 'package:ineed_flutter/constants/styles.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = 'SignupScreen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  bool _isEmail = true;
  bool _isPassword = true;
  bool _isConfirm = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: AbsoluteContainer(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Image(
                      image: AssetImage('assets/images/join.png'),
                      height: 300,
                      fit: BoxFit.fitHeight,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: Text(
                        'Sign Up',
                        style: kHeaderStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    InputLabel(
                      text: 'Email',
                    ),
                    TextInput(
                      controller: _emailController,
                      state: _isEmail,
                      errorLabel: 'Email must not be empty!',
                      onChange: (value) {
                        setState(() {
                          _isEmail = true;
                          if (value.isEmpty) {
                            _isEmail = false;
                          }
                        });
                      },
                    ),
                    InputLabel(
                      text: 'Password',
                    ),
                    TextInput(
                      obscureText: true,
                      controller: _passwordController,
                      state: _isPassword,
                      errorLabel: 'Password must not be empty!',
                      onChange: (value) {
                        setState(() {
                          _isPassword = true;
                          if (value.isEmpty) {
                            _isPassword = false;
                          }
                        });
                      },
                    ),
                    InputLabel(
                      text: 'Confirm Password',
                    ),
                    TextInput(
                      obscureText: true,
                      controller: _confirmController,
                      state: _isConfirm,
                      errorLabel: 'Password does not match!',
                      onChange: (value) {
                        setState(() {
                          _isConfirm = true;
                          if (_passwordController.text != value) {
                            _isConfirm = false;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
