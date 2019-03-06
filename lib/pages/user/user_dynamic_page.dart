import 'package:campus/common/dao/user_dao.dart';
import 'package:campus/common/model/message.dart';
import 'package:campus/common/model/user.dart';
import 'package:campus/common/model/user_dynamic.dart';
import 'package:campus/common/redux/app_state.dart';
import 'package:campus/common/style/context_style.dart';
import 'package:campus/common/style/string_tip.dart';
import 'package:campus/common/utils/common_utils.dart';
import 'package:campus/common/utils/taost_utils.dart';
import 'package:campus/widget/item/user_dynamic_item_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_redux/flutter_redux.dart';

class UserDynamicPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserDynamicState();
}

class _UserDynamicState extends State<UserDynamicPage> {
  List<UserDynamicData> list = <UserDynamicData>[];

  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();
  bool _isLoadMore = false;

  CancelToken dioToken = new CancelToken();
  bool refreshFlag = true;
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500),(){
      if(refreshFlag){
        getUserDynamicList();
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserInfo>(
        converter: (store) => store.state.userInfo,
        builder: (context, store) {
          return Scaffold(
            appBar: AppBar(
              title: Text("我的动态"),
              centerTitle: true,
            ),
            body: EasyRefresh(
              key: _easyRefreshKey,
              onRefresh: (){
                getUserDynamicList();
              },
              loadMore: () {
                if (_isLoadMore) {
                  getMoreUserDynamicList(list.last.id);
                }else{
                  ToastUtils.showShortInfoToast(StringTip.load_more_none);
                }
              },
              refreshHeader: ClassicsHeader(
                key: _headerKey,
                refreshText: "刷新动态",
                refreshReadyText: "释放刷新",
                refreshingText: "获取动态...",
                refreshedText: "刷新完成",
                moreInfo:
                    "上次于 ${DateTime.now().toString().substring(11, 16)} 更新",
                bgColor: Colors.transparent,
                textColor: Colors.black87,
                moreInfoColor: Colors.black54,
                showMore: true,
              ),
              refreshFooter: ClassicsFooter(
                key: _footerKey,
                loadText: "加载更多",
                loadReadyText: "释放获取数据",
                loadingText: "加载更多动态...",
                noMoreText: "加载完成",
                bgColor: Colors.transparent,
                textColor: Colors.black87,
                moreInfoColor: Colors.black54,
              ),
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, position) {
                    return UserDynamicItemWidget(
                      list[position],
                      store.nickname,
                      store.avatar,
                      rightButtonCallback: (UserDynamicClick value) {
                        switch (value) {
                          case UserDynamicClick.delete:
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("删除动态",
                                        style: ContextStyle.userTitle),
                                    content: Text(
                                        "确定删除 ${list[position].content.length > 10 ? list[position].content.substring(0, 9)+"..."  : list[position].content} 这条动态吗?"),
                                    actions: <Widget>[
                                      FlatButton(child: Text("取消"),onPressed: (){
                                        Navigator.pop(context);
                                      }),
                                      FlatButton(child: Text("删除"),onPressed: (){
                                        Navigator.pop(context);
                                        deleteDynamic(position);
                                      }),

                                    ],
                                  );
                                });
                            break;
                        }
                      },
                    );
                  }),
            ),
          );
        });
  }

  getUserDynamicList() async {
    refreshFlag = false;
    UserDynamic result =
        await UserDao.getUserDynamicList(context,cancelToken: dioToken);
    if (result.ok) {
      if (result.data.length == 10) {
        _isLoadMore = true;
      }
      setState(() {
        list.clear();
        list.addAll(result.data);
      });
    } else {
      ToastUtils.showShortErrorToast(result.msg);
    }
  }

  getMoreUserDynamicList(String id) async {
    UserDynamic result =
        await UserDao.getUserDynamicList(context, lastID: id,cancelToken: dioToken);
    if (result.ok) {
      if (result.data.length < 10) {
        _isLoadMore = false;
      }
      setState(() {
        list.addAll(result.data);
      });
    } else {
      ToastUtils.showShortErrorToast(result.msg);
    }
  }
  deleteDynamic(int position) async {
    Message result = await UserDao.deleteDynamic(context, list[position].id,cancelToken: dioToken);
    if(result.ok){
      setState(() {
        list.removeAt(position);
      });
      ToastUtils.showShortSuccessToast(result.msg);
    }else{
      ToastUtils.showShortErrorToast(result.msg);
    }
  }

  @override
  void dispose() {
    dioToken.cancel();
    super.dispose();
  }
}
