import 'package:campus/common/model/message.dart';
import 'package:campus/common/model/token.dart';
import 'package:campus/common/net/address.dart';
import 'package:campus/common/net/api.dart';
import 'package:dio/dio.dart';

class AuthDao{
  static Future<Message> sendCode(param,{CancelToken cancelToken}) async {
    var result =  await HttpManager.netFetch(Address.getCodeUrl(),"PUT",params:param,cancelToken: cancelToken);
    if(result.ok){
      return Message.fromJson(result.data);
    }else{
      return Message(ok: false,msg: result.msg);
    }
  }
  
  static Future<Message> register(param,{CancelToken cancelToken}) async {
    var result = await HttpManager.netFetch(Address.getRegisterUrl(), "POST",params: param,cancelToken: cancelToken);
    if(result.ok){
      return Message.fromJson(result.data);
    }else{
      return Message(ok: false,msg: result.msg);
    }
  }

  static Future<Message> retrieve(param,{CancelToken cancelToken}) async {
    var result = await HttpManager.netFetch(Address.getRetrieveUrl(), "POST",params: param,cancelToken: cancelToken);
    if(result.ok){
      return Message.fromJson(result.data);
    }else{
      return Message(ok: false,msg: result.msg);
    }
  }

  static Future<Token> refreshToken(String token,{CancelToken cancelToken}) async {
    var result = await HttpManager.netFetch(Address.getRefreshTokenUrl(), "GET",token: token,cancelToken: cancelToken);
    if(result.ok){
      return Token.fromJson(result.data);
    }else{
      return Token(false,ok: false,msg: result.msg);
    }
  }
}