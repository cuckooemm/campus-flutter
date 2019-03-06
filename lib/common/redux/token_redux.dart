import 'package:campus/common/model/token.dart';
import 'package:redux/redux.dart';

final tokenReducer = combineReducers<Token>([
  TypedReducer<Token,UpdateTokenAction>(_updateToken),
]);

Token _updateToken(Token token,action){
  token = action.token;
  return token;
}

class UpdateTokenAction{
  Token token;
  UpdateTokenAction(this.token);
}