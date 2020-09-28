import 'package:flutter/material.dart';

class ColorData {
  final Color color;
  final String code;
  bool selected;

  ColorData({
    this.code,
    this.color,
    this.selected = false,
  });
}
