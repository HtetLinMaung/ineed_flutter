import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ineed_flutter/components/home/tag.dart';
import 'package:ineed_flutter/components/touchable/touchable_opacity.dart';
import 'package:ineed_flutter/constants/api.dart';
import 'package:ineed_flutter/constants/colors.dart';
import 'package:ineed_flutter/constants/utils.dart';
import 'package:ineed_flutter/models/Menu.dart';
import 'package:ineed_flutter/models/NeedItem.dart';
import 'package:ineed_flutter/screens/edit_need_screen.dart';
import 'package:ineed_flutter/screens/need_detail_screen.dart';
import 'package:ineed_flutter/store/app_provider.dart';
import 'package:ineed_flutter/store/need_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/animation.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:http/http.dart' as http;

const kFontSize = TextStyle(fontSize: 12);

class NeedCard extends StatefulWidget {
  final NeedItem item;

  const NeedCard({
    @required this.item,
    Key key,
  }) : super(key: key);

  @override
  _NeedCardState createState() => _NeedCardState();
}

class _NeedCardState extends State<NeedCard>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  List<Menu> menus = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      menus = [
        Menu(
            icon: Icons.visibility_off,
            text: "Hide",
            onTap: () {
              final store = context.read<NeedProvider>();
              store.setNeed(store.needs
                  .where((element) => element.id != widget.item.id)
                  .toList());
            }),
        Menu(
          icon: Icons.details,
          text: 'Detail',
          onTap: () => Navigator.pushNamed(context, NeedDetailScreen.routeName),
        ),
        Menu(
          icon: Icons.check_circle,
          text: 'Satisfy',
          onTap: () async {
            final store = context.read<AppProvider>();
            try {
              store.setLoading(true);
              final response = await http.put('$api/needs/${store.id}',
                  headers: <String, String>{
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ${store.token}'
                  },
                  body: jsonEncode(
                    <String, dynamic>{
                      'header': widget.item.header,
                      'body': widget.item.body,
                      'tags': widget.item.tags
                          .map((e) => ({
                                'title': e.title,
                                'color': e.colorString,
                              }))
                          .toList(),
                      'status': true,
                    },
                  ));
              store.setLoading(false);
              print(response.body);
            } catch (err) {
              store.setLoading(false);
              print(err);
            }
          },
        ),
        Menu(
          icon: Icons.edit,
          text: 'Edit',
          onTap: () => Navigator.pushNamed(context, EditNeedScreen.routeName),
        ),
        Menu(
          icon: Icons.delete,
          text: 'Delete',
          onTap: () => showDeleteDialog(context),
        ),
      ];
      if (widget.item.user.id != context.read<AppProvider>().userId) {
        menus = menus.sublist(0, 2);
      }
    });
    controller = AnimationController(
      duration: Duration(
        milliseconds: 150,
      ),
      vsync: this,
    );
    animation = Tween<double>(begin: 1, end: 0.95).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  void _toDatail() {
    context.read<AppProvider>().setId(widget.item.id);
    controller.forward().whenComplete(() {
      controller.reverse().whenComplete(() {
        Navigator.pushNamed(context, NeedDetailScreen.routeName);
      });
    });
  }

  Future<void> _showSettings() async {
    context.read<AppProvider>().setId(widget.item.id);
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 1);
    }

    showModalBottomSheet(
      barrierColor: Colors.white10,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: menus
                .map((e) => TouchableOpacity(
                      onTap: () {
                        Navigator.pop(context);
                        e.onTap();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            e.icon,
                            size: 22,
                            color: kLabelColor,
                          ),
                          Text(
                            e.text,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        );
      },
    );
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toDatail,
      onLongPressEnd: (detail) {
        controller.reverse();
      },
      onLongPressStart: (detail) {
        controller.forward();
      },
      onLongPress: _showSettings,
      child: ScaleTransition(
        scale: animation,
        child: Card(
          margin: EdgeInsets.symmetric(
            vertical: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            height: 250,
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 2,
                        color: kUnderlined,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: widget.item.user.profileImage.isEmpty
                            ? AssetImage(
                                'assets/images/avatar-placeholder.webp')
                            : NetworkImage(
                                '$host/${widget.item.user.profileImage}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Text(
                          widget.item.user.username,
                          style: kFontSize,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          Jiffy(widget.item.createdAt).format('dd.MM.yyyy'),
                          textAlign: TextAlign.right,
                          style: kFontSize,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Row(
                          children: widget.item.tags
                              .map((e) => Tag(
                                    margin: EdgeInsets.only(
                                      right: 5,
                                    ),
                                    title: e.title,
                                    color: e.color,
                                    onTap: () {},
                                  ))
                              .toList(),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: Text(
                          widget.item.header,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Text(
                        widget.item.body,
                        style: kFontSize,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.item.status,
                  style: TextStyle(
                    fontSize: 14,
                    color: kStatus[widget.item.status],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
