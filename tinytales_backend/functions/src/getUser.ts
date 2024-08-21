import { getFirestore } from "firebase-admin/firestore";
import { Users, User, MainCharacter, Tale } from "./types";
import {
  userConverter,
  taleConverter,
  mainCharacterConverter,
} from "./firestoreConverter"; // Adjust the path as necessary

interface MainCharacterWithId extends MainCharacter {
  id: string;
}

interface TaleWithId extends Tale {
  id: string;
}

const getUsers = async () => {
  const usersCollection = getFirestore()
    .collection("users")
    .withConverter(userConverter);
  const usersSnapshot = await usersCollection.get();
  const usersList: Users = {};

  for (const doc of usersSnapshot.docs) {
    const userData = doc.data() as Omit<User, "main_characters" | "tales">;
    const mainCharactersSnapshot = await doc.ref
      .collection("main_characters")
      .get();
    const talesSnapshot = await doc.ref.collection("tales").get();

    const mainCharacters: MainCharacterWithId[] =
      mainCharactersSnapshot.docs.map((charDoc) => {
        return {
          ...mainCharacterConverter.fromFirestore(charDoc),
          id: charDoc.id,
        };
      });

    const tales: TaleWithId[] = talesSnapshot.docs.map((taleDoc) => {
      return { ...taleConverter.fromFirestore(taleDoc), id: taleDoc.id };
    });
    usersList[doc.id] = {
      ...userData,
      main_characters: mainCharacters,
      tales,
    };
  }

  return usersList;
};

export { getUsers };
