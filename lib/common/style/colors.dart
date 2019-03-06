import 'package:flutter/material.dart';

class GlobalColors {
  static const int primaryValue = 0xFFBDB76B;
  static const int primaryLightValue = 0xFFBDB76B;
  static const int primaryDarkValue = 0xFFBDB76B;
  static const MaterialColor primarySwatch = const MaterialColor(
    primaryValue,
    const <int, Color>{
      50: const Color(primaryLightValue),
      100: const Color(primaryLightValue),
      200: const Color(primaryLightValue),
      300: const Color(primaryLightValue),
      400: const Color(primaryLightValue),
      500: const Color(primaryValue),
      600: const Color(primaryDarkValue),
      700: const Color(primaryDarkValue),
      800: const Color(primaryDarkValue),
      900: const Color(primaryDarkValue),
    },
  );

  static const int white = 0xFFFFFFFF;
  static const int cardWhite = 0xFFFFFFFF;
  static const int textWhite = 0xFFFFFFFF;
  static const int miWhite = 0xffececec;
  static const int actionBlue = 0xff267aff;
  static const int mainBackgroundColor = miWhite;
  static const int mainTextColor = primaryDarkValue;
  static const int textColorWhite = white;
  static const int subTextColor = 0xff959595;
  static const int subLightTextColor = 0xffc4c4c4;

  //outlineButton border style
  static const BorderSide greenBorderSide =  BorderSide(color:Colors.green,width: 1.0,style: BorderStyle.solid);
}