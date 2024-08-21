import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tale_ai_frontend/firebase/firebase.dart';

part 'character.g.dart';

@JsonSerializable()
@FirestoreDateTimeConverter()
class Character with EquatableMixin {
  const Character({
    required this.id,
    required this.createDate,
    required this.name,
    this.description,
    this.updateDate,
    this.userDescription,
    this.picture,
    this.pictureState,
  });

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);

  /// This is a document id in Firestore.
  ///
  /// It's not a part of the data model.
  ///
  /// It's used to identify the document in Firestore.
  ///
  /// It's not included in the `toJson` method.
  ///
  /// Must be available in the `fromJson` method
  /// - use [DocumentSnapshotX.dataWithDocId] extension.
  @JsonKey(name: firestoreDocIdKey, includeToJson: false)
  final String id;

  @JsonKey(name: 'create_date')
  final DateTime createDate;

  final String? description;

  final String name;

  final String? picture;

  @JsonKey(name: 'update_date')
  final DateTime? updateDate;

  @JsonKey(name: 'user_description')
  final String? userDescription;

  @JsonKey(name: 'illustrations_state')
  final CharacterPictureState? pictureState;

  Map<String, dynamic> toJson() => _$CharacterToJson(this);

  @override
  List<Object?> get props => [
        id,
        createDate,
        description,
        name,
        picture,
        updateDate,
        userDescription,
      ];
}

enum CharacterPictureState {
  @JsonValue('CHARACTER_IMAGE_GENERATION')
  characterIllustrationGeneration,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('ERROR')
  error,
}
