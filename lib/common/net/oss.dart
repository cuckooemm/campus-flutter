import 'package:campus/common/config/config.dart';
import 'package:campus/common/net/code.dart';
import 'package:campus/common/model/result_data.dart';
import 'package:campus/common/utils/log_utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';

class Oss {
  static Future<ResultData> uploadImage(String host,FormData params) async {
    //没有网络
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return new ResultData(false, Code.NETWORK_ERROR,msg: Code.errorHandleFunction(Code.NETWORK_ERROR, "",false));
    }

    Options options = new Options(method: "POST",responseType: ResponseType.PLAIN,connectTimeout: 15000);

    Dio dio = new Dio();

    Response response;
    try {
      response = await dio.request(host, data: params,options: options);
      LogUtils.v(response.headers);
      LogUtils.v(response.data);
    } on DioError catch(e) {
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
        LogUtils.e('OSS请求异常: ' + e.toString());
        LogUtils.e('请求异常host: ' + host);
      }
      return new ResultData(false, errorResponse.statusCode,msg: Code.errorHandleFunction(errorResponse.statusCode,"好像出了点问题", false));
    }
    if(response.statusCode == 200){
      return new ResultData(true, response.statusCode,data: response.data);
    }else{
      return new ResultData(false, response.statusCode,data: response.data);
    }
  }
}