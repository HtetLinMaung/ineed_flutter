import 'package:flutter/material.dart';

class TouchableOpacity extends StatefulWidget {
  final Function onTap;
  final Widget child;

  TouchableOpacity({
    @required this.onTap,
    this.child,
  });

  @override
  _TouchableOpacityState createState() => _TouchableOpacityState();
}

class _TouchableOpacityState extends State<TouchableOpacity> {
  double _opacity = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedOpacity(
        duration: Duration(
          milliseconds: 300,
        ),
        opacity: _opacity,
        onEnd: () {
          setState(() {
            _opacity = 1;
          });
        },
        child: widget.child,
      ),
      onTap: () {
        setState(() {
          _opacity = 0.1;
        });
        widget.onTap();
      },
    );
  }
}
