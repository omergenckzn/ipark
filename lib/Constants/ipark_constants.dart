import 'package:flutter/material.dart';

class IParkConstants {

  static const double textLetterSpacing = -0.41;

  static const String fontFamilyText = "Circular-Std";
  static const String fontFamilyTextSfUi = "Sf-Pro-Text";

}

class IParkPaddings {
  static EdgeInsets mainScaffoldPadding = const EdgeInsets.symmetric(horizontal: 16,vertical: 0);
  static EdgeInsets workerScaffoldPadding = const EdgeInsets.symmetric(horizontal: 32,vertical: 48);

}

class IParkColors {
  static Color blackHeadlineColor = Colors.black;
  static Color descriptionTextColor = const Color.fromRGBO(96, 119, 153, 1);
  static Color ctaButtonBackgroundColor = const Color.fromRGBO(128, 148, 175, 1);
  static Color activeInputBorderColor = const Color.fromRGBO(64, 90, 131, 1);
  static Color stableInputBorderColor = Colors.grey;
  static const Color greyBorderColor = Color.fromRGBO(190, 190, 190, 1);

}

class IParkStyles {

  static TextStyle font32HeadlineTextStyle = TextStyle(
    letterSpacing: IParkConstants.textLetterSpacing,
    fontFamily: "Circular-Std",
    fontWeight: FontWeight.w700,
    fontSize: 32,
    color: IParkColors.blackHeadlineColor,
  );


  static TextStyle datePickerDateIndicatorStyle = const TextStyle(
      fontFamily: IParkConstants.fontFamilyText,
      fontWeight: FontWeight.w400,
      letterSpacing: IParkConstants.textLetterSpacing,
      fontSize: 28);

  static TextStyle font28HeadlineTextStyle = TextStyle(
    letterSpacing: IParkConstants.textLetterSpacing,
    fontFamily: "Circular-Std",
    fontWeight: FontWeight.w700,
    fontSize: 28,
    color: IParkColors.blackHeadlineColor,
  );

  static TextStyle font18GreyTextStyle = const TextStyle(
      color: IParkColors.greyBorderColor,
      fontFamily: IParkConstants.fontFamilyText,
      fontWeight: FontWeight.w500,
      letterSpacing: IParkConstants.textLetterSpacing,
      fontSize: 18);

  static TextStyle navigationBarItemTextStyle = const TextStyle(
    fontFamily: IParkConstants.fontFamilyTextSfUi,
    fontWeight: FontWeight.w600,
    fontSize: 10,
    letterSpacing: -0.41,
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

  static TextStyle font16PayTextStyle = TextStyle(
    letterSpacing: IParkConstants.textLetterSpacing,
    fontFamily: "Circular-Std",
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: IParkColors.activeInputBorderColor,
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