import 'package:campus/common/dao/dynamic_dao.dart';
import 'package:campus/common/model/comment.dart';
import 'package:campus/common/model/dynamic.dart';
import 'package:campus/common/model/message.dart';
import 'package:campus/common/style/colors.dart';
import 'package:campus/common/style/context_style.dart';
import 'package:campus/common/style/global_icons.dart';
import 'package:campus/common/style/string_tip.dart';
import 'package:campus/common/utils/common_utils.dart';
import 'package:campus/common/utils/navigator_utils.dart';
import 'package:campus/common/utils/object_utils.dart';
import 'package:campus/common/utils/taost_utils.dart';
import 'package:campus/widget/item/comment_item_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class CommentPage extends StatefulWidget {
  final DynamicData data;
  CommentPage(this.data);

  @override
  State<StatefulWidget> createState() => _CommentPage();
}

class _CommentPage extends State<CommentPage> {
  List<CommentData> list = <CommentData>[];

  final TextEditingController _commentController = TextEditingController();
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  CancelToken dioToken = new CancelToken();

  bool _isLoadMore = false;
  bool _isShowInputView = false;
  bool _isPublish = false;

  @override
  void initState() {
    getCommentList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text("评论"),
            centerTitle: true,
          ),
          body: Column(
            children: <Widget>[
              Flexible(
                child: EasyRefresh(
                    key: _easyRefreshKey,
                    onRefresh: (){
                      getCommentList();
                    },
                    loadMore: () {
                      if (_isLoadMore) {
                        getMoreCommentList(list.last.id);
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
                          return CommentItemWidget(list[position],
                            onTapItem: (){
                              NavigatorUtils.goReplyPage(context,list[position]);
                            },);
                        }),
                  ),
              ),
              Divider(height: 1.0),
              buildBottomWidget()
            ],
          ),
        );
  }

  Widget buildBottomWidget() {
    if (_isShowInputView) {
      return Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            TextField(
              maxLines: null,
              controller: _commentController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                    left: 15.0, top: 8.0, right: 15.0, bottom: 8.0),
                labelText: "评论 :${widget.data.name}的动态",
                hintText: StringTip.comment_tip,
                border: InputBorder.none,
              ),
              style: ContextStyle.inputContent,
              keyboardType: TextInputType.text,
              autofocus: true,
              onChanged: (String value) {
                if (value.trim().length > 0) {
                  setState(() {
                    _isPublish = true;
                  });
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    setState(() {
                      _isShowInputView = !_isShowInputView;
                      _isPublish = false;
                    });
                  },
                  child: Text("取消"),
                ),
                OutlineButton(
                  onPressed: _isPublish
                      ? () {
                    if (_commentController.text.length > 500) {
                      ToastUtils.showShortErrorToast(
                          StringTip.length_oversize_tip);
                    } else {
                      if(CommonUtils.getGlobalStore(context).state.token.isLogin){
                        sendComment(_commentController.text);
                      }else{
                        ToastUtils.showShortWarnToast(StringTip.after_login);
                      }
                    }
                  }
                      : null,
                  borderSide: GlobalColors.greenBorderSide,
                  color: Colors.lightBlueAccent,
                  child: Text("评论"),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Row(
        key: Key("buttonView"),
        children: <Widget>[
          Expanded(
            child: FlatButton.icon(
              label: Text(widget.data.commentCount.toString()),
              padding: EdgeInsets.all(0.0),
              icon: Icon(
                GlobalIcons.ITEM_COMMENT,
                size: 20.0,
              ),
              onPressed: () {
                setState(() {
                  _isShowInputView = !_isShowInputView;
                });
              },
            ),
            flex: 1,
          ),
          Expanded(
            child: FlatButton.icon(
              label: Text(widget.data.praiseCount.toString()),
              padding: EdgeInsets.all(0.0),
              icon: Icon(
                GlobalIcons.ITEM_PRAISE,
                size: 20.0,
              ),
              onPressed: sendPraise,
            ),
            flex: 1,
          ),
        ],
      );
    }
  }

  getCommentList() async {
    Comment result = await DynamicDao.getDynamicCommentList(widget.data.id,cancelToken: dioToken);
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

  getMoreCommentList(String lastID) async {
    Comment result =
        await DynamicDao.getDynamicCommentList(widget.data.id, lastID: lastID,cancelToken: dioToken);
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

  sendPraise() async {
    if(CommonUtils.getGlobalStore(context).state.token.isLogin){
      Message result = await DynamicDao.sendDynamicPraise(context, widget.data.id,cancelToken: dioToken);
      if (result.ok) {
        setState(() {
          ++widget.data.praiseCount;
        });
        ToastUtils.showShortSuccessToast(result.msg);
      } else {
        ToastUtils.showShortErrorToast(result.msg);
      }
    }else{
      ToastUtils.showShortWarnToast(StringTip.after_login);
    }
  }

  sendComment(String content) async {
    Message result = await DynamicDao.sendDynamicComment(context, content, widget.data.id,cancelToken: dioToken);
    if (result.ok) {
      _commentController.clear();
      setState(() {
        _isShowInputView = !_isShowInputView;
        _isPublish = false;
        ++widget.data.commentCount;
      });
      if (ObjectUtils.isEmptyList(list)) {
        getCommentList();
      } else if (!_isLoadMore) {
        getMoreCommentList(list.last.id);
      }
      ToastUtils.showShortSuccessToast(result.msg);
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
