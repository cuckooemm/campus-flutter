import 'package:campus/common/dao/dynamic_dao.dart';
import 'package:campus/common/model/dynamic.dart';
import 'package:campus/common/model/message.dart';
import 'package:campus/common/redux/app_state.dart';
import 'package:campus/common/redux/dynamic_data_redux.dart';
import 'package:campus/common/style/context_style.dart';
import 'package:campus/common/style/global_icons.dart';
import 'package:campus/common/utils/common_utils.dart';
import 'package:campus/common/utils/navigator_utils.dart';
import 'package:campus/widget/item/nine_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

///  动态的item
class DynamicItemWidget extends StatefulWidget {
  final position;
  DynamicItemWidget(this.position,{this.praiseClick});
  final VoidCallback praiseClick;
  @override
  State<StatefulWidget> createState() => _DynamicItemWidget();
}

class _DynamicItemWidget extends State<DynamicItemWidget> {
  final imageSize = 45.0;
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<DynamicData>>(
        converter: (store) => store.state.dynamicList,
        builder: (context, list) {
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
                          child: CommonUtils.buildUserAvatarImage(list[this.widget.position].avatar,imageSize),
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
                            Text(list[this.widget.position].name,
                                style: ContextStyle.itemNickname),
                            Padding(
                              padding: const EdgeInsets.only(top: 1.0),
                              child: Text(
                                  CommonUtils.getNewsTimeStr(
                                      list[this.widget.position].createdAt),
                                  style: ContextStyle.itemCreatedAt),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
                    child: Text(list[this.widget.position].content,
                        style: ContextStyle.itemContext, softWrap: true),
                  ),
                  NineGridWidget(list[this.widget.position].image),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              GlobalIcons.ITEM_BROWSE,
                              size: 20.0,
                            ),
                            Text("  " + list[this.widget.position].browse.toString()),
                          ],
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: FlatButton.icon(
                            label: Text(list[this.widget.position].commentCount.toString()),
                            padding: const EdgeInsets.all(0.0),
                            icon: Icon(
                              GlobalIcons.ITEM_COMMENT,
                              size: 20.0,
                            ),
                            onPressed: () {
                              NavigatorUtils.goDynamicCommentPage(
                                  context, list[this.widget.position]);
                            }),
                        flex: 1,
                      ),
                      Expanded(
                        child: FlatButton.icon(
                          label: Text(list[this.widget.position].praiseCount.toString()),
                          padding: const EdgeInsets.all(0.0),
                          icon: Icon(
                            GlobalIcons.ITEM_PRAISE,
                            size: 20.0,
                          ),
                          onPressed: this.widget.praiseClick,
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

}
