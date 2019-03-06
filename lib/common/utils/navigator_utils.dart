import 'package:campus/common/model/comment.dart';
import 'package:campus/common/model/dynamic.dart';
import 'package:campus/pages/auth/login_page.dart';
import 'package:campus/pages/auth/register_page.dart';
import 'package:campus/pages/auth/retrieve_page.dart';
import 'package:campus/pages/auth/send_code_page.dart';
import 'package:campus/pages/campus/dynamic/comment_page.dart';
import 'package:campus/pages/campus/dynamic/publish_page.dart';
import 'package:campus/pages/campus/dynamic/reply_page.dart';
import 'package:campus/pages/common/feedback_page.dart';
import 'package:campus/pages/user/user_dynamic_page.dart';
import 'package:campus/pages/user/user_message_page.dart';
import 'package:campus/pages/user/user_profile_page.dart';
import 'package:campus/widget/photo_view_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorUtils {
  ///图片预览
  static gotoPhotoViewPage(BuildContext context, List<String> url,int index) {
    Navigator.push(context, new CupertinoPageRoute(builder: (context) => GalleryPhotoViewWrapper(url,index)));
  }

  static goLoginPage(BuildContext context){
    Navigator.push(context, CupertinoPageRoute(builder: (context) => LoginPage()));
  }
  static goSendCodePage(BuildContext context,int index){
    Navigator.push(context, CupertinoPageRoute(builder: (context) => SendCodePage(index)));
  }
  static goRegisterPage(BuildContext context,String account){
    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => RegisterPage(account)));
  }
  static goRetrievePage(BuildContext context,String account){
    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => RetrievePage(account)));
  }
  static goUserProfilePage(BuildContext context){
    Navigator.push(context, CupertinoPageRoute(builder: (context) => UserProfilePage()));
  }
  static goDynamicCommentPage(BuildContext context,DynamicData item){
    Navigator.push(context, CupertinoPageRoute(builder: (context) => CommentPage(item)));
  }
  static goReplyPage(BuildContext context,CommentData item){
    Navigator.push(context, CupertinoPageRoute(builder: (context) => ReplyPage(item)));
  }

  static goDynamicPublishPage(BuildContext context){
    Navigator.push(context, CupertinoPageRoute(builder: (context) => DynamicPublishPage()));
  }

  static goUserDynamicPage(BuildContext context){
    Navigator.push(context, CupertinoPageRoute(builder: (context) => UserDynamicPage()));
  }

  static goUserMessagePage(BuildContext context){
    Navigator.push(context, CupertinoPageRoute(builder: (context) => UserMessagePage()));
  }
  static goFeedbackPage(BuildContext context){
    Navigator.push(context, CupertinoPageRoute(builder: (context) => FeedbackPage()));
  }
}
