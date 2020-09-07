import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ineed_flutter/components/container/absolute_container.dart';
import 'package:ineed_flutter/components/form/input_label.dart';
import 'package:ineed_flutter/components/form/text_input.dart';
import 'package:ineed_flutter/constants/api.dart';
import 'package:ineed_flutter/constants/colors.dart';
import 'package:ineed_flutter/constants/styles.dart';
import 'package:ineed_flutter/screens/home_screen.dart';
import 'package:ineed_flutter/screens/signup_screen.dart';
import 'package:ineed_flutter/store/app_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isEmail = true;
  bool _isPassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _getRemember();
  }

  Future<void> _getRemember() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('email') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
    });
  }

  void _loginHandler() async {
    try {
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        final store = context.read<AppProvider>();
        store.toggleLoading();
        final response = await http.post(
          '$api/auth/login',
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
            <String, String>{
              'email': _emailController.text,
              'password': _passwordController.text,
            },
          ),
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
        final prefs = await SharedPreferences.getInstance();
        if (_rememberMe) {
          prefs.setString('email', _emailController.text);
          prefs.setString('password', _passwordController.text);
        }
        store.setProfileImage(data['profileImage'].toString().isNotEmpty
            ? "$host/${data['profileImage']}"
            : '');
        store.setUserId(data['id']);
        store.setToken(data['token']);
        store.usernameController.text = data['username'];

        prefs.setString('profileImage', store.profileImage);
        prefs.setString('username', data['username']);
        prefs.setString('userId', data['id']);
        prefs.setString('token', data['token']);
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
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
          child: AbsoluteContainer(
            child: Center(
              child: ListView(
                shrinkWrap: true,
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 8,
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                activeColor: kLabelColor,
                                value: _rememberMe,
                                onChanged: (checked) {
                                  setState(() {
                                    _rememberMe = checked;
                                  });
                                },
                              ),
                              Text(
                                'Remember me',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 18,
                            top: 10,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(''),
                                flex: 1,
                              ),
                              Expanded(
                                flex: 8,
                                child: RaisedButton(
                                  textColor: Colors.white,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  onPressed: _emailController.text.isEmpty ||
                                          _passwordController.text.isEmpty ||
                                          context.watch<AppProvider>().loading
                                      ? null
                                      : _loginHandler,
                                  color: kLabelColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(''),
                                flex: 2,
                              ),
                              Expanded(
                                flex: 8,
                                child: OutlineButton(
                                  borderSide: BorderSide(
                                    color: kLabelColor,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Text(
                                      'SignUp',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: kLabelColor,
                                      ),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pushNamed(
                                      context, SignupScreen.routeName),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(''),
                                flex: 1,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Forget Password?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
