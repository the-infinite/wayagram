// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Select _$SelectFromJson(Map<String, dynamic> json) => Select(
      label: json['label'] as String,
      value: json['value'] as String,
      image: json['image'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SelectToJson(Select instance) => <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
      'image': instance.image,
      'price': instance.price,
    };
