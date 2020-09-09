import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ineed_flutter/constants/colors.dart';

class AbsoluteContainer extends StatelessWidget {
  final Widget child;
  final bool loading;

  AbsoluteContainer({
    this.child,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        loading
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
