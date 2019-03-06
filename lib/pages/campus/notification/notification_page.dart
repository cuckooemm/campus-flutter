import 'package:campus/common/utils/object_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class NotificationPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage>{

  GlobalKey<EasyRefreshState> _easyRefreshKey =
  new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
  new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
  new GlobalKey<RefreshFooterState>();

  CancelToken dioToken = new CancelToken();
  bool isLoadMore = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh(
          key: _easyRefreshKey,
          onRefresh: () {
//            getNotificationList();
          },
          loadMore: (){
            if (isLoadMore) {
//              loadMoreNotificationList(store.last.id);
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
          child: new ListView.builder(
              itemCount: 0,
              itemBuilder: (context, position) {
              })),
    );
  }

}