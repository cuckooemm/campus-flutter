import 'package:campus/common/model/images_url.dart';
import 'package:json_annotation/json_annotation.dart';

class Dynamic extends Object {

  bool ok;
  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  List<DynamicData> data;

  @JsonKey(name: 'msg')
  String msg;
  Dynamic({this.code,this.data,this.msg,this.ok = true});
  factory Dynamic.fromJson(Map<String, dynamic> srcJson) => _$DynamicFromJson(srcJson);
  Map<String, dynamic> toJson() => _$DynamicToJson(this);
}

class DynamicData extends Object {

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

  DynamicData(this.id,this.uid,this.name,this.avatar,this.gender,this.content,this.image,this.browse,this.commentCount,this.praiseCount,this.createdAt,);

  factory DynamicData.fromJson(Map<String, dynamic> srcJson) => _$DynamicDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DynamicDataToJson(this);

}

Dynamic _$DynamicFromJson(Map<String, dynamic> json) {
  return Dynamic(
      code: json['code'] as int,
      data: (json['data'] as List)
          ?.map((e) => e == null
          ? null
          : DynamicData.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      msg: json['msg'] as String);
}

Map<String, dynamic> _$DynamicToJson(Dynamic instance) => <String, dynamic>{
  'ok': instance.ok,
  'code': instance.code,
  'data': instance.data,
  'msg': instance.msg
};

DynamicData _$DynamicDataFromJson(Map<String, dynamic> json) {
  return DynamicData(
      json['id'] as String,
      json['uid'] as String,
      json['name'] as String,
      json['avatar'] as String,
      json['gender'] as String,
      json['content'] as String,
      json['image'] == null
          ? null
          : ImagesUrl.fromJson(json['image'] as Map<String, dynamic>),
      json['browse'] as int,
      json['comment_count'] as int,
      json['praise_count'] as int,
      json['created_at'] as int);
}

Map<String, dynamic> _$DynamicDataToJson(DynamicData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'name': instance.name,
      'avatar': instance.avatar,
      'gender': instance.gender,
      'content': instance.content,
      'image': instance.image,
      'browse': instance.browse,
      'comment_count': instance.commentCount,
      'praise_count': instance.praiseCount,
      'created_at': instance.createdAt
    };



