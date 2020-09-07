import 'package:flutter/material.dart';
import 'package:ineed_flutter/components/container/absolute_container.dart';
import 'package:ineed_flutter/components/form/text_input.dart';
import 'package:ineed_flutter/constants/colors.dart';
import 'package:ineed_flutter/constants/styles.dart';
import 'package:ineed_flutter/store/app_provider.dart';
import 'package:provider/provider.dart';

class BasicInfoScreen extends StatelessWidget {
  static const routeName = 'BasicInfoScreen';

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppProvider>();

    void _continueHandler() {}

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
            ),
            child: AbsoluteContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Text(
                      'Basic Info',
                      style: kHeaderStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                          radius: 75,
                          backgroundImage: store.profileImage.isEmpty
                              ? AssetImage(
                                  'assets/images/avatar-placeholder.webp')
                              : NetworkImage(store.profileImage),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 6,
                    ),
                    padding: EdgeInsets.only(
                      left: 5,
                    ),
                    child: Text(
                      'Enter the Username associated with your account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                  TextInput(
                    hintText: 'Enter your name',
                    controller: store.usernameController,
                    errorLabel: 'Email must not be empty!',
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(''),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: RaisedButton(
                            textColor: Colors.white,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            onPressed: _continueHandler,
                            color: kLabelColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.0),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(''),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
