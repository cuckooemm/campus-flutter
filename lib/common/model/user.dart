import 'package:json_annotation/json_annotation.dart';


class UserInfo {
  bool ok;
  String msg;
  String uid;
  String email;
  String phone;
  String qq_id;
  String weapp_id;
  String nickname;
  String avatar;
  int gender;
  String birthday;
  String bio;

  UserInfo(
      {this.ok = true,
      this.msg,
      this.uid,
      this.email,
      this.phone,
      this.qq_id,
      this.weapp_id,
      this.nickname,
      this.avatar,
      this.gender,
      this.birthday,
      this.bio});

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  // 命名构造函数
  UserInfo.empty();
}

UserInfo _$UserFromJson(Map<String, dynamic> json) {
  return UserInfo(
    uid: json['uid'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    qq_id: json['qq_id'] as String,
    weapp_id: json['weapp_id'] as String,
    nickname: json['nickname'] as String,
    avatar: json['avatar'] as String,
    gender: json['gender'] as int,
    birthday: json['birthday'] as String,
    bio: json['bio'] as String,
  );
}

Map<String, dynamic> _$UserToJson(UserInfo instance) => <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'phone': instance.phone,
      'qq_id': instance.qq_id,
      'weapp_id': instance.weapp_id,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'gender': instance.gender,
      'birthday': instance.birthday,
      'bio': instance.bio,
    };
