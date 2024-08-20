// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      id: json['docId'] as String,
      createDate: const FirestoreDateTimeConverter()
          .fromJson(json['create_date'] as Timestamp),
      title: json['title'] as String,
      textState: $enumDecode(_$TextStateEnumMap, json['text_state']),
      mainCharacterName: json['main_character_name'] as String,
      mainCharacterDescription: json['main_character_description'] as String,
      deleted: json['deleted'] as bool,
      overview: json['overview'] as String?,
      picture: json['picture'] as String?,
      pictureState: $enumDecodeNullable(
          _$PictureStateEnumMap, json['illustrations_state']),
      updateDate: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['update_date'], const FirestoreDateTimeConverter().fromJson),
      pdfUrl: json['pdf'] as String?,
      fullText: json['full_text'] as String?,
      audioUrl: json['audio'] as String?,
      audioState: $enumDecodeNullable(_$AudioStateEnumMap, json['audio_state']),
    );

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'create_date':
          const FirestoreDateTimeConverter().toJson(instance.createDate),
      'main_character_name': instance.mainCharacterName,
      'main_character_description': instance.mainCharacterDescription,
      'overview': instance.overview,
      'picture': instance.picture,
      'title': instance.title,
      'update_date': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.updateDate, const FirestoreDateTimeConverter().toJson),
      'text_state': _$TextStateEnumMap[instance.textState]!,
      'illustrations_state': _$PictureStateEnumMap[instance.pictureState],
      'pdf': instance.pdfUrl,
      'deleted': instance.deleted,
      'full_text': instance.fullText,
      'audio': instance.audioUrl,
      'audio_state': _$AudioStateEnumMap[instance.audioState],
    };

const _$TextStateEnumMap = {
  TextState.inputCollection: 'INPUT_COLLECTION',
  TextState.taleGeneration: 'TALE_GENERATION',
  TextState.taleReview: 'TALE_REVIEW',
  TextState.completed: 'COMPLETED',
  TextState.error: 'ERROR',
};

const _$PictureStateEnumMap = {
  PictureState.pageIllustrationGeneration: 'PAGE_ILUSTRATION_GENERATION',
  PictureState.completed: 'COMPLETED',
  PictureState.error: 'ERROR',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

const _$AudioStateEnumMap = {
  AudioState.noAudio: 'NO_AUDIO',
  AudioState.audioGeneration: 'AUDIO_GENERATION',
  AudioState.audioReview: 'AUDIO_REVIEW',
  AudioState.completed: 'COMPLETED',
  AudioState.error: 'ERROR',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
