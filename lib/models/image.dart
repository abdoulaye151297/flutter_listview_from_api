import 'package:json_annotation/json_annotation.dart';
part 'image.g.dart';

@JsonSerializable()
class ImagesUrl {
  @JsonKey(name: 'small')
  String? small;
  @JsonKey(name: 'thumb')
  String? thumb;

  ImagesUrl({this.small, this.thumb});

  factory ImagesUrl.fromJson(Map<String, dynamic> json) =>
      _$ImagesUrlFromJson(json);
  Map<String, dynamic> toJson() => _$ImagesUrlToJson(this);
}
