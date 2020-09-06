import 'package:flutter/material.dart';

const kLabelStyle = TextStyle(
  fontSize: 14,
);

class InputLabel extends StatelessWidget {
  final String text;

  InputLabel({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 6,
      ),
      padding: EdgeInsets.only(
        left: 5,
      ),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: kLabelStyle,
      ),
    );
  }
}
