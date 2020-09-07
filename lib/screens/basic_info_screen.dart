import 'package:flutter/material.dart';
import 'package:ineed_flutter/components/container/absolute_container.dart';

class BasicInfoScreen extends StatefulWidget {
  static const routeName = 'BasicInfoScreen';

  @override
  _BasicInfoScreenState createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: AbsoluteContainer(
            child: ListView(
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
