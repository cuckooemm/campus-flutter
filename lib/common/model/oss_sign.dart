import 'package:json_annotation/json_annotation.dart';

class OssSign{
  bool ok;
  String msg;
  String accessid;
  String host;
  String signature;
  String policy;
  String dir;
  String callback;
  int expire;
  OssSign({
        this.ok = true,
        this.msg,
        this.accessid,
        this.host,
        this.signature,
        this.policy,
        this.dir,
        this.callback,
        this.expire
      });
  factory OssSign.fromJson(Map<String, dynamic> json) => _$OssSignFromJson(json);

  Map<String, dynamic> toJson() => _$OssSignToJson(this);
}


OssSign _$OssSignFromJson(Map<String,dynamic> json){
  return OssSign(
    accessid:json["accessid"] as String,
    host:json["host"] as String,
    signature:json["signature"] as String,
    policy:json["policy"] as String,
    dir:json["dir"] as String,
    expire:json["expire"] as int,
    callback:json["callback"] as String,
  );
}

Map<String,dynamic> _$OssSignToJson(OssSign instance) => <String,dynamic>{
  'accessid': instance.accessid,
  'host': instance.host,
  'signature': instance.signature,
  'policy': instance.policy,
  'dir': instance.dir,
  'expire': instance.expire,
  'callback': instance.callback,
  'msg': instance.msg,
};