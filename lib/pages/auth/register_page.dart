import 'package:campus/common/dao/auth_dao.dart';
import 'package:campus/common/style/colors.dart';
import 'package:campus/common/style/string_tip.dart';
import 'package:campus/common/utils/common_utils.dart';
import 'package:campus/common/utils/taost_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget{
  final String _account;
  RegisterPage(this._account);
  @override
  State<StatefulWidget> createState() => _RegisterPage();
}
class _RegisterPage extends State<RegisterPage>{
  final _formKey = GlobalKey<FormState>();
  String _nickname,_code, _password,_confirmPassword;
  bool _isObscure = true;
  Color _eyeColor;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return CommonUtils.showExitDialog(context,StringTip.register_exit_tip);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(StringTip.sign_up),
            centerTitle: true,
          ),
          body: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 22.0),
                children: <Widget>[
                  const SizedBox(height: kToolbarHeight),
                  buildTitle(),
                  buildTitleLine(),
                  const SizedBox(height: 20.0),
                  buildNameTextField(),
                  buildCodeTextField(),
                  buildPasswordTextField(context),
                  buildConfirmPasswordTextField(context),
                  const SizedBox(height: 20.0),
                  buildRegisterButton(context),
                ],
              )
          ),
        ),
    );
  }
  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        widget._account,
        style: TextStyle(fontSize: 28.0),
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
          width: 100.0,
          height: 2.0,
        ),
      ),
    );
  }
  TextFormField buildNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: StringTip.nickname,
      ),
      maxLength: 12,
      keyboardType: TextInputType.text,
      validator: (String value) {
        if(value.length < 2){
          return '昵称太短了哦';
        }
        if(value.length > 12){
          return '昵称太长了哦';
        }
      },
      onSaved: (String value) => _nickname = value,
    );
  }
  TextFormField buildCodeTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: StringTip.verification_code,
      ),
      keyboardType: TextInputType.number,
      maxLength: 6,
      validator: (String value) {
        if(value.length != 6){
          return StringTip.verification_code_error;
        }
      },
      onSaved: (String value) => _code = value,
    );
  }
  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _password = value,
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
  TextFormField buildConfirmPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _confirmPassword = value.trim(),
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty && value.length < 8) {
          return '密码输入不一致';
        }
      },
      decoration: InputDecoration(
          labelText: StringTip.confirm_password,
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
  Align buildRegisterButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            StringTip.sign_up,
            style: Theme.of(context).accentTextTheme.headline,
          ),
          color: Color(GlobalColors.primaryValue),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              if(_confirmPassword != _password){
                ToastUtils.showShortWarnToast("密码输入不一致");
              }else{
                _register();
              }

            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  void _register() async{
    CommonUtils.showLoadingDialog(context,"注册中…");
    // TODO nickname 去除空格
    var param = FormData.from({
      "account": widget._account,
      "nickname": _nickname.trim(),
      "code" : _code,
      "password": _password
    });
    var result = await AuthDao.register(param);
    // 关闭加载动画
    Navigator.pop(context);
    if(result.ok){
      Navigator.pop(context);
      ToastUtils.showShortSuccessToast(result.msg);
    }else{
      ToastUtils.showShortErrorToast(result.msg);
    }
  }
}