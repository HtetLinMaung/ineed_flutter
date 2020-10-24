import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ineed_flutter/components/container/absolute_container.dart';
import 'package:ineed_flutter/components/form/text_input.dart';
import 'package:ineed_flutter/components/touchable/touchable_opacity.dart';
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

class EditProfileScreen extends StatefulWidget {
  static const routeName = 'EditProfileScreen';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _profileImage = '';
  bool _loading = false;
  TextEditingController _usernameController = TextEditingController();
  bool _isUsername = true;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final store = context.read<AppProvider>();
    setState(() {
      _usernameController.text = store.username;
      _profileImage = store.profileImage;
    });
  }

  Future<void> _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = pickedFile.path;
    });
  }

  Future<void> _updateHandler() async {
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
          ? '$host/${data['data']['profileImage']}'
          : '');
      store.setUsername(data['data']['username']);
      prefs.setString(
          'profileImage',
          data['data']['profileImage'].isNotEmpty
              ? '$host/${data['data']['profileImage']}'
              : '');
      prefs.setString('username', data['data']['username']);
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } catch (err) {
      print(err);
    }
  }

  ImageProvider<Object> _buildProfileImage() {
    if (_profileImage.isEmpty) {
      return AssetImage('assets/images/avatar-placeholder.webp');
    } else if (_profileImage.startsWith("https")) {
      return NetworkImage(_profileImage);
    } else {
      return FileImage(File(
        _profileImage,
      ));
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
                      'Profile',
                      style: kHeaderStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TouchableOpacity(
                        onTap: _getImage,
                        child: CircleAvatar(
                          radius: 75,
                          backgroundImage: _buildProfileImage(),
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
                    errorLabel: 'Username must not be empty!',
                    state: _isUsername,
                    onChange: (text) {
                      setState(() {
                        _isUsername = true;
                        if (text.isEmpty) {
                          _isUsername = false;
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
                                'Update',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            onPressed: !_loading ? _updateHandler : null,
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
