import 'package:campus/common/model/images_url.dart';
import 'package:json_annotation/json_annotation.dart';

class UserDynamic extends Object {

  bool ok;
  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  List<UserDynamicData> data;

  @JsonKey(name: 'msg')
  String msg;

  UserDynamic({this.code,this.data,this.msg,this.ok = true});

  factory UserDynamic.fromJson(Map<String, dynamic> srcJson) => _$UserDynamicFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserDynamicToJson(this);

}

class UserDynamicData extends Object {

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'image')
  ImagesUrl image;

  @JsonKey(name: 'browse')
  int browse;

  @JsonKey(name: 'comment_count')
  int commentCount;

  @JsonKey(name: 'praise_count')
  int praiseCount;

  @JsonKey(name: 'created_at')
  int createdAt;

  UserDynamicData(this.id,this.content,this.image,this.browse,this.commentCount,this.praiseCount,this.createdAt,);

  factory UserDynamicData.fromJson(Map<String, dynamic> srcJson) => _$UserDynamicDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserDynamicDataToJson(this);

}
UserDynamic _$UserDynamicFromJson(Map<String, dynamic> json) {
  return UserDynamic(
      code: json['code'] as int,
      data: (json['data'] as List)
          ?.map((e) => e == null
          ? null
          : UserDynamicData.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      msg: json['msg'] as String);
}

Map<String, dynamic> _$UserDynamicToJson(UserDynamic instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg
    };

UserDynamicData _$UserDynamicDataFromJson(Map<String, dynamic> json) {
  return UserDynamicData(
      json['id'] as String,
      json['content'] as String,
      json['image'] == null
          ? null
          : ImagesUrl.fromJson(json['image'] as Map<String, dynamic>),
      json['browse'] as int,
      json['comment_count'] as int,
      json['praise_count'] as int,
      json['created_at'] as int);
}

Map<String, dynamic> _$UserDynamicDataToJson(UserDynamicData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'image': instance.image,
      'browse': instance.browse,
      'comment_count': instance.commentCount,
      'praise_count': instance.praiseCount,
      'created_at': instance.createdAt
    };



