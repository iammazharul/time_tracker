import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/common_widget/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15.0,
              color: textColor,
            ),
          ),
          color: color,
          // borderRadious: 8.0,
          onPressed: onPressed,
        );
}
