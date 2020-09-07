import 'package:flutter/material.dart';
import 'package:ineed_flutter/components/container/absolute_container.dart';
import 'package:ineed_flutter/constants/colors.dart';
import 'package:ineed_flutter/store/app_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = 'HomeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AbsoluteContainer(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: 15,
                  top: 10,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.menu,
                      size: 22,
                      color: kLabelColor,
                    ),
                    context.watch<AppProvider>().profileImage.isEmpty
                        ? CircleAvatar(
                            radius: 11,
                            backgroundImage: AssetImage(
                                'assets/images/avatar-placeholder.webp'),
                          )
                        : CircleAvatar(
                            radius: 11,
                            backgroundImage: NetworkImage(
                                context.watch<AppProvider>().profileImage),
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
