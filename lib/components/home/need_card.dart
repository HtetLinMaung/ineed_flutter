import 'package:flutter/material.dart';
import 'package:ineed_flutter/components/home/tag.dart';
import 'package:ineed_flutter/constants/api.dart';
import 'package:ineed_flutter/constants/colors.dart';
import 'package:ineed_flutter/models/NeedItem.dart';
import 'package:ineed_flutter/store/app_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/animation.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(
          milliseconds: 150,
        ),
        vsync: this);
    animation = Tween<double>(begin: 1, end: 0.95).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  void _toDatail() {
    context.read<AppProvider>().setId(widget.item.id);
    controller.forward().whenComplete(() {
      controller.reverse();
    });
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
