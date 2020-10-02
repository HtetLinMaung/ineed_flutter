import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ineed_flutter/components/container/absolute_container.dart';
import 'package:ineed_flutter/components/form/input_label.dart';
import 'package:ineed_flutter/components/form/text_input.dart';
import 'package:ineed_flutter/components/home/tag.dart';
import 'package:ineed_flutter/components/touchable/touchable_opacity.dart';
import 'package:ineed_flutter/constants/api.dart';
import 'package:ineed_flutter/constants/colors.dart';
import 'package:ineed_flutter/models/ColorData.dart';
import 'package:ineed_flutter/models/NeedItem.dart';
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

class EditNeedScreen extends StatefulWidget {
  static const routeName = 'EditNeedScreen';

  @override
  _EditNeedScreenState createState() => _EditNeedScreenState();
}

class _EditNeedScreenState extends State<EditNeedScreen> {
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
  bool _isSatisfied = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _tagColors[0].selected = true;
    });
    _fetchNeed();
  }

  Future<void> _fetchNeed() async {
    try {
      final store = context.read<AppProvider>();
      setState(() {
        _loading = true;
      });
      final response = await http.get(
        '$api/needs/${store.id}',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${store.token}'
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final item = NeedItem.fromJson(json.decode(response.body)['data']);
        setState(() {
          _loading = false;
          _headerController.text = item.header;
          _bodyController.text = item.body;
          _tags = item.tags;
          _isSatisfied = item.status != "In progress";
        });
      }
    } catch (err) {
      print(err);
      setState(() {
        _loading = false;
      });
    }
  }

  void _unfocus() {
    FocusScope.of(context).unfocus();
    _completeEditingHandler();
  }

  void _colorTapHandler(String code) {
    setState(() {
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

  Future<void> _updateHandler() async {
    try {
      final store = context.read<AppProvider>();
      setState(() {
        _loading = true;
      });
      final response = await http.put('$api/needs/${store.id}',
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${store.token}'
          },
          body: jsonEncode(
            <String, dynamic>{
              'header': _headerController.text,
              'body': _bodyController.text,
              'tags': _tags
                  .map((e) => ({
                        'title': e.title,
                        'color': e.colorString,
                      }))
                  .toList(),
              'status': _isSatisfied,
            },
          ));
      setState(() {
        _loading = false;
      });
      print(response.body);
      if (response.statusCode == 200) {
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Edit Need',
                            style: kTitleStyle,
                            textAlign: TextAlign.center,
                          ),
                          Checkbox(
                              activeColor: kLabelColor,
                              value: _isSatisfied,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onChanged: (checked) {
                                setState(() {
                                  _isSatisfied = checked;
                                });
                              }),
                        ],
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
                            .map((e) => TouchableOpacity(
                                  onTap: () => _colorTapHandler(e.code),
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
                                'Update',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            onPressed: _headerController.text.isEmpty ||
                                    _bodyController.text.isEmpty ||
                                    _loading
                                ? null
                                : _updateHandler,
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
