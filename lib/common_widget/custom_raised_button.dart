import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final double borderRadious;
  final double height;
  final VoidCallback onPressed;

  const CustomRaisedButton(
      {Key key,
      this.color,
      this.borderRadious = 2.0,
      this.onPressed,
      this.child,
      this.height = 50.0})
      : assert(borderRadious != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        child: child,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadious),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
