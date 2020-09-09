import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ineed_flutter/components/container/absolute_container.dart';
import 'package:ineed_flutter/components/form/text_input.dart';
import 'package:ineed_flutter/constants/api.dart';
import 'package:ineed_flutter/constants/colors.dart';
import 'package:ineed_flutter/constants/styles.dart';
import 'package:ineed_flutter/screens/home_screen.dart';
import 'package:ineed_flutter/store/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BasicInfoScreen extends StatefulWidget {
  static const routeName = 'BasicInfoScreen';

  @override
  _BasicInfoScreenState createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  double _currentOpacity = 1;
  String _profileImage = '';
  bool _loading = false;
  TextEditingController _usernameController = TextEditingController();
  final picker = ImagePicker();

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = pickedFile.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppProvider>();

    void _continueHandler() async {
      try {
        FocusScope.of(context).unfocus();
        final store = context.read<AppProvider>();
        final request =
            http.MultipartRequest('PUT', Uri.parse('$api/auth/edit-profile'));
        request.headers['Authorization'] = 'Bearer ${store.token}';
        request.fields['username'] = _usernameController.text;
        final filename = _profileImage.split('/').removeLast();
        final match = RegExp(r'\.(\w+)$').stringMatch(filename);
        final profileImage = await http.MultipartFile.fromPath(
          'profileImage',
          _profileImage,
          filename: filename,
          contentType: MediaType('image', match.replaceAll('\.', '')),
        );

        request.files.add(profileImage);
        setState(() {
          _loading = true;
        });
        final response = await request.send();
        setState(() {
          _loading = false;
        });

        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);

        final Map<String, dynamic> data = json.decode(responseString);
        print(data);
        if (data['status'] != 1) {
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
        store.setProfileImage(data['data']['profileImage'].isNotEmpty
            ? 'https://hlm-ineed.herokuapp.com/${data['data']['profileImage']}'
            : '');
        store.usernameController.text = data['data']['username'];
        prefs.setString(
            'profileImage',
            data['data']['profileImage'].isNotEmpty
                ? 'https://hlm-ineed.herokuapp.com/${data['data']['profileImage']}'
                : '');
        prefs.setString('username', data['data']['username']);
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } catch (err) {
        print(err);
      }
    }

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
            ),
            child: AbsoluteContainer(
              loading: _loading,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Text(
                      'Basic Info',
                      style: kHeaderStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _getImage();
                          setState(() {
                            _currentOpacity = 0.6;
                          });
                        },
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 150),
                          opacity: _currentOpacity,
                          onEnd: () {
                            setState(() {
                              _currentOpacity = 1;
                            });
                          },
                          child: CircleAvatar(
                            radius: 75,
                            backgroundImage: _profileImage.isEmpty
                                ? AssetImage(
                                    'assets/images/avatar-placeholder.webp')
                                : FileImage(
                                    File(
                                      _profileImage,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 6,
                    ),
                    padding: EdgeInsets.only(
                      left: 5,
                    ),
                    child: Text(
                      'Enter the Username associated with your account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                  TextInput(
                    hintText: 'Enter your name',
                    controller: _usernameController,
                    errorLabel: 'Email must not be empty!',
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
                                'Continue',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            onPressed: !_loading ? _continueHandler : null,
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
    );
  }
}
