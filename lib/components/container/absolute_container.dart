import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ineed_flutter/constants/colors.dart';
import 'package:ineed_flutter/store/app_provider.dart';
import 'package:provider/provider.dart';

class AbsoluteContainer extends StatelessWidget {
  final Widget child;

  AbsoluteContainer({this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        context.watch<AppProvider>().loading
            ? Positioned(
                child: SpinKitChasingDots(
                  color: kLabelColor,
                  size: 60.0,
                ),
              )
            : Text(''),
      ],
    );
  }
}
