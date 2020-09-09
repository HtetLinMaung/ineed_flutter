import 'package:flutter/material.dart';

class TagItem {
  TagItem({
    this.title,
    this.color,
    this.id,
    this.colorString,
    this.active = false,
  });

  final String title;
  final Color color;
  final String id;
  final String colorString;
  final bool active;

  factory TagItem.fromJson(Map<String, dynamic> json) {
    return TagItem(
      colorString: json['color'],
      id: json['_id'],
      title: json['title'],
      color: json['color'] == 'white'
          ? Colors.white
          : Color(int.parse(json['color'].replaceFirst('#', '0xFF'))),
      active: false,
    );
  }
}
