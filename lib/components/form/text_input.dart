import 'package:flutter/material.dart';
import 'package:ineed_flutter/constants/colors.dart';

const kTextStyle = TextStyle(
  fontSize: 13,
  fontFamily: 'Poppins',
  height: 1.2,
);

class TextInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChange;
  final bool state;
  final String errorLabel;
  final bool obscureText;

  TextInput({
    this.controller,
    this.onChange,
    this.state = true,
    this.errorLabel = '',
    this.obscureText = false,
  });

  OutlineInputBorder getOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        color: state ? kLabelColor : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              focusedBorder: getOutlineInputBorder(),
              enabledBorder: getOutlineInputBorder(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              isDense: true,
            ),
            style: kTextStyle,
            controller: controller,
            onChanged: onChange,
            obscureText: obscureText,
          ),
        ),
        !state
            ? Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                margin: EdgeInsets.only(
                  top: 5,
                ),
                child: Text(
                  errorLabel,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              )
            : Text(''),
      ],
    );
  }
}
