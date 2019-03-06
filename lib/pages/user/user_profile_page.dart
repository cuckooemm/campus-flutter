import 'dart:convert';
import 'dart:io';
import 'package:campus/common/config/config.dart';
import 'package:campus/common/event/login_event.dart';
import 'package:campus/common/model/token.dart';
import 'package:campus/common/model/user.dart';
import 'package:campus/common/redux/token_redux.dart';
import 'package:campus/common/storage/local_storage.dart';
import 'package:campus/common/style/constant.dart';
import 'package:campus/common/utils/event_utils.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus/common/dao/user_dao.dart';
import 'package:campus/common/model/message.dart';
import 'package:campus/common/model/oss_sign.dart';
import 'package:campus/common/redux/app_state.dart';
import 'package:campus/common/style/context_style.dart';
import 'package:campus/common/style/string_tip.dart';
import 'package:campus/common/utils/common_utils.dart';
import 'package:campus/common/utils/log_utils.dart';
import 'package:campus/common/utils/taost_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:redux/redux.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class UserProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserProfilePage();
}
enum ProfileKey { avatar, gender, nickname, birthday, bio }

class _UserProfilePage extends State<UserProfilePage> {
  bool isUpdateName = true;
  bool isUpdateBio = true;
  String _newNickname;
  String _newBio;
  final _formKeyName = GlobalKey<FormState>();
  final _formKeyBio = GlobalKey<FormState>();
  List<String> genderList = List.unmodifiable(["女", "男", "保密"]);
  CancelToken dioToken = new CancelToken();

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _cropImage(image);
    }
  }

  Future<Null> _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        ratioX: 1.0,
        ratioY: 1.0,
        maxWidth: 200,
        maxHeight: 200,
        circleShape: true);
    if (croppedFile != null) {
      uploadAvatar(croppedFile);
    }
  }

  uploadAvatar(File address) async {
    CommonUtils.showLoadingDialog(context, StringTip.update_user_avatar);
    OssSign ossSign = await UserDao.getOssSign(context);
    LogUtils.v(ossSign.toJson());
    if (ossSign.ok) {
      String key = "avatar/" + CommonUtils.getUUIDString();
      Message result = await UserDao.uploadImageToOss(ossSign.host, key,
          ossSign.policy, ossSign.accessid, ossSign.signature, address);
      if (result.ok) {
        FormData data = new FormData.from({"avatar": key});
        updateUserProfile(data, ProfileKey.avatar);
      } else {
        closeLoading();
        ToastUtils.showShortErrorToast(result.msg);
      }
    } else {
      closeLoading();
      ToastUtils.showShortErrorToast(ossSign.msg);
    }
  }

  updateUserProfile(FormData param, ProfileKey key) async {
    Message message =
        await UserDao.updateUserInfo(param,context,cancelToken: dioToken);
    if (message.ok) {
      closeLoading();
      switch (key) {
        case ProfileKey.avatar:
          if (message.data != null) {
            setState(() {
              CommonUtils.getGlobalStore(context)?.state?.userInfo?.avatar = message.data;
            });
          }
          break;
        case ProfileKey.nickname:
          setState(() {
            CommonUtils.getGlobalStore(context)?.state?.userInfo?.nickname = param["nickname"];
          });
          break;
        case ProfileKey.gender:
          setState(() {
            CommonUtils.getGlobalStore(context)?.state?.userInfo?.gender = param["gender"];
          });
          break;
        case ProfileKey.birthday:
          setState(() {
            CommonUtils.getGlobalStore(context)?.state?.userInfo?.birthday = param["birthday"];
          });
          break;
        case ProfileKey.bio:
          setState(() {
            CommonUtils.getGlobalStore(context)?.state?.userInfo?.bio = param["bio"];
          });
          break;
        default:
          break;
      }
      ToastUtils.showShortSuccessToast(message.msg);
    } else {
      closeLoading();
      ToastUtils.showShortErrorToast(message.msg);
    }
  }

  // 关闭动画
  closeLoading() {
    Navigator.pop(context);
  }

  @override
  void deactivate() {
    UserInfo user = CommonUtils.getGlobalStore(context)?.state?.userInfo;
    LocalStorage.saveString(Config.USER_INFO_KEY, json.encode(user));
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserInfo>(
        converter: (store) => store.state.userInfo,
        builder: (context, store) {
          return Scaffold(
              appBar: AppBar(
                title: Text("用户信息"),
                centerTitle: true,
              ),
              body: ListView(
                children: <Widget>[
                  buildUserAvatar(store.avatar),
                  buildTitleLine(),
                  buildUserNickname(store.nickname),
                  buildNameTextField(store.nickname),
                  buildTitleLine(),
                  buildUserGender(store.gender),
                  buildTitleLine(),
                  buildUserBirthday(store.birthday),
                  buildTitleLine(),
                  buildUserBio(store.bio),
                  buildBioTextField(store.bio),
                  buildTitleLine(),
                  buildLogout(),
                ],
              ),
            );
        });
  }

  Padding buildTitleLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 2.0, right: 20.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.blue,
          width: double.infinity,
          height: 0.5,
        ),
      ),
    );
  }

  Padding buildUserAvatar(String url) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("头像", style: ContextStyle.userInfoTitle),
          GestureDetector(
            child: ClipOval(
              child: CommonUtils.buildUserAvatarImage(url,40.0),
            ),
            onTap: () {
              getImage();
            },
          )
        ],
      ),
    );
  }

  Padding buildUserNickname(String nickname) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("昵称", style: ContextStyle.userInfoTitle),
          GestureDetector(
            child: Text(nickname ?? ""),
            onTap: () {
              setState(() {
                isUpdateName = !isUpdateName;
                _newNickname = nickname;
              });
            },
          )
        ],
      ),
    );
  }

  Offstage buildNameTextField(String nickname) {
    return Offstage(
      offstage: isUpdateName,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
        child: Form(
            key: _formKeyName,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: TextFormField(
                      initialValue: nickname,
                      decoration: InputDecoration(
                        labelText: StringTip.nickname,
                      ),
                      maxLength: 12,
                      keyboardType: TextInputType.text,
                      validator: (String value) {
                        if (value.length < 2) {
                          return '昵称太短了哦';
                        }
                        if (value.length > 12) {
                          return '昵称太长了哦';
                        }
                      },
                      onSaved: (String value) => _newNickname = value,
                    ),
                  ),
                  flex: 8,
                ),
                Expanded(
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      color: Colors.blue,
                      onPressed: () {
                        if (_formKeyName.currentState.validate()) {
                          _formKeyName.currentState.save();
                          if (CommonUtils.getGlobalStore(context)?.state?.userInfo?.nickname !=
                              _newNickname.trim()) {
                            FormData data = FormData.from({
                              "nickname": _newNickname.trim(),
                            });
                            CommonUtils.showLoadingDialog(
                                context, StringTip.update_user_nickname);
                            updateUserProfile(data, ProfileKey.nickname);
                          }
                          setState(() {
                            isUpdateName = !isUpdateName;
                          });
                        }
                      },
                      child: Text("修改")),
                  flex: 3,
                ),
              ],
            )),
      ),
    );
  }

  Padding buildUserGender(int gender) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("性别", style: ContextStyle.userInfoTitle),
          GestureDetector(
            child: Text(CommonUtils.genderToString(gender)),
            onTap: () {
              Picker(
                  adapter: PickerDataAdapter<String>(pickerdata: genderList),
                  hideHeader: true,
                  cancelText: "取消",
                  confirmText: "确认",
                  onConfirm: (Picker picker, List value) {
                    if (value.length > 0) {
                      if (gender != value[0]) {
                        FormData data = FormData.from({"gender": value[0]});
                        CommonUtils.showLoadingDialog(
                            context, StringTip.update_user_gender);
                        updateUserProfile(data, ProfileKey.gender);
                      }
                    }
                  }).showDialog(context);
            },
          )
        ],
      ),
    );
  }

  Padding buildUserBirthday(String birthday) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("生日", style: ContextStyle.userInfoTitle),
          GestureDetector(
            child: Text(birthday ?? ""),
            onTap: () {
              var birthday = CommonUtils.getGlobalStore(context)?.state?.userInfo?.birthday;
              DateTime bir;
              if (birthday != null) {
                bir = DateTime.tryParse(birthday);
              }
              DatePicker.showDatePicker(context, showTitleActions: true,
                  onConfirm: (date) {
                String newDate = date.toString().substring(0, 10);
                FormData data = new FormData.from({"birthday": newDate});
                if (birthday != newDate) {
                  CommonUtils.showLoadingDialog(
                      context, StringTip.update_user_birthday);
                  updateUserProfile(data, ProfileKey.birthday);
                }
              }, currentTime: bir ?? null, locale: LocaleType.zh);
            },
          )
        ],
      ),
    );
  }

  Padding buildUserBio(String bio) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(StringTip.user_bio, style: ContextStyle.userInfoTitle),
          Container(
            width: 220.0,
            padding: const EdgeInsets.only(left: 10.0),
            child: GestureDetector(
              child:
                  Text(bio ?? "", overflow: TextOverflow.fade, softWrap: false),
              onTap: () {
                setState(() {
                  isUpdateBio = !isUpdateBio;
                  _newBio = bio;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Offstage buildBioTextField(String bio) {
    return Offstage(
      offstage: isUpdateBio,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
        child: Form(
            key: _formKeyBio,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: TextFormField(
                      initialValue: bio,
                      decoration: InputDecoration(
                        labelText: StringTip.user_bio,
                      ),
                      maxLength: 120,
                      maxLines: 3,
                      keyboardType: TextInputType.text,
                      validator: (String value) {},
                      onSaved: (String value) => _newBio = value,
                    ),
                  ),
                  flex: 8,
                ),
                Expanded(
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      color: Colors.blue,
                      onPressed: () {
                        if (_formKeyBio.currentState.validate()) {
                          _formKeyBio.currentState.save();
                          if (CommonUtils.getGlobalStore(context)?.state?.userInfo?.bio != _newBio) {
                            FormData data = FormData.from({
                              "bio": _newBio,
                            });
                            CommonUtils.showLoadingDialog(
                                context, StringTip.update_user_bio);
                            updateUserProfile(data, ProfileKey.bio);
                          }
                          setState(() {
                            isUpdateBio = !isUpdateBio;
                          });
                        }
                      },
                      child: Text("修改")),
                  flex: 3,
                ),
              ],
            )),
      ),
    );
  }
  buildLogout(){
    return Align(
      child: Container(
        margin: const EdgeInsets.only(top: 30.0),
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            StringTip.logout,
            style: Theme.of(context).accentTextTheme.headline,
          ),
          color: Colors.red,
          onPressed: () {
            return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(StringTip.logout,
                        style: ContextStyle.userTitle),
                    content: Text("你要离开了吗?"),
                    actions: <Widget>[
                      FlatButton(child: Text("取消"),onPressed: (){
                        Navigator.pop(context);
                      }),
                      FlatButton(child: Text("退出"),onPressed: (){
                        Navigator.pop(context);
                        CommonUtils.getGlobalStore(context).dispatch(UpdateTokenAction(Token(false)));
                        EventUtils.eventBus.fire(LoginEvent(false));
                        LocalStorage.clear();
                        Navigator.of(context).maybePop();
                      }),

                    ],
                  );
                });
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }
  @override
  void dispose() {
    dioToken.cancel();
    super.dispose();
  }
}
