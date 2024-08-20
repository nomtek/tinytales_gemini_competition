// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Validation _$ValidationFromJson(Map<String, dynamic> json) => Validation(
      valid: json['valid'] as bool,
      validationStatus:
          $enumDecode(_$ValidationStatusEnumMap, json['validationStatus']),
      suggestedVersion: SuggestedVersion.fromJson(
          const MapConverter().fromJson(json['suggestedVersion'] as Map)),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ValidationToJson(Validation instance) =>
    <String, dynamic>{
      'valid': instance.valid,
      'message': instance.message,
      'validationStatus': _$ValidationStatusEnumMap[instance.validationStatus]!,
      'suggestedVersion': instance.suggestedVersion,
    };

const _$ValidationStatusEnumMap = {
  ValidationStatus.inappropriate: 'Inappropriate',
  ValidationStatus.needsImprovement: 'Needs Improvement',
  ValidationStatus.excellent: 'Excellent',
};

SuggestedVersion _$SuggestedVersionFromJson(Map<String, dynamic> json) =>
    SuggestedVersion(
      name: json['name'] as String?,
      description: json['description'] as String?,
      content: json['content'] as String?,
    );

Map<String, dynamic> _$SuggestedVersionToJson(SuggestedVersion instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'content': instance.content,
    };
