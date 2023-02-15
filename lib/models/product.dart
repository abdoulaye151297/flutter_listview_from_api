import 'package:flutter_application_store/models/image.dart';
import 'package:json_annotation/json_annotation.dart';
part 'product.g.dart';

@JsonSerializable()
class Product {
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'category_id')
  int? categoryId;
  @JsonKey(name: 'title')
  String? title;
  @JsonKey(name: 'description')
  String? description;
  @JsonKey(name: 'price')
  double? price;
  @JsonKey(name: 'images_url')
  ImagesUrl? imagesUrl;
  @JsonKey(name: 'creation_date')
  String? creationDate;
  @JsonKey(name: 'is_urgent')
  bool? isUrgent;

  Product(
      {this.id,
      this.categoryId,
      this.title,
      this.description,
      this.price,
      this.imagesUrl,
      this.creationDate,
      this.isUrgent});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
