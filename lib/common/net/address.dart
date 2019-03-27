
///地址数据
class Address {
  static const String host = "https://www.xxx.xx/api/";
  /// 发送验证码 put
  static getCodeUrl(){
    return "${host}v1/auth/code";
  }
  static getRegisterUrl(){
    return "${host}v1/auth/register";
  }
  static getRetrieveUrl(){
    return "${host}v1/auth/retrieve";
  }
  /// QQ登录 post
  static getQqLoginUrl(){
    return "${host}v1/auth/login/qq";
  }
  /// 邮箱手机号登录 post
  static getLoginUrl(){
    return "${host}v1/auth/login";
  }
  /// 刷新token  post
  static getRefreshTokenUrl(){
    return "${host}v1/auth/refresh/token";
  }
  ///用户信息 get
  static getUserInfoUrl() {
    return "${host}v1/user/info";
  }
  /// OSS 后端签名
  static getOssSignUrl() {
    return "${host}v1/oss/sign";
  }

  /// 动态地址 get
  static getDynamicUrl(){
//    return "https://www.campuswall.cn/api/v1/dynamic";
    return "${host}v2/dynamic";
  }
  /// 动态点赞地址 put
  static putDynamicPraiseUrl(){
    return "${host}v1/dynamic/praise";
  }
  /// 动态评论地址 get
  static getDynamicCommentUrl(){
    return "${host}v2/dynamic/comment";
  }
  static const String dynamicReplyUrlV1 = "${host}v1/dynamic/reply";
  static const String dynamicReplyUrlV2 = "${host}v2/dynamic/reply";
  static const String getDynamicCommentPublishUrl = "${host}v1/dynamic/comment";
  static const String dynamicPublish = "${host}v1/dynamic/publish";
  static const String userDynamicV2 = "${host}v2/user/dynamic";
  static const String userDynamicV1 = "${host}v1/user/dynamic";
  static const String userMessageV2 = "${host}v2/user/message";
  static const String feedbackV1 = "${host}v1/feedback";

}
