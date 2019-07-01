import 'package:flutter/material.dart';

class TextButton extends StatelessWidget {
  final Key key;
  final String buttonName;
  final VoidCallback onPressed;
  final TextStyle buttonTextStyle;

  TextButton({
    this.key,
    this.buttonName,
    this.onPressed,
    this.buttonTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return (new FlatButton(
      child: new Text(buttonName,
          textAlign: TextAlign.center, style: buttonTextStyle),
      onPressed: onPressed,
    ));
  }
}
