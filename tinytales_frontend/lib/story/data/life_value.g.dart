// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'life_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LifeValue _$LifeValueFromJson(Map<String, dynamic> json) => LifeValue(
      id: json['docId'] as String,
      description: json['description'] as String,
      name: json['name'] as String,
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$LifeValueToJson(LifeValue instance) => <String, dynamic>{
      'description': instance.description,
      'name': instance.name,
      'order': instance.order,
    };
