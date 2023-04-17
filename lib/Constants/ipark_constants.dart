import 'package:flutter/material.dart';

class IParkConstants {

  static const double textLetterSpacing = -0.41;

  static const String fontFamilyText = "Circular-Std";
  static const String fontFamilyTextSfUi = "Sf-Pro-Text";

}

class IParkPaddings {
  static EdgeInsets mainScaffoldPadding = const EdgeInsets.symmetric(horizontal: 16,vertical: 16);

}

class IParkColors {
  static Color blackHeadlineColor = Colors.black;
  static Color descriptionTextColor = const Color.fromRGBO(96, 119, 153, 1);
  static Color ctaButtonBackgroundColor = const Color.fromRGBO(128, 148, 175, 1);
  static Color activeInputBorderColor = const Color.fromRGBO(64, 90, 131, 1);
  static Color stableInputBorderColor = Colors.grey;

}

class IParkStyles {

  static TextStyle font32HeadlineTextStyle = TextStyle(
    letterSpacing: IParkConstants.textLetterSpacing,
    fontFamily: "Circular-Std",
    fontWeight: FontWeight.w700,
    fontSize: 32,
    color: IParkColors.blackHeadlineColor,
  );

  static TextStyle font28HeadlineTextStyle = TextStyle(
    letterSpacing: IParkConstants.textLetterSpacing,
    fontFamily: "Circular-Std",
    fontWeight: FontWeight.w700,
    fontSize: 28,
    color: IParkColors.blackHeadlineColor,
  );

  static TextStyle font16DescriptionTextStyle = TextStyle(
    letterSpacing: IParkConstants.textLetterSpacing,
    fontFamily: "Circular-Std",
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: IParkColors.descriptionTextColor,
  );

  static TextStyle font16TextButtonTextStyle = const TextStyle(
    letterSpacing: IParkConstants.textLetterSpacing,
    fontFamily: "Circular-Std",
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: Colors.grey,
  );

  static TextStyle inputPlaceholderStyle = const TextStyle(
    fontFamily: IParkConstants.fontFamilyText,
    letterSpacing: IParkConstants.textLetterSpacing,
    fontSize: 18,
    color: Color.fromRGBO(190, 190, 190, 1),
  );

  static TextStyle inputTextStyle = TextStyle(
    fontFamily: IParkConstants.fontFamilyText,
    letterSpacing: IParkConstants.textLetterSpacing,
    fontSize: 18,
    color: IParkColors.blackHeadlineColor,
  );

}