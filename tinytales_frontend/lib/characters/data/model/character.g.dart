// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      id: json['docId'] as String,
      createDate: const FirestoreDateTimeConverter()
          .fromJson(json['create_date'] as Timestamp),
      name: json['name'] as String,
      description: json['description'] as String?,
      updateDate: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['update_date'], const FirestoreDateTimeConverter().fromJson),
      userDescription: json['user_description'] as String?,
      picture: json['picture'] as String?,
      pictureState: $enumDecodeNullable(
          _$CharacterPictureStateEnumMap, json['illustrations_state']),
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'create_date':
          const FirestoreDateTimeConverter().toJson(instance.createDate),
      'description': instance.description,
      'name': instance.name,
      'picture': instance.picture,
      'update_date': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.updateDate, const FirestoreDateTimeConverter().toJson),
      'user_description': instance.userDescription,
      'illustrations_state':
          _$CharacterPictureStateEnumMap[instance.pictureState],
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

const _$CharacterPictureStateEnumMap = {
  CharacterPictureState.characterIllustrationGeneration:
      'CHARACTER_IMAGE_GENERATION',
  CharacterPictureState.completed: 'COMPLETED',
  CharacterPictureState.error: 'ERROR',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
