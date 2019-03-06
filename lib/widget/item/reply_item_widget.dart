import 'package:campus/common/model/reply.dart';
import 'package:campus/common/style/context_style.dart';
import 'package:campus/common/utils/common_utils.dart';
import 'package:flutter/material.dart';

class ReplyItemWidget extends StatelessWidget {
  final ReplyData item;
  final GestureTapCallback onTapReply;
  final GestureLongPressCallback onLongTapReply;
  ReplyItemWidget(this.item,{this.onTapReply,this.onLongTapReply});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
      child: InkWell(
        onTap: this.onTapReply,
        onLongPress: this.onLongTapReply,
        child: Padding(
            padding: const EdgeInsets.only(
                left: 8.0, top: 8.0, right: 8.0, bottom: 4.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        child: ClipOval(
                          child: CommonUtils.buildUserAvatarImage(item.avatar,35.0),
                        ),
                        onTap: () {
                          // TODO 打开用户详情
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(item.name, style: ContextStyle.itemNickname),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text("回复:${item.rName}",style: ContextStyle.itemContext),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 51.0, right: 20.0, top: 8.0, bottom: 2.0),
                    child: Text(item.content,
                        style: ContextStyle.itemContext, softWrap: true),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 51.0, top: 4.0, bottom: 2.0),
                    child: Text(CommonUtils.getNewsTimeStr(item.createdAt) + "  ·  ",style: ContextStyle.itemCreatedAt,),
                  )
                ])),
      ),
    );
  }
}
