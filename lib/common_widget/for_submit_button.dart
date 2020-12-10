import 'package:flutter/material.dart';
import 'package:time_tracker/common_widget/custom_raised_button.dart';

class ForSubmitButton extends CustomRaisedButton {
  ForSubmitButton({
    @required String text,
    VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          color: Colors.indigo,
          borderRadious: 4.0,
          onPressed: onPressed,
        );
}
