import { FirestoreDataConverter, Timestamp } from "firebase-admin/firestore";
import { MainCharacter, Tale, User } from "./types";

const convertTimestampToDate = (timestamp: Timestamp): Date => {
  return timestamp.toDate();
};

const userConverter: FirestoreDataConverter<User> = {
  toFirestore(user: User): FirebaseFirestore.DocumentData {
    return {
      name: user.name,
      language: user.language,
    };
  },
  fromFirestore(snapshot: FirebaseFirestore.QueryDocumentSnapshot): User {
    const data = snapshot.data();
    return {
      name: data.name,
      language: data.language,
      main_characters: [],
      tales: [],
    };
  },
};
const mainCharacterConverter: FirestoreDataConverter<MainCharacter> = {
  toFirestore(mainCharacter: MainCharacter): FirebaseFirestore.DocumentData {
    return {
      name: mainCharacter.name,
      description: mainCharacter.description,
      picture: mainCharacter.picture,
      user_description: mainCharacter.user_description,
      create_date: mainCharacter.create_date,
      update_date: mainCharacter.update_date,
    };
  },
  fromFirestore(
    snapshot: FirebaseFirestore.QueryDocumentSnapshot
  ): MainCharacter {
    const data = snapshot.data();
    return {
      name: data.name,
      description: data.description,
      picture: data.picture,
      user_description: data.user_description,
      create_date: convertTimestampToDate(data.create_date),
      update_date: data.update_date
        ? convertTimestampToDate(data.update_date)
        : undefined,
    };
  },
};

const taleConverter: FirestoreDataConverter<Tale> = {
  toFirestore(tale: Tale): FirebaseFirestore.DocumentData {
    return {
      title: tale.title,
      main_character_name: tale.main_character_name,
      main_character_description: tale.main_character_description,
      overview: tale.overview,
      picture: tale.picture,
      create_date: tale.create_date,
      update_date: tale.update_date,
      full_text: tale.full_text,
      deleted: tale.deleted,
      storyLength: tale.storyLength,
    };
  },
  fromFirestore(snapshot: FirebaseFirestore.QueryDocumentSnapshot): Tale {
    const data = snapshot.data();
    return {
      title: data.title,
      main_character_name: data.main_character_name,
      main_character_description: data.main_character_description,
      overview: data.overview,
      picture: data.picture,
      create_date: convertTimestampToDate(data.create_date),
      text_state: data.text_state,
      suggestions: data.suggestions,
      update_date: data.update_date
        ? convertTimestampToDate(data.update_date)
        : undefined,
      full_text: data.full_text,
      deleted: data.deleted,
      storyLength: data.storyLength,
    };
  },
};

export { mainCharacterConverter, taleConverter, userConverter };
