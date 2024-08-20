import 'package:tale_ai_frontend/story/data/story.dart';

Story aStory({
  String id = 'id',
  DateTime? createDate,
  String title = 'title',
  TextState? textState,
  String mainCharacterName = 'mainCharacter',
  String mainCharacterDescription = 'mainCharacterDescription',
  bool? deleted,
  String? overview,
  String? picture,
  PictureState? pictureState,
  DateTime? updateDate,
  String? pdfUrl,
  String fullText = 'fullText',
  String? audioUrl,
  AudioState? audioState,
}) =>
    Story(
      id: id,
      createDate: createDate ?? DateTime(2024, 7),
      title: title,
      textState: textState ?? TextState.taleReview,
      mainCharacterName: mainCharacterName,
      mainCharacterDescription: mainCharacterDescription,
      overview: overview,
      picture: picture,
      updateDate: updateDate ?? DateTime(2024, 7),
      pictureState: pictureState,
      pdfUrl: pdfUrl,
      deleted: deleted ?? false,
      fullText: fullText,
      audioUrl: audioUrl,
      audioState: audioState,
    );