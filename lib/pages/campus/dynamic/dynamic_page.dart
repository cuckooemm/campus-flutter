import 'package:campus/common/dao/dynamic_dao.dart';
import 'package:campus/common/model/dynamic.dart';
import 'package:campus/common/model/message.dart';
import 'package:campus/common/redux/app_state.dart';
import 'package:campus/common/style/global_icons.dart';
import 'package:campus/common/style/string_tip.dart';
import 'package:campus/common/utils/common_utils.dart';
import 'package:campus/common/utils/navigator_utils.dart';
import 'package:campus/common/utils/object_utils.dart';
import 'package:campus/common/utils/taost_utils.dart';
import 'package:campus/widget/item/dynamic_item_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:campus/common/redux/dynamic_data_redux.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class DynamicPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DynamicPage();
}

class _DynamicPage extends State<DynamicPage> {
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  CancelToken dioToken = new CancelToken();
  bool isLoadMore = true;

  @override
  void initState() {
    getDynamicList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<DynamicData>>(
        converter: (store) => store.state.dynamicList,
        builder: (context, store) {
          return Scaffold(
            body: EasyRefresh(
                key: _easyRefreshKey,
                onRefresh: () {
                  getDynamicList();
                },
                loadMore: (){
                  if (isLoadMore) {
                    loadMoreDynamic(store.last.id);
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
                child: new ListView.builder(
                    itemCount:
                        ObjectUtils.isEmptyList(store) ? 0 : store.length,
                    itemBuilder: (context, position) {
                      return DynamicItemWidget(
                        position,
                        praiseClick: (){
                          if(CommonUtils.getGlobalStore(context).state.token.isLogin){
                            sendPraise(position,store[position].id);
                          }else{
                            ToastUtils.showShortWarnToast(StringTip.after_login);
                          }
                        },
                      );
                    })),
            floatingActionButton: FloatingActionButton(
                onPressed: (){
                  NavigatorUtils.goDynamicPublishPage(context);
                },
            child: Icon(GlobalIcons.DYNAMIC_PUBLISH,size: 40.0,)),
          );
        });
  }

  getDynamicList() async {
    Dynamic result = await DynamicDao.getDynamicList(cancelToken: dioToken);
    if (result.ok) {
      if (!isLoadMore) {
        isLoadMore = true;
      }
      // 刷新数据
      CommonUtils.getGlobalStore(context).dispatch(RefreshDynamicDataAction(result.data));
    } else {
      ToastUtils.showShortErrorToast(result.msg);
    }
  }

  sendPraise(int position, String id) async {
    Message result =
        await DynamicDao.sendDynamicPraise(context, id,cancelToken: dioToken);
    if (result.ok) {
      CommonUtils.getGlobalStore(context)
          .dispatch(UpdateDynamicItemPraiseAction(position));
      ToastUtils.showShortSuccessToast(result.msg);
    } else {
      ToastUtils.showShortErrorToast(result.msg);
    }
  }

  loadMoreDynamic(String id) async {
    Dynamic result = await DynamicDao.getDynamicList(id: id,cancelToken: dioToken);
    if (result.ok) {
      if (result.data.length < 10) {
        isLoadMore = false;
      }
      CommonUtils.getGlobalStore(context).dispatch(AddDynamicItemAction(result.data));
    } else {
      ToastUtils.showShortErrorToast(result.msg);
    }
  }

  @override
  void dispose() {
    dioToken.cancel();
    super.dispose();
  }
}
