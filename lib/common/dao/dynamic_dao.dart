import 'package:campus/common/model/comment.dart';
import 'package:campus/common/model/dynamic.dart';
import 'package:campus/common/model/message.dart';
import 'package:campus/common/model/reply.dart';
import 'package:campus/common/net/address.dart';
import 'package:campus/common/net/api.dart';
import 'package:campus/common/style/string_tip.dart';
import 'package:campus/common/utils/common_utils.dart';
import 'package:campus/common/utils/object_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DynamicDao{

  static Future<Message> publishDynamic(BuildContext context,FormData param,{CancelToken cancelToken}) async {
    String token = CommonUtils.getToken(context);
    if(token == null){
      return Message(ok: false,msg: StringTip.auth_invalid);
    }
    var result =  await HttpManager.netFetch(Address.dynamicPublish,"POST",params: param,token: token,cancelToken: cancelToken);
    if(result.ok){
      return Message.fromJson(result.data);
    }else{
      return Message(ok: false,msg: result.msg);
    }
  }

  static Future<Dynamic> getDynamicList({String id,CancelToken cancelToken}) async {
    FormData data;
    if(ObjectUtils.isNotEmptyString(id)){
      data = FormData.from({
        "id" : id
      });
    }
    var result =  await HttpManager.netFetch(Address.getDynamicUrl(),"GET",params: data,cancelToken: cancelToken);
    if(result.ok){
      return Dynamic.fromJson(result.data);
    }else{
      return Dynamic(ok: false,msg: result.msg);
    }
  }

  static Future<Message> sendDynamicPraise(BuildContext context,String id,{CancelToken cancelToken}) async {
    String token = CommonUtils.getToken(context);
    if(token == null){
      return Message(ok: false,msg: StringTip.auth_invalid);
    }
    FormData data = FormData.from({
        "id" : id
      });
    var result =  await HttpManager.netFetch(Address.putDynamicPraiseUrl(),"PUT",params: data,token: token,cancelToken: cancelToken);
    if(result.ok){
      return Message.fromJson(result.data);
    }else{
      return Message(ok: false,msg: result.msg);
    }
  }

  static Future<Comment> getDynamicCommentList(String id,{String lastID,CancelToken cancelToken}) async{
    FormData data = FormData.from({
      "id" : id
    });
    if(ObjectUtils.isNotEmptyString(lastID)){
      data.add("comment_id", lastID);
    }
    var result = await HttpManager.netFetch(Address.getDynamicCommentUrl(), "GET",params: data,cancelToken: cancelToken);
    if(result.ok){
      return Comment.fromJson(result.data);
    }else{
      return Comment(ok: false,msg: result.msg);
    }
  }

  static Future<Reply> getDynamicReplyList(String id,{String lastID,CancelToken cancelToken}) async{
    FormData data = FormData.from({
      "id" : id
    });
    if(ObjectUtils.isNotEmptyString(lastID)){
      data.add("reply_id", lastID);
    }
    var result = await HttpManager.netFetch(Address.dynamicReplyUrlV2, "GET",params: data,cancelToken: cancelToken);
    if(result.ok){
      return Reply.fromJson(result.data);
    }else{
      return Reply(ok: false,msg: result.msg);
    }
  }

  static Future<Message> sendDynamicComment(BuildContext context,String content,String id,{CancelToken cancelToken}) async {
    String token = CommonUtils.getToken(context);
    if(token == null){
      return Message(ok: false,msg: StringTip.auth_invalid);
    }
    FormData data = FormData.from({
      "dynamic_id":id,
      "content":content
    });
    var result =  await HttpManager.netFetch(Address.getDynamicCommentPublishUrl,"POST",params: data,token: token,cancelToken: cancelToken);
    if(result.ok){
      return Message.fromJson(result.data);
    }else{
      return Message(ok: false,msg: result.msg);
    }
  }

  static Future<Message> sendDynamicCommentReply(BuildContext context,String content,String id,{CancelToken cancelToken}) async {
    String token = CommonUtils.getToken(context);
    if(token == null){
      return Message(ok: false,msg: StringTip.auth_invalid);
    }
    FormData data = FormData.from({
      "comment_id":id,
      "content":content
    });
    var result =  await HttpManager.netFetch(Address.dynamicReplyUrlV1,"POST",params: data,token: token,cancelToken: cancelToken);
    if(result.ok){
      return Message.fromJson(result.data);
    }else{
      return Message(ok: false,msg: result.msg);
    }
  }
}