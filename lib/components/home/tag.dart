import 'package:flutter/material.dart';

class Tag extends StatefulWidget {
  final Color color;
  final String title;
  final bool active;
  final Function onTap;

  const Tag({
    this.color,
    @required this.title,
    this.active = true,
    @required this.onTap,
    Key key,
  }) : super(key: key);

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
  double _currentOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _resetOpacity();
  }

  void _resetOpacity() {
    setState(() {
      _currentOpacity = widget.active ? 1 : 0.7;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentOpacity = 0.1;
          });
          widget.onTap();
        },
        child: AnimatedOpacity(
          opacity: _currentOpacity,
          onEnd: _resetOpacity,
          duration: Duration(
            milliseconds: 150,
          ),
          child: Chip(
            backgroundColor: widget.color,
            label: Text(
              widget.title,
              style: TextStyle(
                fontSize: 12,
                color:
                    widget.color == Colors.white ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
