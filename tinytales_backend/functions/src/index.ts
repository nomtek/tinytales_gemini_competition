import { onCall } from "firebase-functions/v2/https";
import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { auth, runWith } from "firebase-functions";
import {
  createCharacterAction,
  generateTaleProposalsAction,
  createTaleFromProposals,
  createFreeFormProposals as createFreeFormProposalsAction,
  generateProposalsForTaleId,
  getLifeValuesByIds,
} from "./features/tales/actions/index.js";
import {
  autoFillMoral as autofillMoralAction,
  autoFillCharacter as autoFillCharacterAction,
  validateCharacter as validateCharacterAction,
  validateMoral as validateMoralAction,
  validateFreeForm as validateFreeFormAction,
} from "./features/tales/prompts/index.js";
import {
  generateCharacterImageAction,
  generateCoverImageAction,
} from "./features/images/index.js";
import {
  MainCharacter,
  Tale,
  getValidationStatusString,
  isValidStatus,
} from "./types.js";
import { generateAudioForTaleAction } from "./features/audio/index.js";
import { getUserLanguage } from "./language.js";
import { createPdf } from "./features/pdf/index.js";

// Initialize Firebase Admin SDK
initializeApp();

export const initializeUser = auth.user().onCreate(async (user) => {
  const userRef = getFirestore().collection("users").doc(user.uid);
  await userRef.set({
    email: user.email,
    displayName: user.displayName,
    photoURL: user.photoURL,
    createdAt: new Date(),
    language: "english",
  });
});

export const createCharacter = onCall(
  { enforceAppCheck: false },
  async (request) => {
    const { name, description } = request.data;
    const userId = request.auth?.uid;

    const result = await createCharacterAction(name, description, userId);
    return result;
  }
);

export const createProposalsForTale = onCall(
  { enforceAppCheck: false },
  async (request) => {
    const { taleId } = request.data;
    const userId = request.auth?.uid;

    const result = await generateProposalsForTaleId(userId, taleId);
    return result;
  }
);

export const createProposals = onCall(
  { enforceAppCheck: false },
  async (request) => {
    const {
      taleDescription,
      characterName,
      characterDescription,
      suggestions,
    } = request.data;
    const userId = request.auth?.uid;

    const taleSuggestions = (await getLifeValuesByIds(suggestions)).map(
      (item) => `${item.name} - ${item.description}`
    );

    const response = await generateTaleProposalsAction(
      taleDescription,
      userId,
      characterName,
      characterDescription,
      taleSuggestions
    );
    const result = {
      ...response,
      proposals: response.proposals.map((p) => ({
        ...p,
        create_date: p.create_date.toISOString(),
      })),
    };

    return result;
  }
);

export const createSimilarTale = onCall(
  { enforceAppCheck: false },
  async (request) => {
    const { taleId, proposals, chosenProposalIndex } = request.data;
    const userId = request.auth?.uid;

    if (!userId) {
      throw new Error("User not authenticated");
    }
    if (!taleId) {
      throw new Error("Tale id not provided");
    }

    const taleRef = getFirestore()
      .collection("users")
      .doc(userId)
      .collection("tales")
      .doc(taleId);
    const taleDoc = await taleRef.get();
    if (!taleDoc.exists || !taleDoc.data()) {
      throw new Error("Tale not found");
    }

    const taleData = taleDoc.data() as Tale;
    if (!taleDoc.exists || !taleData) {
      throw new Error("Tale not found.");
    }
    const characterName = taleData.main_character_name ?? "";
    const characterDescription = taleData.main_character_description ?? "";

    const storyLength = taleData.storyLength ?? "medium";

    const result = await createTaleFromProposals(
      "",
      characterName,
      characterDescription,
      proposals,
      chosenProposalIndex,
      storyLength,
      userId,
      []
    );

    return result;
  }
);

export const createTale = onCall(
  { enforceAppCheck: false },
  async (request) => {
    const {
      moral,
      characterName,
      characterDescription,
      proposals,
      chosenProposalIndex,
      storyLength,
      suggestions,
    } = request.data;
    const userId = request.auth?.uid;

    const taleSuggestions = (await getLifeValuesByIds(suggestions)).map(
      (item) => `${item.name} - ${item.description}`
    );
    const result = await createTaleFromProposals(
      moral,
      characterName,
      characterDescription,
      proposals,
      chosenProposalIndex,
      storyLength ?? "medium",
      userId,
      taleSuggestions
    );
    return result;
  }
);

export const autofillCharacter = onCall(
  { enforceAppCheck: false },
  async (request) => {
    const { name, description } = request.data;

    const userId = request.auth?.uid;
    if (!userId) {
      throw new Error("User not authenticated");
    }

    const userCharacters = await getFirestore()
      .collection("users")
      .doc(userId)
      .collection("main_characters")
      .get();

    const pastCharacters = userCharacters.docs.map((doc) => doc.data());

    const language = await getUserLanguage(userId);
    const newCharacter = await autoFillCharacterAction(
      name,
      description,
      language,
      pastCharacters.map((c) => c.name + " - " + c.description)
    );

    return newCharacter;
  }
);

export const autofillMoral = onCall(
  { enforceAppCheck: false },
  async (request) => {
    const { description } = request.data;

    const userId = request.auth?.uid;
    if (!userId) {
      throw new Error("User not authenticated");
    }
    const language = await getUserLanguage(userId);
    const newMoral = await autofillMoralAction(description, language);
    return newMoral;
  }
);

export const validateMoral = onCall(
  { enforceAppCheck: false },
  async (request) => {
    const { description } = request.data;

    const userId = request.auth?.uid;
    if (!userId) {
      throw new Error("User not authenticated");
    }
    const language = await getUserLanguage(userId);

    const validation = await validateMoralAction(description, language);

    let validationStatus = getValidationStatusString(
      validation.validationStatus
    );

    if (
      validationStatus === "Needs Improvement" &&
      !validation.suggestedVersion?.content
    ) {
      validationStatus = "Excellent";
    }

    return {
      message: validation.message,
      valid: isValidStatus(validationStatus),
      validationStatus: validationStatus,
      suggestedVersion: {
        content: validation.suggestedVersion?.content,
      },
    };
  }
);

export const validateCharacter = onCall(
  { enforceAppCheck: false },
  async (request) => {
    const { description, name } = request.data;

    const validation = await validateCharacterAction(name, description);

    let validationStatus = getValidationStatusString(
      validation.validationStatus
    );

    if (
      validationStatus === "Needs Improvement" &&
      !validation.suggestedVersion?.content
    ) {
      validationStatus = "Excellent";
    }

    return {
      message: validation.message,
      valid:
        validationStatus === "Excellent" ||
        validationStatus === "Needs Improvement",
      validationStatus: validationStatus,
      suggestedVersion: {
        name: validation.suggestedVersion?.name,
        description: validation.suggestedVersion?.description,
      },
    };
  }
);

export const validateFreeForm = onCall(
  { enforceAppCheck: false },
  async (request) => {
    const { text } = request.data;
    const validation = await validateFreeFormAction(text);
    let validationStatus = getValidationStatusString(
      validation.validationStatus
    );

    if (
      validationStatus === "Needs Improvement" &&
      !validation.suggestedVersion?.content
    ) {
      validationStatus = "Excellent";
    }

    return {
      message: validation.message,
      valid: isValidStatus(validationStatus),
      validationStatus: validationStatus,
      suggestedVersion: {
        content: validation.suggestedVersion?.content,
      },
    };
  }
);

export const freeForm = onCall(
  {
    enforceAppCheck: false,
  },
  async (request) => {
    const { text } = request.data;
    const userId = request.auth?.uid;

    const result = await createFreeFormProposalsAction(text, userId);
    return result;
  }
);

//regenerate cover image for tale
export const regenerateCoverImage = onCall(
  {
    enforceAppCheck: false,
    timeoutSeconds: 540,
  },
  async (request) => {
    const { taleId } = request.data;
    const userId = request.auth?.uid;

    if (!userId) {
      throw new Error("User not authenticated");
    }
    if (!taleId) {
      throw new Error("Tale id not provided");
    }
    //check if tale exists
    const taleRef = getFirestore()
      .collection("users")
      .doc(userId)
      .collection("tales")
      .doc(taleId);
    const taleDoc = await taleRef.get();
    if (!taleDoc.exists) {
      throw new Error("Tale not found");
    }
    const tale = taleDoc.data();
    if (!tale) {
      throw new Error("Tale not found");
    }
    return generateCoverImageAction(taleId, userId, tale);
  }
);

export const regenerateCharacterImage = onCall(
  {
    enforceAppCheck: false,
    timeoutSeconds: 540,
  },
  async (request) => {
    const { characterId } = request.data;
    const userId = request.auth?.uid;

    if (!userId) {
      throw new Error("User not authenticated");
    }
    if (!characterId) {
      throw new Error("Tale id not provided");
    }
    //check if tale exists
    const taleRef = getFirestore()
      .collection("users")
      .doc(userId)
      .collection("main_characters")
      .doc(characterId);
    const characterDoc = await taleRef.get();
    if (!characterDoc.exists) {
      throw new Error("Tale not found");
    }

    const characterData = characterDoc.data() as MainCharacter;

    return generateCharacterImageAction(characterId, userId, {
      name: characterData.name,
      description: characterData.description ?? "",
    });
  }
);

export const onTaleStateChange = runWith({
  timeoutSeconds: 540,
})
  .firestore.document("users/{uid}/tales/{id}")
  .onUpdate(async (change, context) => {
    const beforeData = change.before.data(); // Data before the update
    const afterData = change.after.data(); // Data after the update

    // Define a timeout promise
    const timeoutPromise = new Promise(
      (_, reject) =>
        setTimeout(() => reject(new Error("Function timed out")), 530 * 1000) // 530 seconds
    );

    // Define the main function logic
    const mainLogic = async () => {
      // Check if the state has changed to "COMPLETED"
      if (
        beforeData.text_state !== "COMPLETED" &&
        afterData.text_state === "COMPLETED"
      ) {
        const uid = context.params.uid;
        const taleId = context.params.id;
        await generateCoverImageAction(taleId, uid, afterData);
      }
    };

    try {
      // Execute the main logic with a race against the timeout
      await Promise.race([mainLogic(), timeoutPromise]);
    } catch (error) {
      if ((error as Error).message === "Function timed out") {
        // Custom logic for handling timeout
        console.error("Function timed out. Executing custom logic.");
        const uid = context.params.uid;
        const taleId = context.params.id;

        const taleRef = getFirestore()
          .collection("users")
          .doc(uid)
          .collection("tales")
          .doc(taleId);
        taleRef.update({
          illustrations_state: "ERROR",
        });
      } else {
        // Handle other errors
        console.error("An error occurred:", error);
      }
    }

    return null;
  });

export const onCharacterCreate = runWith({
  timeoutSeconds: 540,
})
  .firestore.document("users/{uid}/main_characters/{id}")
  .onCreate(async (change, context) => {
    const data = change.data() as MainCharacter;
    const uid = context.params.uid;
    const characterId = context.params.id;

    // Define a timeout promise
    const timeoutPromise = new Promise(
      (_, reject) =>
        setTimeout(() => reject(new Error("Function timed out")), 530 * 1000) // 530 seconds
    );

    // Define the main function logic
    const mainLogic = async () => {
      if (data.name && data.description) {
        await generateCharacterImageAction(characterId, uid, {
          name: data.name,
          description: data.description,
        });
      }
    };

    try {
      // Execute the main logic with a race against the timeout
      await Promise.race([mainLogic(), timeoutPromise]);
    } catch (error) {
      if ((error as Error).message === "Function timed out") {
        // Custom logic for handling timeout
        console.error("Function timed out. Executing custom logic.");
        //update status to ERROR
        const characterRef = getFirestore()
          .collection("users")
          .doc(uid)
          .collection("main_characters")
          .doc(characterId);

        await characterRef.update({
          illustrations_state: "ERROR",
        });
      } else {
        // Handle other errors
        console.error("An error occurred:", error);
      }
    }

    return null;
  });
//getVoices onCall function
export const createAudioForTale = onCall(
  { enforceAppCheck: false, timeoutSeconds: 540 },
  async (request) => {
    const uid = request.auth?.uid;
    const taleId = request.data.taleId;

    if (!uid) {
      throw new Error("User not authenticated");
    }
    if (!taleId) {
      throw new Error("Tale id not provided");
    }

    // Define a timeout promise
    const timeoutPromise = new Promise(
      (_, reject) =>
        setTimeout(() => reject(new Error("Function timed out")), 530 * 1000) // 530 seconds
    );

    // Define the main function logic
    const mainLogic = async () => {
      return generateAudioForTaleAction(uid, taleId);
    };

    try {
      // Execute the main logic with a race against the timeout
      return await Promise.race([mainLogic(), timeoutPromise]);
    } catch (error) {
      if ((error as Error).message === "Function timed out") {
        // Custom logic for handling timeout
        console.error("Function timed out. Executing custom logic.");
        //update status to ERROR
        const taleRef = getFirestore()
          .collection("users")
          .doc(uid)
          .collection("tales")
          .doc(taleId);
        taleRef.update({
          audio_state: "ERROR",
        });
      } else {
        // Handle other errors
        console.error("An error occurred:", error);
      }
    }

    return null;
  }
);

export const createPdfForTale = onCall(
  { enforceAppCheck: false },
  async (request) => {
    // Example usage
    if (!request.auth?.uid) {
      throw new Error("User not authenticated");
    }

    const uid = request.auth?.uid;
    const taleId = request.data.taleId;

    //update tale by adding the pdf url
    const taleRef = getFirestore()
      .collection("users")
      .doc(uid)
      .collection("tales")
      .doc(taleId);

    //get tale title
    const taleDoc = await taleRef.get();
    if (!taleDoc.exists) {
      throw new Error("Tale not found");
    }
    const taleData = taleDoc.data();
    if (!taleData) {
      throw new Error("Tale data not found");
    }
    const title = taleData.title;
    const photoPath = taleData.picture;

    const text = taleData.full_text;

    const url = await createPdf(title, photoPath, text, uid);

    await taleRef.update({ pdf: url });

    return url;
  }
);
