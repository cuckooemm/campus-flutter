
class Token{
  bool isLogin;
  bool ok;
  String msg;
  String token;
  int expiresAt;
  int invalidAt;
  Token(this.isLogin,
  {
    this.ok = true,
    this.msg,
    this.token,
    this.expiresAt,
    this.invalidAt
  });
  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  Map<String, dynamic> toJson() => _$TokenToJson(this);
}


Token _$TokenFromJson(Map<String,dynamic> json){
  return Token(json["token"] != null,
    token:json["token"] as String,
    expiresAt:json["expires_at"] as int,
    invalidAt:json["invalid_at"] as int,
    msg:json["msg"] as String,
  );
}

Map<String,dynamic> _$TokenToJson(Token instance) => <String,dynamic>{
  'token': instance.token,
  'expires_at': instance.expiresAt,
  'invalid_at': instance.invalidAt,
  'msg': instance.msg,
};