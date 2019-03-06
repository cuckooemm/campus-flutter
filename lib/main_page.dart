import 'dart:convert';

import 'package:campus/common/config/config.dart';
import 'package:campus/common/dao/auth_dao.dart';
import 'package:campus/common/model/token.dart';
import 'package:campus/common/model/user.dart';
import 'package:campus/common/redux/app_state.dart';
import 'package:campus/common/redux/token_redux.dart';
import 'package:campus/common/redux/userinfo_redux.dart';
import 'package:campus/common/storage/local_storage.dart';
import 'package:campus/common/style/string_tip.dart';
import 'package:campus/common/utils/common_utils.dart';
import 'package:campus/common/utils/log_utils.dart';
import 'package:campus/common/utils/taost_utils.dart';
import 'package:campus/pages/campus/campus_page.dart';
import 'package:campus/pages/user/user_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  var navTitles = ['校园', '我'];
  final navTextStyleNormal = new TextStyle(color: const Color(0xff969696));
  final navTextStyleSelected = new TextStyle(color: const Color(0xff63ca6c));
  int _lastClickTime = 0;
  var _navImages;
  List<Widget> _body = new List();

  Future<bool> _appExit() {
    int nowTime = new DateTime.now().millisecondsSinceEpoch;
    if (_lastClickTime != 0 && nowTime - _lastClickTime < 1500) {
      return new Future.value(true);
    } else {
      ToastUtils.showShortInfoToast(StringTip.app_back_tip);
      _lastClickTime = new DateTime.now().millisecondsSinceEpoch;
      new Future.delayed(const Duration(milliseconds: 1500), () {
        _lastClickTime = 0;
      });
      return new Future.value(false);
    }
  }

  Image getTabImage(path) {
    return Image.asset(path, width: 20.0, height: 20.0);
  }

  @override
  void initState() {
    initData();
    initToken();
    super.initState();
  }

  void initToken() async {
    var tokenJson = await LocalStorage.getString(Config.TOKEN_KEY);
    if(tokenJson != null){
      Token token = Token.fromJson(json.decode(tokenJson));
      if(CommonUtils.getUnix() > token.expiresAt){
        if(CommonUtils.getUnix() < token.invalidAt){
          Token newToken = await AuthDao.refreshToken(token.token);
          if(newToken.ok){
            CommonUtils.getGlobalStore(context)?.dispatch(UpdateTokenAction(newToken));
            await LocalStorage.saveString(Config.TOKEN_KEY, json.encode(newToken));
            initUserInfo();
          }
        }
      }else{
        CommonUtils.getGlobalStore(context)?.dispatch(UpdateTokenAction(token));
        initUserInfo();
      }
    }
  }
  void initUserInfo() async{
    var userInfoJson = await LocalStorage.getString(Config.USER_INFO_KEY);
    if(userInfoJson != null){
      UserInfo userInfo = UserInfo.fromJson(json.decode(userInfoJson));
      CommonUtils.getGlobalStore(context)?.dispatch(UpdateUserInfoAction(userInfo));
    }
  }
  // 底部导航 数据初始化
  void initData() {
    if (_navImages == null) {
      _navImages = [
        [
          getTabImage('images/bottom_nav_campus.png'),
          getTabImage('images/bottom_nav_campus_focus.png')
        ],
        [
          getTabImage('images/bottom_nav_user.png'),
          getTabImage('images/bottom_nav_user_focus.png')
        ]
      ];
    }
    _body.add(CampusPage());
    _body.add(UserPage());
  }

  TextStyle getTabTextStyle(int curIndex) {
    if (curIndex == _selectedIndex) {
      return navTextStyleSelected;
    }
    return navTextStyleNormal;
  }

  Image getNavIcon(int curIndex) {
    if (curIndex == _selectedIndex) {
      return _navImages[curIndex][1];
    }
    return _navImages[curIndex][0];
  }

  Text getNavTitle(int curIndex) {
    return new Text(navTitles[curIndex], style: getTabTextStyle(curIndex));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _appExit,
      child: new Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: _body,
          ),
          bottomNavigationBar: new CupertinoTabBar(
            items: _bottomList(),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          )),
    );
  }

  List<BottomNavigationBarItem> _bottomList() {
    return [
      BottomNavigationBarItem(icon: getNavIcon(0), title: getNavTitle(0)),
      BottomNavigationBarItem(icon: getNavIcon(1), title: getNavTitle(1))
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
