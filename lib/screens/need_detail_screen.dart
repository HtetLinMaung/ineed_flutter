import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ineed_flutter/components/home/tag.dart';
import 'package:ineed_flutter/constants/api.dart';
import 'package:ineed_flutter/constants/colors.dart';
import 'package:ineed_flutter/constants/utils.dart';
import 'package:ineed_flutter/models/NeedItem.dart';
import 'package:http/http.dart' as http;
import 'package:ineed_flutter/screens/edit_need_screen.dart';
import 'package:ineed_flutter/screens/home_screen.dart';
import 'package:ineed_flutter/store/app_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

enum Item { edit, delete }

class NeedDetailScreen extends StatefulWidget {
  static const routeName = 'NeedDetailScreen';

  @override
  _NeedDetailScreenState createState() => _NeedDetailScreenState();
}

class _NeedDetailScreenState extends State<NeedDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<NeedItem> _fetchNeed(AppProvider store) async {
    final response = await http.get(
      '$api/needs/${store.id}',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${store.token}'
      },
    );
    print(response.body);
    return NeedItem.fromJson(json.decode(response.body)['data']);
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<NeedItem>(
          future: _fetchNeed(store),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                padding: EdgeInsets.only(
                  top: 35,
                  left: 20,
                  right: 20,
                ),
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Jiffy(snapshot.data.createdAt)
                              .format('MMMM dd, yyyy'),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        store.userId == snapshot.data.user.id
                            ? PopupMenuButton<Item>(
                                onSelected: (item) {
                                  if (Item.edit == item) {
                                    Navigator.pushNamed(
                                        context, EditNeedScreen.routeName);
                                  } else {
                                    showDeleteDialog(context);
                                  }
                                },
                                itemBuilder: (context) =>
                                    <PopupMenuEntry<Item>>[
                                  const PopupMenuItem<Item>(
                                    value: Item.edit,
                                    child: Text(
                                      'Edit',
                                      style: kMenuTextStyle,
                                    ),
                                    height: kMenuItemHeight,
                                  ),
                                  const PopupMenuItem<Item>(
                                    value: Item.delete,
                                    child: Text(
                                      'Delete',
                                      style: kMenuTextStyle,
                                    ),
                                    height: kMenuItemHeight,
                                  ),
                                ],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(
                                  Icons.more_horiz,
                                  color: kLabelColor,
                                ),
                              )
                            : Text(''),
                      ],
                    ),
                  ),
                  Text(
                    snapshot.data.header,
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  Wrap(
                    children: snapshot.data.tags
                        .map((e) => Tag(
                              title: e.title,
                              onTap: () {},
                              color: e.color,
                            ))
                        .toList(),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 10,
                      top: 20,
                      left: 6,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: snapshot
                                  .data.user.profileImage.isNotEmpty
                              ? NetworkImage(
                                  '$host/${snapshot.data.user.profileImage}')
                              : AssetImage(
                                  'assets/images/avatar-placeholder.webp'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7.0),
                          child: Text(snapshot.data.user.username),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 20,
                    ),
                    child: Text(
                      snapshot.data.body,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error),
              );
            } else {
              return Center(
                child: SpinKitChasingDots(
                  color: kLabelColor,
                  size: 60.0,
                ),
              );
            }
          }),
    );
  }
}
