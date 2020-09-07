import 'package:flutter/material.dart';
import 'package:ineed_flutter/components/container/absolute_container.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = 'HomeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AbsoluteContainer(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
