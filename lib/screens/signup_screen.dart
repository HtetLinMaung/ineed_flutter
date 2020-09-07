import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ineed_flutter/components/container/absolute_container.dart';
import 'package:ineed_flutter/components/form/input_label.dart';
import 'package:ineed_flutter/components/form/text_input.dart';
import 'package:ineed_flutter/constants/api.dart';
import 'package:ineed_flutter/constants/colors.dart';
import 'package:ineed_flutter/constants/styles.dart';
import 'package:ineed_flutter/screens/basic_info_screen.dart';
import 'package:ineed_flutter/store/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

  void _signupHandler() async {
    try {
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _passwordController.text == _confirmController.text) {
        final store = context.read<AppProvider>();
        store.toggleLoading();
        final response = await http.put(
          '$api/auth/signup',
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(<String, String>{
            'email': _emailController.text,
            'password': _passwordController.text,
          }),
        );
        store.toggleLoading();
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        if (response.statusCode != 200) {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Something went wrong!'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(data['message']),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          return;
        }
        store.setToken(data['token']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        Navigator.pushReplacementNamed(context, BasicInfoScreen.routeName);
      }
    } catch (err) {
      print(err);
    }
  }

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
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(''),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: RaisedButton(
                              textColor: Colors.white,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              onPressed: _emailController.text.isEmpty ||
                                      _passwordController.text.isEmpty ||
                                      _passwordController.text !=
                                          _confirmController.text ||
                                      context.watch<AppProvider>().loading
                                  ? null
                                  : _signupHandler,
                              color: kLabelColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(''),
                        ),
                      ],
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
