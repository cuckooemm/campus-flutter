import 'package:campus/common/model/dynamic.dart';
import 'package:campus/common/utils/log_utils.dart';
import 'package:redux/redux.dart';

final dynamicDataReducer = combineReducers<List<DynamicData>>([
  ///将 Action 、处理 Action 的方法、State 绑定
  TypedReducer<List<DynamicData>, RefreshDynamicDataAction>(_refresh),
  TypedReducer<List<DynamicData>, AddDynamicItemAction>(_addItem),
  TypedReducer<List<DynamicData>, UpdateDynamicItemPraiseAction>(_updatePraise),
  TypedReducer<List<DynamicData>, UpdateDynamicItemCommentCountAction>(_updateCommentCount),
]);

///定义处理 Action 行为的方法，返回新的 State
List<DynamicData> _refresh(List<DynamicData> dynamicData,RefreshDynamicDataAction action) {
  dynamicData.clear();
  return action.data;
}
List<DynamicData> _addItem(List<DynamicData> dynamicData, action){
  dynamicData.addAll(action.data);
  return dynamicData;
}
List<DynamicData> _updatePraise(List<DynamicData> dynamicData,UpdateDynamicItemPraiseAction action){
  ++dynamicData[action.position].praiseCount;
  return dynamicData;
}
List<DynamicData> _updateCommentCount(List<DynamicData> dynamicData,UpdateDynamicItemCommentCountAction action){
  ++dynamicData[action.position].commentCount;
  return dynamicData;
}

///定义一个 Action 类
///
class RefreshDynamicDataAction {
  final List<DynamicData> data;
  RefreshDynamicDataAction(this.data);
}
class AddDynamicItemAction {
  final List<DynamicData> data;
  AddDynamicItemAction(this.data);
}
class UpdateDynamicItemPraiseAction {
  final int position;
  UpdateDynamicItemPraiseAction(this.position);
}
class UpdateDynamicItemCommentCountAction {
  final int position;
  UpdateDynamicItemCommentCountAction(this.position);
}