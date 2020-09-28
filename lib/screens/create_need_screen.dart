import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ineed_flutter/components/container/absolute_container.dart';
import 'package:ineed_flutter/components/form/input_label.dart';
import 'package:ineed_flutter/components/form/text_input.dart';
import 'package:ineed_flutter/components/home/tag.dart';
import 'package:ineed_flutter/constants/api.dart';
import 'package:ineed_flutter/constants/colors.dart';
import 'package:ineed_flutter/models/ColorData.dart';
import 'package:ineed_flutter/models/TagItem.dart';
import 'package:http/http.dart' as http;
import 'package:ineed_flutter/screens/home_screen.dart';
import 'package:ineed_flutter/store/app_provider.dart';
import 'package:provider/provider.dart';

const kTitleStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

const kSize = 30.0;

class CreateNeedScreen extends StatefulWidget {
  static const routeName = 'CreateNeedScreen';

  @override
  _CreateNeedScreenState createState() => _CreateNeedScreenState();
}

class _CreateNeedScreenState extends State<CreateNeedScreen> {
  bool _loading = false;
  TextEditingController _headerController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();
  TextEditingController _tagController = TextEditingController();
  bool _isHeader = true;
  bool _isBody = true;
  bool _isTag = true;
  List<ColorData> _tagColors = kTagColors
      .map((colorStr) => ColorData(
            code: colorStr,
            color: Color(int.parse(colorStr.replaceFirst('#', '0xFF'))),
          ))
      .toList();
  List<TagItem> _tags = [];
  Map<String, double> _colorsOpacity = {
    "#ffffff": 1.0,
    "#DEACFE": 1.0,
    "#3F9FFF": 1.0,
    "#F082AC": 1.0,
    "#FFC999": 1.0,
    "#C2CFDB": 1.0,
  };

  @override
  void initState() {
    super.initState();
    setState(() {
      _tagColors[0].selected = true;
    });
  }

  void _unfocus() {
    FocusScope.of(context).unfocus();
    _completeEditingHandler();
  }

  void _resetOpacity(String code) {
    setState(() {
      _colorsOpacity[code] = 1;
    });
  }

  void _colorTapHandler(String code) {
    setState(() {
      _colorsOpacity[code] = 0.1;
      _tagColors = _tagColors.map((e) {
        e.selected = false;
        if (e.code == code) {
          e.selected = true;
        }
        return e;
      }).toList();
    });
  }

  void _completeEditingHandler() {
    if (_tagController.text.isNotEmpty) {
      setState(() {
        final colorData = _tagColors.firstWhere((element) => element.selected);

        _tags.add(TagItem(
          id: DateTime.now().toIso8601String(),
          color: colorData.color,
          colorString: colorData.code,
          title: _tagController.text,
        ));
        _tagController.text = '';
      });
    }
  }

  Future<void> _saveHandler() async {
    try {
      final store = context.read<AppProvider>();
      setState(() {
        _loading = true;
      });
      final response = await http.post('$api/needs',
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${store.token}'
          },
          body: jsonEncode(<String, dynamic>{
            'header': _headerController.text,
            'body': _bodyController.text,
            'tags': _tags
                .map((e) => ({
                      'title': e.title,
                      'color': e.colorString,
                    }))
                .toList()
          }));
      setState(() {
        _loading = false;
      });
      print(response.body);
      if (response.statusCode == 201) {
        Navigator.pushNamed(context, HomeScreen.routeName);
      }
    } catch (err) {
      setState(() {
        _loading = false;
      });
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocus,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: AbsoluteContainer(
          loading: _loading,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 35.0,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 15,
                      ),
                      child: Text(
                        'Propose Need',
                        style: kTitleStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    InputLabel(
                      text: 'Title',
                    ),
                    TextInput(
                      controller: _headerController,
                      state: _isHeader,
                      errorLabel: 'Title must not be empty!',
                      onChange: (value) {
                        setState(() {
                          _isHeader = true;
                          if (value.isEmpty) {
                            _isHeader = false;
                          }
                        });
                      },
                    ),
                    InputLabel(
                      text: 'Need Detail',
                    ),
                    TextInput(
                      maxLines: 5,
                      controller: _bodyController,
                      state: _isBody,
                      errorLabel: 'Detail must not be empty!',
                      onChange: (value) {
                        setState(() {
                          _isBody = true;
                          if (value.isEmpty) {
                            _isBody = false;
                          }
                        });
                      },
                    ),
                    InputLabel(
                      text: 'Tags',
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 20,
                        top: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _tagColors
                            .map((e) => GestureDetector(
                                  onTap: () => _colorTapHandler(e.code),
                                  child: AnimatedOpacity(
                                    duration: Duration(
                                      milliseconds: 300,
                                    ),
                                    opacity: _colorsOpacity[e.code],
                                    onEnd: () => _resetOpacity(e.code),
                                    child: Container(
                                      width: kSize,
                                      height: kSize,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(kSize / 2),
                                          color: e.color),
                                      child: e.selected
                                          ? Center(
                                              child: Icon(
                                                Icons.check,
                                                color: kLabelColor,
                                                size: 16,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    TextInput(
                      controller: _tagController,
                      state: _isTag,
                      errorLabel: 'Tag name must not be empty!',
                      onChange: (value) {
                        setState(() {
                          _isTag = true;
                          if (value.isEmpty) {
                            _isTag = false;
                          }
                        });
                      },
                    ),
                    Container(
                      height: 200,
                      child: Wrap(
                        children: _tags
                            .map((e) => Tag(
                                  key: Key(e.id),
                                  onTap: () {
                                    setState(() {
                                      _tags.removeWhere(
                                          (element) => element.id == e.id);
                                    });
                                  },
                                  title: e.title,
                                  color: e.color,
                                ))
                            .toList(),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
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
                            onPressed: _headerController.text.isEmpty ||
                                    _bodyController.text.isEmpty ||
                                    _loading
                                ? null
                                : _saveHandler,
                            color: kPinkColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.0),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
