import 'package:campus/common/config/config.dart';
import 'package:campus/common/net/code.dart';
import 'package:campus/common/model/result_data.dart';
import 'package:campus/common/storage/local_storage.dart';
import 'package:campus/common/utils/log_utils.dart';
import 'package:dio/dio.dart';
import 'dart:collection';
import 'package:connectivity/connectivity.dart';

///http请求
class HttpManager {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  ///发起网络请求
  ///[ url] 请求url
  ///[ params] 请求参数
  ///[ header] 外加头
  static Future<ResultData> netFetch(String url,String method,{ String token,FormData params, Map<String, String> header,CancelToken cancelToken,noTip = false}) async {
    //没有网络
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return new ResultData(false, Code.NETWORK_ERROR,msg: Code.errorHandleFunction(Code.NETWORK_ERROR, "", noTip));
    }

    Map<String, String> headers = new HashMap();
    if (header != null) {
      headers.addAll(header);
    }
    if(token != null){
      headers["Authorization"] = token;
    }
    Options option = new Options(method: method,connectTimeout: 15000,headers: headers);
    
    Dio dio = new Dio();
    Response response;
    try {
      response = await dio.request(url, data: params, options: option,cancelToken: cancelToken);
    } on DioError catch (e) {
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = Code.NETWORK_TIMEOUT;
      }
      if (Config.DEBUG) {
        LogUtils.e('请求异常: ' + e.toString());
        LogUtils.e('请求异常url: ' + url);
      }
      return new ResultData(false, errorResponse.statusCode,msg: Code.errorHandleFunction(errorResponse.statusCode,"好像出了点问题", noTip));
    }

    if (Config.DEBUG) {
      LogUtils.v('请求url: ' + url);
      LogUtils.v('请求头: ' + option.headers.toString());
      if (params != null) {
        LogUtils.v('请求参数: ' + params.toString());
      }
      if (response != null) {
        LogUtils.v('返回参数: ' + response.toString());
      }
    }

    try {
      if (option.contentType != null && option.contentType.primaryType == "text") {
        return new ResultData(true, Code.SUCCESS,data: response.data);
      } else {
        // 返回为json
        /*  后期请求过期 返回Token 用
        var responseJson = response.data;
        if (response.statusCode == 201 && responseJson["token"] != null) {
          optionParams["authorizationCode"] = 'token ' + responseJson["token"];
          await LocalStorage.save(Config.TOKEN_KEY, optionParams["authorizationCode"]);
        }*/
      }
      if (response.statusCode == 200) {
        if(response.data["code"] == 200){
          return new ResultData(true, Code.SUCCESS, headers: response.headers,data: response.data,msg: response.data["msg"].toString());
        }
        return new ResultData(false,response.data["code"], headers: response.headers,data: response.data,msg: response.data["msg"].toString());
      }
    } catch (e) {
      LogUtils.e(e.toString() + url);
      return new ResultData(false, response.statusCode, headers: response.headers,data: response.data,msg: "");
    }
    return new ResultData(false, response.statusCode,msg: Code.errorHandleFunction(response.statusCode, "", noTip));
  }

}