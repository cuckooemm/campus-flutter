import 'package:campus/common/dao/auth_dao.dart';
import 'package:campus/common/style/colors.dart';
import 'package:campus/common/utils/common_utils.dart';
import 'package:campus/common/utils/navigator_utils.dart';
import 'package:campus/common/utils/taost_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SendCodePage extends StatefulWidget {
  /// flag 1为注册  2为找回
  final int flag;
  SendCodePage(this.flag);
  @override
  State<StatefulWidget> createState() => _SendCodePage();
}

class _SendCodePage extends State<SendCodePage> {
  final _formKey = GlobalKey<FormState>();
  String _account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: widget.flag == 1 ? Text("注册") : Text("找回"),
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
                buildSendCodeButton(context),
              ],
            )
        ),
      );
  }

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "发送验证码",
        style: TextStyle(fontSize: 26.0),
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
          width: 130.0,
          height: 2.0,
        ),
      ),
    );
  }

  TextFormField buildAccountTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '邮箱 or 手机号',
      ),
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
      keyboardType: TextInputType.text,
      onSaved: (String value) => _account = value.trim(),
    );
  }

  Align buildSendCodeButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '发送验证码',
            style: Theme
                .of(context)
                .accentTextTheme
                .headline,
          ),
          color: Color(GlobalColors.primaryValue),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              _sendCode();
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  void _sendCode() async {
    CommonUtils.showLoadingDialog(context,"发送验证码…");
    var param = FormData.from({
      "account": _account,
      "operation": widget.flag,
    });
    var result = await AuthDao.sendCode(param);
    // 关闭加载动画
    Navigator.pop(context);
    if (result.ok) {
      // 成功 跳转到指定页面
      ToastUtils.showShortSuccessToast(result.msg);
      switch (widget.flag) {
        case 1 :
          NavigatorUtils.goRegisterPage(context, _account);
          break;
        case 2 :
          NavigatorUtils.goRetrievePage(context, _account);
          break;
      }

    } else {
      ToastUtils.showShortWarnToast(result.msg);
    }
  }

}