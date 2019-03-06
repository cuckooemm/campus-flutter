import 'package:campus/common/model/user.dart';
import 'package:redux/redux.dart';

final userInfoReducer = combineReducers<UserInfo>([
  TypedReducer<UserInfo,UpdateUserInfoAction>(_updateLoaded),
]);

UserInfo _updateLoaded(UserInfo userInfo,action){
  userInfo = action.userInfo;
  return userInfo;
}

class UpdateUserInfoAction{
  UserInfo userInfo;
  UpdateUserInfoAction(this.userInfo);
}