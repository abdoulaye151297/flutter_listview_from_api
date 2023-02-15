// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as int?,
      categoryId: json['category_id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      imagesUrl: json['images_url'] == null
          ? null
          : ImagesUrl.fromJson(json['images_url'] as Map<String, dynamic>),
      creationDate: json['creation_date'] as String?,
      isUrgent: json['is_urgent'] as bool?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'images_url': instance.imagesUrl,
      'creation_date': instance.creationDate,
      'is_urgent': instance.isUrgent,
    };
