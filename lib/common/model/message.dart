
class Message{
  bool ok;
  String data;
  int code;
  String msg;
  Message({
    this.code,
    this.msg,
    this.data,
    this.ok = true
  });
  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}


Message _$MessageFromJson(Map<String,dynamic> json){
  return Message(
    msg:json["msg"] as String,
    code:json["code"] as int,
    data:json["data"] as String,
  );
}

Map<String,dynamic> _$MessageToJson(Message instance) => <String,dynamic>{
  'msg': instance.msg,
  'data': instance.data,
  'code': instance.code,
};