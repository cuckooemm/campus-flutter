import 'package:campus/common/config/config.dart';

class LogUtils {
  static const bool debuggable = Config.LOG_DEBUG; //是否是debug模式,true: log v 不输出.
  static const String TAG = "###campus_log###";

  static void e(Object object, {String tag}) {
    _printLog(tag, '  e  ', object);
  }

  static void v(Object object, {String tag}) {
    if (debuggable) {
      _printLog(tag, '  v  ', object);
    }
  }

  static void _printLog(String tag, String stag, Object object) {
    StringBuffer sb = new StringBuffer();
    sb.write((tag == null || tag.isEmpty) ? TAG : tag);
    sb.write(stag);
    sb.write(object);
    print(sb.toString());
  }
}