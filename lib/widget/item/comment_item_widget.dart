import 'package:campus/common/model/comment.dart';
import 'package:campus/common/style/context_style.dart';
import 'package:campus/common/utils/common_utils.dart';
import 'package:campus/common/utils/navigator_utils.dart';
import 'package:flutter/material.dart';

/// 评论item
class CommentItemWidget extends StatefulWidget {
  final CommentData item;
  final GestureTapCallback onTapItem;
  CommentItemWidget(this.item,{this.onTapItem});

  @override
  State<StatefulWidget> createState() => _CommentItemWidget();
}

class _CommentItemWidget extends State<CommentItemWidget> {
  final imageSize = 35.0;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
      child: InkWell(
        onTap: this.widget.onTapItem,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    child: ClipOval(
                      child: CommonUtils.buildUserAvatarImage(widget.item.avatar,imageSize),
                    ),
                    onTap: () {
                      // TODO 打开用户详情
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(widget.item.name, style: ContextStyle.itemNickname),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 51.0, right: 20.0, top: 8.0, bottom: 2.0),
                child: Text(widget.item.content,
                    style: ContextStyle.itemContext, softWrap: true),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 51.0, top: 4.0, bottom: 2.0),
                child: Row(
                  children: <Widget>[
                    Text(CommonUtils.getNewsTimeStr(widget.item.createdAt) + "  ·  ",style: ContextStyle.itemCreatedAt,),
                    InkWell(
                      child: Text(widget.item.replyCount != 0 ? widget.item.replyCount.toString()+ "回复" : "" + "回复"),
                      radius: 5.0,
                      onTap: (){
                        NavigatorUtils.goReplyPage(context, widget.item);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }

}