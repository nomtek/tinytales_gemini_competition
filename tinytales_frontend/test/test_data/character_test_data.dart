import 'package:tale_ai_frontend/characters/data/model/character.dart';

Character aCharacter({
  String id = 'id',
  DateTime? createDate,
  String name = 'name',
  String description = 'description',
  DateTime? updateDate,
  String userDescription = 'userDescription',
  String picture = 'picture',
}) =>
    Character(
      id: id,
      createDate: createDate ?? DateTime.utc(2024),
      name: name,
      description: description,
      updateDate: updateDate ?? DateTime.now(),
      userDescription: userDescription,
      picture: picture,
    );
