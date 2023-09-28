import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:swipe_animation/style/pallet.dart';
import 'package:swipe_animation/style/typography.dart';

SizedBox customVerticalSpace(double height) {
  return SizedBox(height: height);
}

SizedBox customHorizontalSpace(double width) {
  return SizedBox(width: width);
}

Text customText({customTextValue, customTextStyle, customTextAlign}) =>
    Text(customTextValue, style: customTextStyle, textAlign: customTextAlign);

TextButton customButton({
  required buttonOnTapped,
  required buttonText,
  buttonBorderRadius,
  buttonColor,
  buttonTextColor,
  buttonVisible,
}) {
  return TextButton(
    onPressed: buttonOnTapped,
    style: TextButton.styleFrom(
      backgroundColor: buttonColor ?? primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: buttonBorderRadius ?? BorderRadius.circular(8),
      ),
    ),
    child: Visibility(
      visible: buttonVisible ?? true,
      child: customText(
        customTextValue: buttonText,
        customTextStyle:
            bodyText3.copyWith(color: buttonTextColor ?? whiteColor),
      ),
    ),
  );
}

Future<dynamic> customDialog(BuildContext context) {
  return showDialog(
    barrierColor: primaryColor,
    barrierDismissible: false,
    context: context,
    builder: (context) => Dialog(
      child: IntrinsicHeight(
        child: Container(
          color: primaryColor,
          child: Center(
            child: LottieBuilder.asset('lib/assets/images/success.json'),
          ),
        ),
      ),
    ),
  );
}
