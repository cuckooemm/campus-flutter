import 'package:campus/common/model/user_message.dart';
import 'package:campus/common/style/context_style.dart';
import 'package:campus/common/utils/common_utils.dart';
import 'package:flutter/material.dart';

class UserMessageItemWidget extends StatelessWidget{
  final UserMessageData item;
  final GestureTapCallback onTapReply;
  UserMessageItemWidget(this.item,{this.onTapReply});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
      child: InkWell(
        onTap: this.onTapReply,
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
                        child: Text(item.type == 1
                            ? "回复了我"
                        : "评论了我的动态"),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 51.0, right: 10.0, top: 2.0, bottom: 2.0),
                    child: Text(item.message,
                        style: ContextStyle.itemContext, softWrap: true),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(65.0, 2.0, 10.0, 2.0),
                    color: Colors.grey.shade200,
                    child: Padding(padding: const EdgeInsets.all(5.0),
                    child: Text(item.content,
                        style: ContextStyle.itemContext,softWrap: true),),
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