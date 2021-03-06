import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ineed_flutter/components/container/absolute_container.dart';
import 'package:ineed_flutter/components/home/need_card.dart';
import 'package:ineed_flutter/components/home/tag.dart';
import 'package:ineed_flutter/constants/api.dart';
import 'package:ineed_flutter/constants/colors.dart';
import 'package:ineed_flutter/models/NeedItem.dart';
import 'package:ineed_flutter/models/TagItem.dart';
import 'package:ineed_flutter/screens/create_need_screen.dart';
import 'package:ineed_flutter/screens/edit_profile_screen.dart';
import 'package:ineed_flutter/screens/landing_screen.dart';
import 'package:ineed_flutter/store/app_provider.dart';
import 'package:ineed_flutter/store/need_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum Profile { edit, logout }

const kMenuTextStyle = TextStyle(
  fontSize: 12,
  color: kLabelColor,
);
const kMenuItemHeight = 25.0;

class HomeScreen extends StatefulWidget {
  static const routeName = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTag = 0;

  @override
  void initState() {
    super.initState();
    IO.Socket socket = IO.io(host, <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.on('needs', (_) {
      _fetchNeeds();
    });
    _fetchNeeds();
  }

  void _fetchNeeds() async {
    final store = context.read<AppProvider>();
    try {
      if (!store.loading) {
        store.setLoading(true);
      }
      final response = await http.get(
        '$api/needs',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${store.token}',
        },
      );
      store.setLoading(false);
      print(response.body);
      var body = json.decode(response.body);
      if (response.statusCode == 500 && body['message'] == 'jwt expired') {
        _logoutHandler();
      }
      if (response.statusCode != 200) {
        return;
      }

      final List<dynamic> data = body['data'];
      print(data);
      final List<NeedItem> needs =
          data.map((e) => NeedItem.fromJson(e)).toList();
      context.read<NeedProvider>().setNeed(needs);
    } catch (err) {
      store.setLoading(false);
      print(err);
    }
  }

  void _logoutHandler() {
    context.read<AppProvider>().reset();
    Navigator.pushReplacementNamed(context, LandingScreen.routeName);
  }

  List<TagItem> getUniqueTags() {
    final needs = context.watch<NeedProvider>().needs;
    var initTags = [
      TagItem(
        color: Colors.white,
        title: 'All',
        id: 'all',
        active: true,
      ),
    ];
    needs.forEach((need) {
      initTags = [
        ...initTags,
        ...need.tags,
      ];
    });
    final List<TagItem> uniqueTags = [];
    initTags.forEach((tag) {
      if (uniqueTags.isEmpty ||
          !uniqueTags.map((e) => e.title).toList().contains(tag.title)) {
        uniqueTags.add(tag);
      }
    });

    return uniqueTags.asMap().entries.map((e) {
      var active = false;
      if (e.key == _currentTag) {
        active = true;
      }
      return TagItem(
        active: active,
        color: e.value.color,
        colorString: e.value.colorString,
        id: e.value.id,
        title: e.value.title,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppProvider>();
    final uniqueTags = getUniqueTags();
    var needs = context.watch<NeedProvider>().needs;
    if (_currentTag > 0) {
      needs = needs
          .where((element) => element.tags
              .map((e) => e.title)
              .toList()
              .contains(uniqueTags[_currentTag].title))
          .toList();
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: AbsoluteContainer(
          loading: store.loading,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: 15,
                  top: 10,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu,
                      size: 22,
                      color: kLabelColor,
                    ),
                    PopupMenuButton<Profile>(
                      onSelected: (profile) {
                        if (profile == Profile.logout) {
                          _logoutHandler();
                        } else {
                          Navigator.pushNamed(
                              context, EditProfileScreen.routeName);
                        }
                      },
                      itemBuilder: (context) => <PopupMenuEntry<Profile>>[
                        const PopupMenuItem<Profile>(
                          value: Profile.edit,
                          child: Text(
                            'Edit Profile',
                            style: kMenuTextStyle,
                          ),
                          height: kMenuItemHeight,
                        ),
                        const PopupMenuItem<Profile>(
                          value: Profile.logout,
                          child: Text(
                            'Logout',
                            style: kMenuTextStyle,
                          ),
                          height: kMenuItemHeight,
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: CircleAvatar(
                        radius: 11,
                        backgroundImage: store.profileImage.isEmpty
                            ? AssetImage(
                                'assets/images/avatar-placeholder.webp')
                            : NetworkImage(
                                store.profileImage,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 10,
                  left: 20,
                  right: 20,
                ),
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: uniqueTags.length,
                  itemBuilder: (context, index) {
                    return Tag(
                      title: uniqueTags[index].title,
                      onTap: () {
                        setState(() {
                          _currentTag = index;
                        });
                      },
                      active: uniqueTags[index].active,
                      color: uniqueTags[index].color,
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  itemCount: needs.length,
                  itemBuilder: (context, index) {
                    return NeedCard(
                      key: Key(needs[index].id),
                      item: needs[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, CreateNeedScreen.routeName),
        child: Icon(Icons.add),
        backgroundColor: kFabBtnColor,
      ),
    );
  }
}
