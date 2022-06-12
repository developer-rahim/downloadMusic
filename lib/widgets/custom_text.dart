import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  double? fontSize;
  String? text;
  Color? color;
  FontWeight? fontWeight;

  CustomText({this.text, this.fontSize, this.color, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style:
          TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight),
    );
  }
}
