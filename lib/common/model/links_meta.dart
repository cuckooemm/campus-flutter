import 'package:json_annotation/json_annotation.dart';

class Meta extends Object {

  @JsonKey(name: 'current_page')
  int currentPage;

  @JsonKey(name: 'per_page')
  int perPage;

  Meta(this.currentPage,this.perPage,);

  factory Meta.fromJson(Map<String, dynamic> srcJson) => _$MetaFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MetaToJson(this);

}

class Links extends Object {

  @JsonKey(name: 'prev')
  String prev;

  @JsonKey(name: 'next')
  String next;

  Links(this.prev,this.next,);

  factory Links.fromJson(Map<String, dynamic> srcJson) => _$LinksFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LinksToJson(this);

}


Meta _$MetaFromJson(Map<String, dynamic> json) {
  return Meta(json['current_page'] as int, json['per_page'] as int);
}

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
  'current_page': instance.currentPage,
  'per_page': instance.perPage
};

Links _$LinksFromJson(Map<String, dynamic> json) {
  return Links(json['prev'] as String, json['next'] as String);
}

Map<String, dynamic> _$LinksToJson(Links instance) =>
    <String, dynamic>{'prev': instance.prev, 'next': instance.next};
