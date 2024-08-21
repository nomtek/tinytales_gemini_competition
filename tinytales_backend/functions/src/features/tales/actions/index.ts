import { HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import { LifeValue, MainCharacter, Part, Proposal, Tale } from "../../../types";
import {
  generateProposals,
  generateProposalsFromFreeForm,
  generateProposalsFromTale,
  generateStory,
} from "../prompts";
import { getUserLanguage } from "../../../language";

export const createCharacterAction = async (
  name: string,
  description: string,
  userId?: string
) => {
  if (!userId || !name) {
    throw new HttpsError("invalid-argument", "Missing required fields.");
  }

  try {
    const character: MainCharacter = {
      name,
      description,
      create_date: new Date(),
      user_description: description,
    };

    const characterRef = getFirestore()
      .collection("users")
      .doc(userId)
      .collection("main_characters")
      .doc();
    await characterRef.set(character);

    return { characterId: characterRef.id };
  } catch (error) {
    console.error("Error saving character:", error);
    throw new HttpsError("internal", "Failed to save character.");
  }
};

export const createTaleFromProposals = async (
  moral: string,
  characterName: string,
  characterDescription: string,
  proposals: Proposal[],
  chosenProposalIndex: number,
  storyLength: string,
  userId: string | undefined,
  suggestions: string[] | undefined
) => {
  if (
    !userId ||
    !proposals ||
    chosenProposalIndex < 0 ||
    chosenProposalIndex >= proposals.length
  ) {
    throw new HttpsError("invalid-argument", "Missing required fields.");
  }

  const language = await getUserLanguage(userId);

  const tale: Tale = {
    title: proposals[chosenProposalIndex].title,
    main_character_name: characterName ?? "",
    main_character_description: characterDescription ?? "",
    overview: proposals[chosenProposalIndex].plot,
    suggestions: suggestions ?? [],
    create_date: new Date(),
    text_state: "TALE_GENERATION",
    deleted: false,
    storyLength: storyLength,
  };

  const taleRef = getFirestore()
    .collection("users")
    .doc(userId)
    .collection("tales")
    .doc();
  await taleRef.set(tale);

  const batch = getFirestore().batch();
  const proposalIds: string[] = [];

  proposals.forEach((proposal, index) => {
    const newProposal: Proposal = {
      plot: proposal.plot,
      title: proposal.title,
      create_date: new Date(),
      selected: index === chosenProposalIndex,
    };
    const proposalRef = taleRef.collection("proposals").doc();
    batch.set(proposalRef, newProposal);
    proposalIds.push(proposalRef.id);
  });

  try {
    const parts: Part[] = await generateStory(
      moral ?? "",
      characterName ?? "",
      characterDescription ?? "",
      proposals[chosenProposalIndex].plot,
      suggestions ? suggestions : [],
      storyLength,
      language
    );

    if (!parts || parts.length < 2) {
      throw new Error("Failed to generate tale parts. Parts length < 2");
    }
    const indexes = parts.map((part) => part.index);
    if (
      indexes.length !== new Set(indexes).size ||
      indexes.length !== parts.length
    ) {
      throw new Error(
        "Failed to generate tale parts. Parts length is invalid " +
          indexes.length +
          " vs " +
          parts.length
      );
    }

    let text = "";
    parts.forEach((part, index) => {
      text += part.text + (index !== parts.length - 1 ? "\n\n" : "");
    });
    //update status of tale to TALE_GENERATION
    batch.update(taleRef, { text_state: "COMPLETED", full_text: text });

    await batch.commit();

    return { taleId: taleRef.id };
  } catch (error) {
    //set tale status to ERROR if an error occurs
    await taleRef.update({ text_state: "ERROR" });
    throw error;
  }
};

export const generateTaleProposalsAction = async (
  taleDescription: string,
  userId: string | undefined,
  characterName: string | undefined,
  characterDescription: string | undefined,
  suggestions: string[] | undefined
) => {
  //userId, characterName and (taleDescription or suggestions) are required
  if (!userId || !characterName || (!taleDescription && !suggestions)) {
    throw new HttpsError("invalid-argument", "Missing required fields.");
  }

  const language = await getUserLanguage(userId);

  const proposals: Proposal[] = (
    await generateProposals(
      taleDescription,
      characterName,
      characterDescription ?? "",
      suggestions ? suggestions : ["No user suggestions provided"],
      language
    )
  ).map((item) => ({
    plot: item.description,
    title: item.title,
    create_date: new Date(),
    selected: false,
  }));
  try {
    if (!proposals || proposals.length === 0) {
      throw new HttpsError("internal", "Failed to generate tale proposals.");
    }
    return { proposals: proposals };
  } catch (error) {
    throw new HttpsError("internal", "Failed to generate tale proposals.");
  }
};

export const generateProposalsForTaleId = async (
  userId: string | undefined,
  taleId: string | undefined
) => {
  //if userId or taleId is missing throw error
  if (!userId || !taleId) {
    throw new HttpsError("invalid-argument", "Missing required fields.");
  }
  //get the tale from firestore
  const taleRef = getFirestore()
    .collection("users")
    .doc(userId)
    .collection("tales")
    .doc(taleId);
  const taleDoc = await taleRef.get();
  const taleData = taleDoc.data() as Tale;
  if (!taleDoc.exists || !taleData) {
    throw new HttpsError("not-found", "Tale not found.");
  }
  //get tale description, character name and suggestions
  const taleDescription = taleData.full_text;
  const characterName = taleData.main_character_name;
  const characterDescription = taleData.main_character_description;

  if (taleDescription === undefined || characterName === undefined) {
    throw new HttpsError("not-found", "Tale not found.");
  }

  const language = await getUserLanguage(userId);

  const proposals: Proposal[] = (
    await generateProposalsFromTale(
      taleDescription,
      characterName,
      characterDescription,
      language
    )
  ).map((item) => ({
    plot: item.description,
    title: item.title,
    create_date: new Date(),
    selected: false,
  }));

  //if proposals are empty throw error
  if (!proposals || proposals.length === 0) {
    throw new HttpsError("internal", "Failed to generate tale proposals.");
  }
  return { proposals: proposals };
};
export const createFreeFormProposals = async (
  text: string,
  userId: string | undefined
) => {
  //userId and text are required
  if (!userId || !text) {
    throw new HttpsError("invalid-argument", "Missing required fields.");
  }

  const language = await getUserLanguage(userId);

  const proposals: Proposal[] = (
    await generateProposalsFromFreeForm(text, language)
  ).map((item) => ({
    plot: item.description,
    title: item.title,
    characterName: item.characterName,
    characterDescription: item.characterDescription,
    create_date: new Date(),
    selected: false,
  }));

  //if proposals are empty throw error
  if (!proposals || proposals.length === 0) {
    throw new HttpsError("internal", "Failed to generate tale proposals.");
  }
  return { proposals: proposals };
};

export const getLifeValuesByIds = async (ids: string[]) => {
  //get life values from collection life_values by ids and return it as a list

  //if ids is empty return empty list
  if (!ids || ids.length === 0) {
    return [];
  }
  const snapshot = await getFirestore()
    .collection("life_values")
    .where("__name__", "in", ids)
    .get();

  const lifeValues = snapshot.docs.map((doc) => doc.data());
  return lifeValues as LifeValue[];
};
