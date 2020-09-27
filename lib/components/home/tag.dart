import 'package:flutter/material.dart';

class Tag extends StatefulWidget {
  final Color color;
  final String title;
  final bool active;
  final Function onTap;
  final EdgeInsetsGeometry margin;

  const Tag({
    this.color,
    @required this.title,
    this.active = true,
    @required this.onTap,
    this.margin = const EdgeInsets.symmetric(horizontal: 5),
    Key key,
  }) : super(key: key);

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
  double _currentOpacity = 1.0;

  void _resetOpacity() {
    setState(() {
      _currentOpacity = 1;
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentOpacity = 0.1;
          });
        },
        child: AnimatedOpacity(
          opacity: _currentOpacity,
          onEnd: _resetOpacity,
          duration: Duration(
            milliseconds: 150,
          ),
          child: Opacity(
            opacity: widget.active ? 1 : 0.7,
            child: Chip(
              padding: EdgeInsets.symmetric(
                horizontal: 2,
              ),
              backgroundColor: widget.color,
              label: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 12,
                  color: widget.color == Colors.white
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
