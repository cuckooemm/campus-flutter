import 'package:campus/common/model/user_dynamic.dart';
import 'package:campus/common/style/context_style.dart';
import 'package:campus/common/style/global_icons.dart';
import 'package:campus/common/utils/common_utils.dart';
import 'package:campus/widget/item/nine_grid_widget.dart';
import 'package:flutter/material.dart';

enum UserDynamicClick { delete }
class UserDynamicItemWidget extends StatelessWidget {
  final UserDynamicData item;
  final String avatar;
  final String nickname;
  final PopupMenuItemSelected<UserDynamicClick> rightButtonCallback;
  UserDynamicItemWidget(this.item, this.nickname, this.avatar,{this.rightButtonCallback});

  final imageSize = 45.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                GestureDetector(
                  child: ClipOval(
                    child: CommonUtils.buildUserAvatarImage(avatar, imageSize),
                  ),
                  onTap: () {
                    // TODO 打开用户详情
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(nickname, style: ContextStyle.itemNickname),
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: Text(CommonUtils.getNewsTimeStr(item.createdAt),
                            style: ContextStyle.itemCreatedAt),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(""),
                ),
                PopupMenuButton(
                  icon: Icon(Icons.linear_scale,),
                  itemBuilder: (BuildContext context) => <PopupMenuItem<UserDynamicClick>>[
                    PopupMenuItem<UserDynamicClick>(
                        value: UserDynamicClick.delete,
                        child: new Text('删除')
                    ),
                  ],
                  onSelected: rightButtonCallback
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
              child: Text(item.content,
                  style: ContextStyle.itemContext, softWrap: true),
            ),
            NineGridWidget(item.image),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          GlobalIcons.ITEM_BROWSE,
                          size: 20.0,
                        ),
                        Text("  ${item.browse.toString()}"),
                      ],
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          GlobalIcons.ITEM_COMMENT,
                          size: 20.0,
                        ),
                        Text("  ${item.commentCount.toString()}"),
                      ],
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          GlobalIcons.ITEM_PRAISE,
                          size: 20.0,
                        ),
                        Text("  ${item.praiseCount.toString()}"),
                      ],
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
