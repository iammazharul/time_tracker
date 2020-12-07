import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/common_widget/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    @required String text,
    @required String assetName,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(assetName != null),
        assert(text != null),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(assetName),
              Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: textColor,
                ),
              ),
              Image.asset(
                assetName,
                color: Color(0x00000000),
              ),
            ],
          ),
          color: color,
          // borderRadious: 8.0,
          onPressed: onPressed,
        );
}
