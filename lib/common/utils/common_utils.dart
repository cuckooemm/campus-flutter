import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus/common/redux/app_state.dart';
import 'package:campus/common/redux/theme_redux.dart';
import 'package:campus/common/style/colors.dart';
import 'package:campus/common/style/constant.dart';
import 'package:campus/common/style/context_style.dart';
import 'package:campus/common/style/string_tip.dart';
import 'package:campus/common/utils/object_utils.dart';
import 'package:campus/widget/flex_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_statusbar/flutter_statusbar.dart';
import 'package:redux/redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uuid/uuid.dart';

class CommonUtils {
  static final double MILLIS_LIMIT = 1000.0;
  static final double SECONDS_LIMIT = 60 * MILLIS_LIMIT;
  static final double MINUTES_LIMIT = 60 * SECONDS_LIMIT;
  static final double HOURS_LIMIT = 24 * MINUTES_LIMIT;
  static final double DAYS_LIMIT = 30 * HOURS_LIMIT;
  static double sStaticBarHeight = 0.0;

  static void initStatusBarHeight(context) async {
    sStaticBarHeight =
        await FlutterStatusbar.height / MediaQuery.of(context).devicePixelRatio;
  }

  static String getDateStr(DateTime date) {
    if (date == null || date.toString() == null) {
      return "";
    } else if (date.toString().length < 10) {
      return date.toString();
    }
    return date.toString().substring(0, 10);
  }

  // UUID
  static String getUUIDString() {
    return new Uuid().v4().toString();
  }

  // 获取当前 秒级时间戳
  static int getUnix() {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  static String getToken(BuildContext context) {
    return getGlobalStore(context)?.state?.token?.token;
  }

  static Store<AppState> getGlobalStore(BuildContext context) {
    if (context == null) {
      return null;
    }
    return StoreProvider.of(context);
  }

  static Widget buildUserAvatarImage(String url, double imageSize) {
    if (ObjectUtils.isNotEmptyString(url)) {
      return CachedNetworkImage(
          key: Key(url),
          imageUrl: url,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.contain,
          errorWidget: Image.asset(Constant.default_avatar,
              width: imageSize, height: imageSize));
    } else {
      Image.asset(Constant.default_avatar, width: imageSize, height: imageSize);
    }
  }

  // 日期格式转换
  static String getNewsTimeStr(int date) {
    int subTime = DateTime.now().millisecondsSinceEpoch - date * 1000;
    if (subTime < MILLIS_LIMIT) {
      return "刚刚";
    } else if (subTime < SECONDS_LIMIT) {
      return (subTime / MILLIS_LIMIT).round().toString() + " 秒前";
    } else if (subTime < MINUTES_LIMIT) {
      return (subTime / SECONDS_LIMIT).round().toString() + " 分钟前";
    } else if (subTime < HOURS_LIMIT) {
      return (subTime / MINUTES_LIMIT).round().toString() + " 小时前";
    } else if (subTime < DAYS_LIMIT) {
      return (subTime / HOURS_LIMIT).round().toString() + " 天前";
    } else {
      return "";
    }
  }

  static splitFileNameByPath(String path) {
    return path.substring(path.lastIndexOf("/"));
  }

  static getFullName(String repositoryUrl) {
    if (repositoryUrl != null &&
        repositoryUrl.substring(repositoryUrl.length - 1) == "/") {
      repositoryUrl = repositoryUrl.substring(0, repositoryUrl.length - 1);
    }
    String fullName = '';
    if (repositoryUrl != null) {
      List<String> splicurl = repositoryUrl.split("/");
      if (splicurl.length > 2) {
        fullName =
            splicurl[splicurl.length - 2] + "/" + splicurl[splicurl.length - 1];
      }
    }
    return fullName;
  }

  static pushTheme(Store store, int index) {
    ThemeData themeData;
    List<Color> colors = getThemeListColor();
    themeData = new ThemeData(
        primarySwatch: colors[index], platform: TargetPlatform.iOS);
    store.dispatch(new RefreshThemeDataAction(themeData));
  }

  static List<Color> getThemeListColor() {
    return [
      GlobalColors.primarySwatch,
      Colors.brown,
      Colors.blue,
      Colors.teal,
      Colors.amber,
      Colors.blueGrey,
      Colors.deepOrange,
    ];
  }

  static const IMAGE_END = [".png", ".jpg", ".jpeg", ".gif", ".svg"];

  static isImageEnd(path) {
    bool image = false;
    for (String item in IMAGE_END) {
      if (path.indexOf(item) + item.length == path.length) {
        image = true;
      }
    }
    return image;
  }

  static Future<Null> showLoadingDialog(BuildContext context, String hint) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Material(
              color: Colors.transparent,
              child: WillPopScope(
                onWillPop: () => new Future.value(false),
                child: Center(
                  child: new Container(
                    width: 200.0,
                    height: 200.0,
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      //用一个BoxDecoration装饰器提供背景图片
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: SpinKitCubeGrid(
                                color: Color(GlobalColors.white))),
                        Container(height: 10.0),
                        Container(
                            child: Text(hint,
                                style: ContextStyle.normalTextWhite)),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  static Future<Null> showCompressDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Material(
              color: Colors.transparent,
              child: WillPopScope(
                onWillPop: () => new Future.value(false),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SpinKitRipple(color: Colors.green,),
                      Text("图片压缩中…")
                    ],
                  ),
                ),
              ));
        });
  }

  // 提示退出dialog
  static Future<bool> showExitDialog(BuildContext context, String hint) {
    return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              content: new Text(hint),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Text(StringTip.app_cancel)),
                new FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).pop(true);
                    },
                    child: new Text(StringTip.app_confirm))
              ],
            ));
  }

/*
  static Future<Null> showEditDialog(
      BuildContext context,
      String dialogTitle,
      ValueChanged<String> onTitleChanged,
      ValueChanged<String> onContentChanged,
      VoidCallback onPressed, {
        TextEditingController titleController,
        TextEditingController valueController,
        bool needTitle = true,
      }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: new IssueEditDialog(
              dialogTitle,
              onTitleChanged,
              onContentChanged,
              onPressed,
              titleController: titleController,
              valueController: valueController,
              needTitle: needTitle,
            ),
          );
        });
  }
*/
  static Future<Null> showCommitOptionDialog(
    BuildContext context,
    List<String> commitMaps,
    ValueChanged<int> onTap, {
    width = 250.0,
    height = 400.0,
    List<Color> colorList,
  }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: new Container(
              width: width,
              height: height,
              padding: new EdgeInsets.all(4.0),
              margin: new EdgeInsets.all(20.0),
              decoration: new BoxDecoration(
                color: Color(GlobalColors.white),
                //用一个BoxDecoration装饰器提供背景图片
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: new ListView.builder(
                  itemCount: commitMaps.length,
                  itemBuilder: (context, index) {
                    return FlexButton(
                      maxLines: 2,
                      mainAxisAlignment: MainAxisAlignment.start,
                      fontSize: 14.0,
                      color: colorList != null
                          ? colorList[index]
                          : Theme.of(context).primaryColor,
                      text: commitMaps[index],
                      textColor: Color(GlobalColors.white),
                      onPress: () {
                        Navigator.pop(context);
                        onTap(index);
                      },
                    );
                  }),
            ),
          );
        });
  }

  ///版本更新
  static Future<Null> showUpdateDialog(
      BuildContext context, String contentMsg) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("app 版本"),
            content: new Text(contentMsg),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text("取消")),
              new FlatButton(
                  onPressed: () {
                    // TODO 版本更新
//                    launch(Address.updateUrl);
                    Navigator.pop(context);
                  },
                  child: new Text("确认")),
            ],
          );
        });
  }

  static String genderToString(int gender) {
    switch (gender) {
      case 0:
        return "女";
        break;
      case 1:
        return "男";
        break;
      default:
        return "保密";
    }
  }
}
