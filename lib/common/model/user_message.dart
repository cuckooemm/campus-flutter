import 'package:json_annotation/json_annotation.dart';


class UserMessage extends Object {

  bool ok;
  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  List<UserMessageData> data;

  @JsonKey(name: 'msg')
  String msg;

  UserMessage({this.code,this.data,this.msg,this.ok = true});

  factory UserMessage.fromJson(Map<String, dynamic> srcJson) => _$UserMessageFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserMessageToJson(this);

}

class UserMessageData extends Object {

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'type')
  int type;

  @JsonKey(name: 'uid')
  String uid;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'avatar')
  String avatar;

  @JsonKey(name: 'gender')
  String gender;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'message')
  String message;

  @JsonKey(name: 'created_at')
  int createdAt;

  UserMessageData(this.id,this.type,this.uid,this.name,this.avatar,this.gender,this.content,this.message,this.createdAt,);

  factory UserMessageData.fromJson(Map<String, dynamic> srcJson) => _$UserMessageDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserMessageDataToJson(this);

}

UserMessage _$UserMessageFromJson(Map<String, dynamic> json) {
  return UserMessage(
      code: json['code'] as int,
      data: (json['data'] as List)
          ?.map((e) => e == null
          ? null
          : UserMessageData.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      msg: json['msg'] as String);
}

Map<String, dynamic> _$UserMessageToJson(UserMessage instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg
    };

UserMessageData _$UserMessageDataFromJson(Map<String, dynamic> json) {
  return UserMessageData(
      json['id'] as String,
      json['type'] as int,
      json['uid'] as String,
      json['name'] as String,
      json['avatar'] as String,
      json['gender'] as String,
      json['content'] as String,
      json['message'] as String,
      json['created_at'] as int);
}

Map<String, dynamic> _$UserMessageDataToJson(UserMessageData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'uid': instance.uid,
      'name': instance.name,
      'avatar': instance.avatar,
      'gender': instance.gender,
      'content': instance.content,
      'message': instance.message,
      'created_at': instance.createdAt
    };
