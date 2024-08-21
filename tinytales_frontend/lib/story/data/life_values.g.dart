// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'life_values.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LifeValues _$LifeValuesFromJson(Map<String, dynamic> json) => LifeValues(
      id: json['docId'] as String,
      description: json['description'] as String,
      name: json['name'] as String,
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$LifeValuesToJson(LifeValues instance) =>
    <String, dynamic>{
      'description': instance.description,
      'name': instance.name,
      'order': instance.order,
    };
