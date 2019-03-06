import 'dart:convert';

import 'package:campus/common/config/config.dart';
import 'package:campus/common/dao/user_dao.dart';
import 'package:campus/common/event/login_event.dart';
import 'package:campus/common/redux/app_state.dart';
import 'package:campus/common/redux/userinfo_redux.dart';
import 'package:campus/common/storage/local_storage.dart';
import 'package:campus/common/style/context_style.dart';
import 'package:campus/common/style/string_tip.dart';
import 'package:campus/common/utils/common_utils.dart';
import 'package:campus/common/utils/event_utils.dart';
import 'package:campus/common/utils/navigator_utils.dart';
import 'package:campus/common/utils/taost_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class UserPage extends StatefulWidget {
  @override
  State<UserPage> createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  double iconSize = 26.0;
  CancelToken dioToken = new CancelToken();
  @override
  void initState() {
    super.initState();
    EventUtils.eventBus.on<LoginEvent>().listen((event) {
      if (event.login) {
        // 登录事件
        ToastUtils.showShortSuccessToast(
            CommonUtils.getGlobalStore(context)?.state?.token?.msg);
        Future.delayed(Duration(milliseconds: 500),(){
          getUserInfo();
        });
      } else {
        // 登出事件
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, store) {
        return RefreshIndicator(
          child: ListView(
            children: <Widget>[
              buildUserHeader(store),
              buildDynamicItem(store.token.isLogin),
              buildDivider(),
              buildMessageItem(store.token.isLogin),
              buildDivider(),
              buildFeedbackItem(),
              buildDivider(),
            ],
          ),
          onRefresh: _onRefresh,
        );
      },
    );
  }

  buildUserHeader(AppState store) {
    if (store.token.isLogin) {
      return Container(
        margin: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            Align(
              child: GestureDetector(
                  child: ClipOval(
                    child: CommonUtils.buildUserAvatarImage(
                        store.userInfo.avatar, 100.0),
                  ),
                  onTap: () {
                    NavigatorUtils.goUserProfilePage(context);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Align(
                child: Text(store.userInfo.nickname ?? "",
                    style: ContextStyle.mainNickname),
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: 150.0,
        margin: const EdgeInsets.only(top: 20.0),
        child: InkWell(
          onTap: (){
            NavigatorUtils.goLoginPage(context);
          },
          child: Center(
            child: Text("登录"),
          ),
        ),
      );
    }
  }

  buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Divider(
        height: 1.0,
      ),
    );
  }

  buildDynamicItem(bool login) {
    return InkWell(
      onTap: () {
        if (login) {
          NavigatorUtils.goUserDynamicPage(context);
        } else {
          ToastUtils.showShortWarnToast(StringTip.after_login);
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
        child: Row(
          children: <Widget>[
            Image.asset(
              'images/bottom_nav_campus_focus.png',
              width: iconSize,
              height: iconSize,
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text("我的动态", style: ContextStyle.userTitle)),
            ),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }

  buildMessageItem(bool login) {
    return InkWell(
      onTap: () {
        if (login) {
          NavigatorUtils.goUserMessagePage(context);
        } else {
          ToastUtils.showShortWarnToast(StringTip.after_login);
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
        child: Row(
          children: <Widget>[
            Image.asset(
              'images/message.png',
              width: iconSize,
              height: iconSize,
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text("我的消息", style: ContextStyle.userTitle)),
            ),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }

  buildFeedbackItem() {
    return InkWell(
      onTap: () {
        NavigatorUtils.goFeedbackPage(context);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
        child: Row(
          children: <Widget>[
            Image.asset(
              'images/feedback.png',
              width: iconSize,
              height: iconSize,
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text("反馈建议", style: ContextStyle.userTitle)),
            ),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }

  Future<Null> _onRefresh() async {
    await getUserInfo();
  }

  getUserInfo() async {
    var result = await UserDao.getUserInfo(context,cancelToken: dioToken);
    if (result.ok) {
      CommonUtils.getGlobalStore(context)
          ?.dispatch(UpdateUserInfoAction(result));
      await LocalStorage.saveString(Config.USER_INFO_KEY, json.encode(result));
    }
  }

  @override
  void dispose() {
    dioToken.cancel();
    super.dispose();
  }
}
