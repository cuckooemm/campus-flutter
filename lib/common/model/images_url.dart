import 'package:json_annotation/json_annotation.dart';

class ImagesUrl extends Object {

  @JsonKey(name: 'url')
  List<String> url;

  @JsonKey(name: 'url_original')
  List<String> urlOriginal;

  ImagesUrl(this.url,this.urlOriginal,);

  factory ImagesUrl.fromJson(Map<String, dynamic> srcJson) => _$ImagesUrlFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ImagesUrlToJson(this);

}
ImagesUrl _$ImagesUrlFromJson(Map<String, dynamic> json) {
  return ImagesUrl((json['url'] as List)?.map((e) => e as String)?.toList(),
      (json['url_original'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$ImagesUrlToJson(ImagesUrl instance) => <String, dynamic>{
  'url': instance.url,
  'url_original': instance.urlOriginal
};
