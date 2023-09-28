import 'package:flutter/material.dart';

SizedBox customVerticalSpace(double height) {
  return SizedBox(height: height);
}

SizedBox customHorizontalSpace(double width) {
  return SizedBox(width: width);
}

Text customText({customTextValue, customTextStyle, customTextAlign}) =>
    Text(customTextValue, style: customTextStyle, textAlign: customTextAlign);
