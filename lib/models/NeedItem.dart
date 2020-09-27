import 'package:ineed_flutter/models/TagItem.dart';
import 'package:ineed_flutter/models/User.dart';

class NeedItem {
  NeedItem(
      {this.id,
      this.tags,
      this.header,
      this.body,
      this.status = "In progress",
      this.user,
      this.createdAt,
      this.updatedAt});

  final String id;
  final List<TagItem> tags;
  final String header;
  final String body;
  final String status;
  final User user;
  final String createdAt;
  final String updatedAt;

  factory NeedItem.fromJson(Map<String, dynamic> json) {
    List<dynamic> tagsMap = json['tags'];
    final List<TagItem> tags = tagsMap.map((e) => TagItem.fromJson(e)).toList();

    return NeedItem(
      body: json['body'],
      header: json['header'],
      id: json['_id'],
      status: json['status'],
      tags: tags,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      user: User.fromJson(json['user']),
    );
  }
}
