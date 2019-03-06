import 'package:campus/common/model/dynamic.dart';
import 'package:campus/common/model/token.dart';
import 'package:campus/common/model/user.dart';
import 'package:campus/common/redux/app_state.dart';
import 'package:campus/main_page.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

void main() {
//  debugPaintSizeEnabled = true;
  runApp(App());
}

class App extends StatelessWidget {

  // 获取登录状态
  final store = new Store<AppState>(appReducer,
      //初始化数据
      initialState: AppState(
          userInfo: UserInfo(),
          token: Token(false),
          themeData: ThemeData(
            primarySwatch: Colors.blue,
          ),
          dynamicList:<DynamicData>[]));

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new StoreBuilder<AppState>(builder: (context, store) {
        return new MaterialApp(
          theme: store.state.themeData,
          home: MainPage(),
        );
      }),
    );
  }

}
