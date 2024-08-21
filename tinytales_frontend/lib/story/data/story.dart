import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tale_ai_frontend/firebase/firebase.dart';

part 'story.g.dart';

// Same as Tale on Firestore
// But we renamed it to story to follow UI/UX design
// Firebase Firestore data model for a tale (story in app)
@JsonSerializable()
@FirestoreDateTimeConverter()
class Story with EquatableMixin {
  Story({
    required this.id,
    required this.createDate,
    required this.title,
    required this.textState,
    required this.mainCharacterName,
    required this.mainCharacterDescription,
    required this.deleted,
    this.overview,
    this.picture,
    this.pictureState,
    this.updateDate,
    this.pdfUrl,
    this.fullText,
    this.audioUrl,
    this.audioState,
  });

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

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

  @JsonKey(name: 'main_character_name')
  final String mainCharacterName;

  @JsonKey(name: 'main_character_description')
  final String mainCharacterDescription;

  @JsonKey(name: 'overview')
  final String? overview;

  @JsonKey(name: 'picture')
  final String? picture;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'update_date')
  final DateTime? updateDate;

  @JsonKey(name: 'text_state')
  final TextState textState;

  @JsonKey(name: 'illustrations_state')
  final PictureState? pictureState;

  @JsonKey(name: 'pdf')
  final String? pdfUrl;

  final bool deleted;

  @JsonKey(name: 'full_text')
  final String? fullText;

  @JsonKey(name: 'audio')
  final String? audioUrl;

  @JsonKey(name: 'audio_state')
  final AudioState? audioState;

  Map<String, dynamic> toJson() => _$StoryToJson(this);

  @override
  List<Object?> get props => [
        id,
        createDate,
        title,
        textState,
        mainCharacterName,
        mainCharacterDescription,
        overview,
        picture,
        updateDate,
        pictureState,
        fullText,
        pdfUrl,
        deleted,
      ];
}

enum TextState {
  @JsonValue('INPUT_COLLECTION')
  inputCollection,
  @JsonValue('TALE_GENERATION')
  taleGeneration,
  @JsonValue('TALE_REVIEW')
  taleReview,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('ERROR')
  error,
}

enum PictureState {
  @JsonValue('PAGE_ILUSTRATION_GENERATION')
  pageIllustrationGeneration,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('ERROR')
  error,
}

enum AudioState {
  @JsonValue('NO_AUDIO')
  noAudio,
  @JsonValue('AUDIO_GENERATION')
  audioGeneration,
  @JsonValue('AUDIO_REVIEW')
  audioReview,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('ERROR')
  error,
}

// for now not used - still not sure if we need it
enum StoryState {
  // show loading
  generating,
  // text is generated / media like image or audio is being generated.
  // text can be shown to user but media is not ready yet
  generatingMedia,
  // story is fully generated with all media
  finished,
}
