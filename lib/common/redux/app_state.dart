import 'package:campus/common/model/dynamic.dart';
import 'package:campus/common/model/user.dart';
import 'package:campus/common/model/token.dart';
import 'package:campus/common/redux/userinfo_redux.dart';
import 'package:campus/common/redux/token_redux.dart';
import 'package:campus/common/redux/dynamic_data_redux.dart';
import 'package:flutter/material.dart';
import 'package:campus/common/redux/theme_redux.dart';

class AppState {
  // 主题数据
  ThemeData themeData;
  // 用户数据
  UserInfo userInfo;
  Token token;
  List<DynamicData> dynamicList;
  AppState({this.themeData, this.userInfo,this.token,this.dynamicList});
}

AppState appReducer(AppState state, action) {
  return AppState(
      themeData: themeDataReducer(state.themeData, action),
      userInfo: userInfoReducer(state.userInfo, action),
      token: tokenReducer(state.token, action),
      dynamicList: dynamicDataReducer(state.dynamicList,action)
  );
}
