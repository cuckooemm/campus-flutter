import 'dart:io';

import 'package:campus/common/model/message.dart';
import 'package:campus/common/model/oss_sign.dart';
import 'package:campus/common/model/token.dart';
import 'package:campus/common/model/user.dart';
import 'package:campus/common/model/user_dynamic.dart';
import 'package:campus/common/model/user_message.dart';
import 'package:campus/common/net/address.dart';
import 'package:campus/common/net/api.dart';
import 'package:campus/common/net/oss.dart';
import 'package:campus/common/model/result_data.dart';
import 'package:campus/common/style/string_tip.dart';
import 'package:campus/common/utils/common_utils.dart';
import 'package:campus/common/utils/log_utils.dart';
import 'package:campus/common/utils/object_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class UserDao{
  static Future<Token> qqLogin(param,{CancelToken cancelToken}) async {
    var result =  await HttpManager.netFetch(Address.getQqLoginUrl(),"POST",params:param,cancelToken: cancelToken);
    if(result.ok){
      return Token.fromJson(result.data);
    }else{
      return Token(false,ok: false,msg: result.msg);
    }
  }

  static Future<Token> login(param,{CancelToken cancelToken}) async {
    var result =  await HttpManager.netFetch(Address.getLoginUrl(),"POST",params:param,cancelToken: cancelToken);
    if(result.ok){
      return Token.fromJson(result.data);
    }else{
      return Token(false,ok: false,msg: result.msg);
    }
  }

  static Future<UserInfo> getUserInfo(BuildContext context,{CancelToken cancelToken}) async {
    String token = CommonUtils.getToken(context);
    if(token == null){
      return UserInfo(ok: false,msg: StringTip.auth_invalid);
    }
    var result =  await HttpManager.netFetch(Address.getUserInfoUrl(),"GET",token: token,cancelToken: cancelToken);
    if(result.ok){
      return UserInfo.fromJson(result.data["data"]);
    }else{
      return UserInfo(ok: false,msg: result.msg);
    }
  }

  static Future<OssSign> getOssSign(BuildContext context,{CancelToken cancelToken}) async {
    String token = CommonUtils.getToken(context);
    if(token == null){
      return OssSign(ok: false,msg: StringTip.auth_invalid);
    }
    var result =  await HttpManager.netFetch(Address.getOssSignUrl(),"GET",token: token,cancelToken: cancelToken);
    if(result.ok){
      return OssSign.fromJson(result.data["data"]);
    }else{
      return OssSign(ok: false,msg: result.msg);
    }
  }
  static Future<Message> uploadImageToOss(String host,String key,String policy,String accessKeyId,String signature,File imageFile) async {
    FormData data = new FormData.from({
      'key' : key,
      'policy': policy,
      'OSSAccessKeyId': accessKeyId,
      'success_action_status' : '200', //让服务端返回200，不然，默认会返回204
      'signature': signature,
      'file': UploadFileInfo(imageFile, "imageFileName")
    });
    ResultData result = await Oss.uploadImage(host, data);
    if(result.ok){
      return new Message(ok: true,);
    }else{
      return new Message(ok: false,msg: "图片上传失败");
    }
  }

  static Future<Message> updateUserInfo(FormData param, BuildContext context,{CancelToken cancelToken}) async {
    String token = CommonUtils.getToken(context);
    if(token == null){
      return Message(ok: false,msg: StringTip.auth_invalid);
    }
    var result =  await HttpManager.netFetch(Address.getUserInfoUrl(),"PUT",token: token,params: param,cancelToken: cancelToken);
    if(result.ok){
      return Message.fromJson(result.data);
    }else{
      return Message(ok: false,msg: result.msg);
    }
  }

  static Future<UserDynamic> getUserDynamicList(BuildContext context,{String lastID,CancelToken cancelToken}) async {
    String token = CommonUtils.getToken(context);
    if(token == null){
      return UserDynamic(ok: false,msg: StringTip.auth_invalid);
    }
    FormData data;
    if(ObjectUtils.isNotEmptyString(lastID)){
      data = FormData.from({
        "id" : lastID
      });
    }
    var result =  await HttpManager.netFetch(Address.userDynamicV2,"GET",token: token,params: data,cancelToken: cancelToken);
    if(result.ok){
      return UserDynamic.fromJson(result.data);
    }else{
      return UserDynamic(ok: false,msg: result.msg);
    }
  }

  static Future<Message> deleteDynamic(BuildContext context,String id,{CancelToken cancelToken}) async {
    String token = CommonUtils.getToken(context);
    if(token == null){
      return Message(ok: false,msg: StringTip.auth_invalid);
    }
    var result =  await HttpManager.netFetch("${Address.userDynamicV1}?id=$id","DELETE",token: token,cancelToken: cancelToken);
    if(result.ok){
      return Message.fromJson(result.data);
    }else{
      return Message(ok: false,msg: result.msg);
    }
  }

  static Future<UserMessage> getUserMessageList(BuildContext context,{String lastID,CancelToken cancelToken}) async{
    String token = CommonUtils.getToken(context);
    FormData data;
    if(ObjectUtils.isNotEmptyString(lastID)){
      data = FormData.from({
        "id" : lastID
      });
    }
    var result = await HttpManager.netFetch(Address.userMessageV2, "GET",params: data,token: token,cancelToken: cancelToken);
    if(result.ok){
      return UserMessage.fromJson(result.data);
    }else{
      return UserMessage(ok: false,msg: result.msg);
    }
  }
}