import 'package:json_annotation/json_annotation.dart';

///   flutter packages pub run build_runner build
///
class Comment extends Object {

  bool ok;
  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  List<CommentData> data;

  @JsonKey(name: 'msg')
  String msg;

  Comment({this.code,this.data,this.msg,this.ok = true});

  factory Comment.fromJson(Map<String, dynamic> srcJson) => _$CommentFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

}

class CommentData extends Object {

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

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'praise_count')
  int praiseCount;

  @JsonKey(name: 'reply_count')
  int replyCount;

  @JsonKey(name: 'created_at')
  int createdAt;

  CommentData(this.id,this.uid,this.name,this.avatar,this.gender,this.content,this.praiseCount,this.replyCount,this.createdAt,);

  factory CommentData.fromJson(Map<String, dynamic> srcJson) => _$CommentDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CommentDataToJson(this);

}

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
      code:json['code'] as int,
      data:(json['data'] as List)
          ?.map((e) => e == null
          ? null
          : CommentData.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      msg:json['msg'] as String);
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
  'code': instance.code,
  'data': instance.data,
  'msg': instance.msg
};

CommentData _$CommentDataFromJson(Map<String, dynamic> json) {
  return CommentData(
      json['id'] as String,
      json['uid'] as String,
      json['name'] as String,
      json['avatar'] as String,
      json['gender'] as String,
      json['content'] as String,
      json['praise_count'] as int,
      json['reply_count'] as int,
      json['created_at'] as int);
}

Map<String, dynamic> _$CommentDataToJson(CommentData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'name': instance.name,
      'avatar': instance.avatar,
      'gender': instance.gender,
      'content': instance.content,
      'praise_count': instance.praiseCount,
      'reply_count': instance.replyCount,
      'created_at': instance.createdAt
    };

