import 'package:json_annotation/json_annotation.dart';

class Reply extends Object {

  bool ok;
  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  List<ReplyData> data;

  @JsonKey(name: 'msg')
  String msg;

  Reply({this.code,this.data,this.msg,this.ok = true});

  factory Reply.fromJson(Map<String, dynamic> srcJson) => _$ReplyFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReplyToJson(this);

}


class ReplyData extends Object {

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'uid')
  String uid;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'avatar')
  String avatar;

  @JsonKey(name: 'gender')
  String gender;

  @JsonKey(name: 'r_name')
  String rName;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'praise_count')
  int praiseCount;

  @JsonKey(name: 'created_at')
  int createdAt;

  ReplyData(this.id,this.uid,this.name,this.avatar,this.gender,this.rName,this.content,this.praiseCount,this.createdAt,);

  factory ReplyData.fromJson(Map<String, dynamic> srcJson) => _$ReplyDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReplyDataToJson(this);

}


Reply _$ReplyFromJson(Map<String, dynamic> json) {
  return Reply(
      code:json['code'] as int,
      data:(json['data'] as List)
          ?.map((e) =>
      e == null ? null : ReplyData.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      msg:json['msg'] as String);
}

Map<String, dynamic> _$ReplyToJson(Reply instance) => <String, dynamic>{
  'code': instance.code,
  'data': instance.data,
  'msg': instance.msg
};

ReplyData _$ReplyDataFromJson(Map<String, dynamic> json) {
  return ReplyData(
      json['id'] as String,
      json['uid'] as String,
      json['name'] as String,
      json['avatar'] as String,
      json['gender'] as String,
      json['r_name'] as String,
      json['content'] as String,
      json['praise_count'] as int,
      json['created_at'] as int);
}

Map<String, dynamic> _$ReplyDataToJson(ReplyData instance) => <String, dynamic>{
  'id': instance.id,
  'uid': instance.uid,
  'name': instance.name,
  'avatar': instance.avatar,
  'gender': instance.gender,
  'r_name': instance.rName,
  'content': instance.content,
  'praise_count': instance.praiseCount,
  'created_at': instance.createdAt
};

