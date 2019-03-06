// 文本样式
import 'package:campus/common/style/colors.dart';
import 'package:flutter/material.dart';

class ContextStyle{
  static const lagerTextSize = 30.0;
  static const bigTextSize = 23.0;
  static const normalTextSize = 18.0;
  static const middleTextWhiteSize = 16.0;
  static const smallTextSize = 14.0;
  static const minTextSize = 12.0;

  /// 用户主页 nickname
  static const mainNickname = TextStyle(
    color: Colors.black,
    fontSize: bigTextSize,
    fontWeight: FontWeight.bold,
  );
  /// 用户信息也 tip
  static const userInfoTitle = TextStyle(
    color: Colors.black,
    fontSize: middleTextWhiteSize,
    fontWeight: FontWeight.bold,
  );
  /// 动态主页 nickname
  static const itemNickname = TextStyle(
    color: Colors.black,
    fontSize: middleTextWhiteSize,
  );
  /// 动态主页 context
  static const itemContext = TextStyle(
    color: Colors.black,
    fontSize: smallTextSize,
  );
  /// 动态主页 时间
  static const itemCreatedAt = TextStyle(
    color: Colors.black87,
    fontSize: minTextSize,
  );
  /// 输入文本字体 样式
  static const inputContent = TextStyle(
    color: Colors.black,
    fontSize: normalTextSize,
  );
  /// user 页 item 文字样式
  static const userTitle = TextStyle(
    color: Colors.black,
    fontSize: normalTextSize,
  );
  static const smallTextWhite = TextStyle(
    color: Color(GlobalColors.textColorWhite),
    fontSize: smallTextSize,
  );

  static const smallText = TextStyle(
    color: Color(GlobalColors.mainTextColor),
    fontSize: smallTextSize,
  );

  static const smallTextBold = TextStyle(
    color: Color(GlobalColors.mainTextColor),
    fontSize: smallTextSize,
    fontWeight: FontWeight.bold,
  );

  static const smallSubLightText = TextStyle(
    color: Color(GlobalColors.subLightTextColor),
    fontSize: smallTextSize,
  );

  static const smallActionLightText = TextStyle(
    color: Color(GlobalColors.actionBlue),
    fontSize: smallTextSize,
  );

  static const smallMiLightText = TextStyle(
    color: Color(GlobalColors.miWhite),
    fontSize: smallTextSize,
  );

  static const smallSubText = TextStyle(
    color: Color(GlobalColors.subTextColor),
    fontSize: smallTextSize,
  );

  static const middleText = TextStyle(
    color: Color(GlobalColors.mainTextColor),
    fontSize: middleTextWhiteSize,
  );

  static const middleTextWhite = TextStyle(
    color: Color(GlobalColors.textColorWhite),
    fontSize: middleTextWhiteSize,
  );

  static const middleSubText = TextStyle(
    color: Color(GlobalColors.subTextColor),
    fontSize: middleTextWhiteSize,
  );

  static const middleSubLightText = TextStyle(
    color: Color(GlobalColors.subLightTextColor),
    fontSize: middleTextWhiteSize,
  );

  static const middleTextBold = TextStyle(
    color: Color(GlobalColors.mainTextColor),
    fontSize: middleTextWhiteSize,
    fontWeight: FontWeight.bold,
  );

  static const middleTextWhiteBold = TextStyle(
    color: Color(GlobalColors.textColorWhite),
    fontSize: middleTextWhiteSize,
    fontWeight: FontWeight.bold,
  );

  static const middleSubTextBold = TextStyle(
    color: Color(GlobalColors.subTextColor),
    fontSize: middleTextWhiteSize,
    fontWeight: FontWeight.bold,
  );

  static const normalText = TextStyle(
    color: Color(GlobalColors.mainTextColor),
    fontSize: normalTextSize,
  );

  static const normalTextBold = TextStyle(
    color: Color(GlobalColors.mainTextColor),
    fontSize: normalTextSize,
    fontWeight: FontWeight.bold,
  );

  static const normalSubText = TextStyle(
    color: Color(GlobalColors.subTextColor),
    fontSize: normalTextSize,
  );

  static const normalTextWhite = TextStyle(
    color: Color(GlobalColors.textColorWhite),
    fontSize: normalTextSize,
  );

  static const normalTextMitWhiteBold = TextStyle(
    color: Color(GlobalColors.miWhite),
    fontSize: normalTextSize,
    fontWeight: FontWeight.bold,
  );

  static const normalTextActionWhiteBold = TextStyle(
    color: Color(GlobalColors.actionBlue),
    fontSize: normalTextSize,
    fontWeight: FontWeight.bold,
  );

  static const normalTextLight = TextStyle(
    color: Color(GlobalColors.primaryLightValue),
    fontSize: normalTextSize,
  );

  static const largeText = TextStyle(
    color: Color(GlobalColors.mainTextColor),
    fontSize: bigTextSize,
  );

  static const largeTextBold = TextStyle(
    color: Color(GlobalColors.mainTextColor),
    fontSize: bigTextSize,
    fontWeight: FontWeight.bold,
  );

  static const largeTextWhite = TextStyle(
    color: Color(GlobalColors.textColorWhite),
    fontSize: bigTextSize,
  );

  static const largeTextWhiteBold = TextStyle(
    color: Color(GlobalColors.textColorWhite),
    fontSize: bigTextSize,
    fontWeight: FontWeight.bold,
  );

  static const largeLargeTextWhite = TextStyle(
    color: Color(GlobalColors.textColorWhite),
    fontSize: lagerTextSize,
    fontWeight: FontWeight.bold,
  );

  static const largeLargeText = TextStyle(
    color: Color(GlobalColors.primaryValue),
    fontSize: lagerTextSize,
    fontWeight: FontWeight.bold,
  );

}