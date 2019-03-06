import 'package:campus/common/model/message.dart';
import 'package:campus/common/net/address.dart';
import 'package:campus/common/net/api.dart';
import 'package:dio/dio.dart';

class CommonDao{
  static Future<Message> sendFeedback(String content,{CancelToken cancelToken}) async {
    FormData data = FormData.from({
      "content":content
    });
    var result =  await HttpManager.netFetch(Address.feedbackV1,"POST",params:data,cancelToken: cancelToken);
    if(result.ok){
      return Message.fromJson(result.data);
    }else{
      return Message(ok: false,msg: result.msg);
    }
  }
}