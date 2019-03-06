import 'dart:convert';

import 'package:campus/common/config/config.dart';
import 'package:campus/common/dao/user_dao.dart';
import 'package:campus/common/event/login_event.dart';
import 'package:campus/common/model/token.dart';
import 'package:campus/common/redux/app_state.dart';
import 'package:campus/common/redux/token_redux.dart';
import 'package:campus/common/storage/local_storage.dart';
import 'package:campus/common/style/colors.dart';
import 'package:campus/common/style/global_icons.dart';
import 'package:campus/common/style/string_tip.dart';
import 'package:campus/common/utils/common_utils.dart';
import 'package:campus/common/utils/event_utils.dart';
import 'package:campus/common/utils/log_utils.dart';
import 'package:campus/common/utils/navigator_utils.dart';
import 'package:campus/common/utils/taost_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qq/flutter_qq.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _account, _password;
  bool _isObscure = true;
  Color _eyeColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(StringTip.sign_in),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            children: <Widget>[
              const SizedBox(height: kToolbarHeight),
              buildTitle(),
              buildTitleLine(),
              const SizedBox(height: 20.0),
              buildAccountTextField(),
              const SizedBox(height: 20.0),
              buildPasswordTextField(context),
              buildForgetPasswordText(context),
              const SizedBox(height: 20.0),
              buildLoginButton(context),
              const SizedBox(height: 20.0),
              buildOtherLoginText(),
              buildOtherMethod(context),
              buildRegisterText(context),
            ],
          ),
        ),
      );
  }
  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        StringTip.sign_in,
        style: TextStyle(fontSize: 42.0),
      ),
    );
  }
  Padding buildTitleLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 40.0,
          height: 2.0,
        ),
      ),
    );
  }

  TextFormField buildAccountTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: StringTip.account,
      ),
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (value.contains("@")) {
          var emailReg = RegExp(
              r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
          if (!emailReg.hasMatch(value)) {
            return '请输入正确的邮箱地址';
          }
        } else if (value.length == 11) {
          var phoneReg = RegExp(
              r"(0|86|17951)?(13[0-9]|15[0-35-9]|17[0678]|18[0-9]|14[57])[0-9]{8}");
          if (!phoneReg.hasMatch(value)) {
            return '请输入正确的手机号码';
          }
        } else {
          return '请输入正确的手机号';
        }
      },
      onSaved: (String value) => _account = value.trim(),
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _password = value.trim(),
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
        if (value.length < 8) {
          return '密码输入错误';
        }
      },
      decoration: InputDecoration(
          labelText: StringTip.password,
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color;
                });
              })),
    );
  }

  Padding buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: FlatButton(
          child: Text(
            '忘记密码？',
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          onPressed: () {
            NavigatorUtils.goSendCodePage(context,2);
          },
        ),
      ),
    );
  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            StringTip.sign_in,
            style: Theme.of(context).accentTextTheme.headline,
          ),
          color: Color(GlobalColors.primaryValue),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              _login();
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  Align buildOtherLoginText() {
    return Align(
        alignment: Alignment.center,
        child: Text(
          '其他账号登录',
          style: TextStyle(color: Colors.grey, fontSize: 14.0),
        ));
  }

  ButtonBar buildOtherMethod(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
            icon: Icon(GlobalIcons.OAUTH_QQ,
                color: Theme.of(context).iconTheme.color),
            onPressed: _qqLogin)
      ],
    );
  }

  Align buildRegisterText(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('没有账号？'),
            GestureDetector(
              child: Text(
                '点击注册',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                NavigatorUtils.goSendCodePage(context,1);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _qqLogin() {
    FlutterQq.registerQQ('1106710088');
    _handleLogin();
  }
  void _login() async{
    var param = new FormData.from({
      "account": _account,
      "password" : _password,
    });
    // 显示加载动画
    CommonUtils.showLoadingDialog(context,"登录中…");
    var result = await UserDao.login(param);
    _loginAfter(result);
  }
  Future<Null> _handleLogin() async {
    try {
      var qqResult = await FlutterQq.login();
      if (qqResult.code == 0) {
        LogUtils.v(qqResult.response.toString());
        // 显示加载动画
        CommonUtils.showLoadingDialog(context,"登录中…");
        _sendQQLogin(qqResult.response);
      } else if (qqResult.code == 1) {
        ToastUtils.showShortWarnToast("登录失败" + qqResult.message);
      } else {
        ToastUtils.showShortInfoToast("您已取消授权");
      }
    } catch (error) {
      LogUtils.e(error);
    }
  }
  _sendQQLogin(params) async{
    var param = new FormData.from({
      "openid": params["openid"],
      "token" : params["accessToken"],
    });
    var result = await UserDao.qqLogin(param);
    _loginAfter(result);
  }
  /// 获取到登陆响应的操作
  void _loginAfter(Token result) async{
    if(result.ok){
      // 成功 保存Token
      await LocalStorage.saveString(Config.TOKEN_KEY, json.encode(result));
      // 更新store
      CommonUtils.getGlobalStore(context)?.dispatch(UpdateTokenAction(Token(true,token: result.token,msg: result.msg)));
      EventUtils.eventBus.fire(LoginEvent(true));
      closeLoadingDialog();
      Navigator.of(context).maybePop();
    }else{
      closeLoadingDialog();
      ToastUtils.showShortErrorToast(result.msg);
    }
  }

  void closeLoadingDialog(){
    // 关闭加载动画
    Navigator.pop(context);
  }
}
