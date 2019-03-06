import 'package:campus/common/dao/dynamic_dao.dart';
import 'package:campus/common/dao/user_dao.dart';
import 'package:campus/common/model/message.dart';
import 'package:campus/common/model/user_message.dart';
import 'package:campus/common/style/colors.dart';
import 'package:campus/common/style/context_style.dart';
import 'package:campus/common/style/string_tip.dart';
import 'package:campus/common/utils/common_utils.dart';
import 'package:campus/common/utils/log_utils.dart';
import 'package:campus/common/utils/taost_utils.dart';
import 'package:campus/widget/item/user_message_item_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class UserMessagePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _UserMessageState();
}

class _UserMessageState extends State<UserMessagePage>{
  List<UserMessageData> list = <UserMessageData>[];

  CancelToken dioToken = new CancelToken();

  final TextEditingController _messageController = TextEditingController();
  GlobalKey<EasyRefreshState> _easyRefreshKey =
  new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
  new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
  new GlobalKey<RefreshFooterState>();

  bool _isLoadMore = false;
  bool _isShowInputView = false;
  bool _isPublish = false;
  String _replyName;
  String _replyID;

  bool refreshFlag = true;
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500),(){
      if(refreshFlag){
        getMessageList();
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("消息"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: EasyRefresh(
              key: _easyRefreshKey,
              onRefresh: () {
                getMessageList();
              },
              loadMore: (){
                if (_isLoadMore) {
                  getMoreMessageList(list.last.id);
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
                    return UserMessageItemWidget(list[position],
                      onTapReply: (){
                        setState(() {
                          _replyName = list[position].name;
                          _replyID = list[position].id;
                          _isShowInputView = !_isShowInputView;
                          _messageController.clear();
                        });
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
              controller: _messageController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 15.0, top: 8.0, right: 15.0, bottom: 8.0),
                labelText: "回复: $_replyName",
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
                    if (_messageController.text.length > 500) {
                      ToastUtils.showShortErrorToast(
                          StringTip.length_oversize_tip);
                    } else {
                      if(CommonUtils.getGlobalStore(context).state.token.isLogin){
                        sendReply(_messageController.text);
                      }else{
                        ToastUtils.showShortWarnToast(StringTip.after_login);
                      }
                    }
                  }
                      : null,
                  borderSide: GlobalColors.greenBorderSide,
                  color: Colors.lightBlueAccent,
                  child: Text("回复"),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Container(width: 0.0,height: 0.0,);
    }
  }

  sendReply(String content) async {
    Message result = await DynamicDao.sendDynamicCommentReply(context, content, _replyID);
    if(result.ok){
      _messageController.clear();
      setState(() {
        _isShowInputView = !_isShowInputView;
        _isPublish = false;
      });
      ToastUtils.showShortSuccessToast(result.msg);
    }else{
      ToastUtils.showShortErrorToast(result.msg);
    }
  }

  getMessageList() async {
    refreshFlag = false;
    UserMessage result = await UserDao.getUserMessageList(context,cancelToken: dioToken);
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

  getMoreMessageList(String lastID) async {
    UserMessage result = await UserDao.getUserMessageList(context, lastID: lastID,cancelToken: dioToken);
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

  @override
  void dispose() {
    dioToken.cancel();
    super.dispose();
  }
}
