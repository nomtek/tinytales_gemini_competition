import { GoogleGenerativeAI } from "@google/generative-ai";
import { defineString } from "firebase-functions/params";
import { Storage } from "@google-cloud/storage";
import { getStorage } from "firebase-admin/storage";
import fetch from "node-fetch";
import fs from "fs";
import { DocumentData, getFirestore } from "firebase-admin/firestore";
import Replicate from "replicate";
import { Tale } from "../../types";
import { info } from "firebase-functions/logger";

import os = require("os");
import path = require("path");
import { Param } from "firebase-functions/lib/params/types";

const storage = new Storage();

const replicateApiKey = defineString("REPLICATE_TOKEN");
const geminiApiKey = defineString("GOOGLE_API_KEY");
const firebaseProjectId = defineString("PROJECT_ID");
const defaultPictureUrl = defineString("DEFAULT_PICTURE_URL");
const replicateImageModelId = defineString("REPLICATE_IMAGE_MODEL_ID") as Param<
  `${string}/${string}` | `${string}/${string}:${string}`
>;

const GENERATE_IMAGE_PROMPT = (
  characterName: string,
  characterDescription: string,
  plot: string
) => `Generate a stable diffusion prompt to create an illustration for a bedtime story. The illustration should feature a character named ${characterName}, described as ${characterDescription}.

The plot of the story involves: ${plot}.

Ensure the scene captures a whimsical, fairy-tale atmosphere with vibrant colors, similar to classic children's book illustrations. Please generate only one illustration based on the description provided.
Here are example results:

Create an illustration of a cheerful, adventurous young character named Lily, with curly red hair and freckles, wearing a blue dress with white polka dots. She is holding a magical glowing lantern in a whimsical forest filled with colorful, oversized flowers and friendly woodland creatures. The scene should have a bright, vibrant color palette and a fairy-tale style reminiscent of classic children's book illustrations.

Create an illustration of a cheerful, adventurous young dragon named Lily, with curly red scales and freckle-like spots, soaring over the sky. She has bright blue wings speckled with white. The scene depicts her clutching a magical glowing lantern, casting light over fluffy clouds below. The sky is painted in bright, vibrant hues, creating a whimsical and fairy-tale atmosphere, reminiscent of classic children's book illustrations."
`;

const GENERATE_CHARACTER_IMAGE_PROMPT = (
  characterName: string,
  characterDescription: string
) => `Generate a stable diffusion prompt to create an illustration of a main character for a bedtime story. The illustration should feature a character named ${characterName}, described as ${characterDescription}.

Ensure the character is depicted in a whimsical, fairy-tale atmosphere with vibrant colors, similar to classic children's book illustrations. Please generate only one illustration based on the description provided.
Here are example results:

Create an illustration of a cheerful, adventurous young character named ${characterName}, described as ${characterDescription}. The scene should capture a whimsical and fairy-tale atmosphere with bright, vibrant colors reminiscent of classic children's book illustrations.

Create an illustration of a magical creature named ${characterName}, described as ${characterDescription}. The scene should depict a vibrant and whimsical fairy-tale setting with a bright color palette, similar to classic children's book illustrations."
`;

function getModel({
  maxOutputTokens = 500,
  temperature = 0,
  topP = 0,
  topK = 0,
  candidateCount = 1,
  model = "gemini-1.5-flash",
}) {
  const genAI = new GoogleGenerativeAI(geminiApiKey.value());

  return genAI.getGenerativeModel({
    model: model,
    generationConfig: {
      temperature: temperature,
      maxOutputTokens: maxOutputTokens,
      topP: topP,
      topK: topK,
      candidateCount: candidateCount,
    },
  });
}
const getPrompt = async (name: string, description: string, plot?: string) => {
  const generativeModel = getModel({
    maxOutputTokens: 8192,
    model: "gemini-1.5-flash",
    temperature: 0,
  });

  const resp = await generativeModel.generateContent({
    contents: [
      {
        role: "user",
        parts: [
          {
            text: plot
              ? GENERATE_IMAGE_PROMPT(name, description, plot)
              : GENERATE_CHARACTER_IMAGE_PROMPT(name, description),
          },
        ],
      },
    ],
  });
  if (resp.response.candidates) {
    return resp.response.candidates[0].content.parts[0].text;
  } else {
    throw new Error("No candidates found.");
  }
};

const generateCoverImageAction = async (
  taleId: string,
  uid: string,
  tale: DocumentData
) => {
  const taleRef = getFirestore()
    .collection("users")
    .doc(uid)
    .collection("tales")
    .doc(taleId);

  const proposalsSnapshot = (await taleRef.collection("proposals").get()) || [];
  let plot = "";
  // Iterate over each proposal document
  proposalsSnapshot.forEach((doc) => {
    const proposalData = doc.data();
    if (proposalData.selected) {
      plot = proposalData.plot;
    }
  });

  if (!plot && tale.full_text) {
    plot = tale.full_text;
  }

  const { picture: oldPicture } = (await taleRef.get()).data() as Tale;

  if (oldPicture) {
    try {
      const bucket = storage.bucket(getStorage().bucket().name);
      const filePath = oldPicture.replace(
        `https://storage.googleapis.com/${firebaseProjectId.value()}.appspot.com/`,
        ""
      );
      const fileRef = bucket.file(filePath);

      // Delete the file

      await fileRef.delete();
    } catch (e) {
      info("Failed to delete old picture", e);
    }
  }

  await taleRef.update({
    illustrations_state: "PAGE_ILUSTRATION_GENERATION",
  });

  if (plot) {
    const imageUrl = await generateCoverImage(
      tale.main_character_name,
      tale.main_character_description,
      plot
    );

    const bucket = storage.bucket(getStorage().bucket().name);
    const filePath = `tales/${uid}/${Date.now()}_image.jpg`;
    const tempFilePath = path.join(os.tmpdir(), `${Date.now()}_image.jpg`);

    try {
      // Fetch the image from the URL
      const response = await fetch(imageUrl);
      if (!response.ok) {
        throw new Error(`Failed to fetch image: ${response.statusText}`);
      }

      // Read the image as a Buffer
      const arrayBuffer = await response.arrayBuffer();
      const buffer = Buffer.from(arrayBuffer);

      // Write the buffer to a temporary file
      fs.writeFileSync(tempFilePath, buffer);

      // Upload the file to Firebase Storage
      await bucket.upload(tempFilePath, {
        destination: filePath,
        metadata: {
          metadata: {
            contentType:
              response.headers.get("content-type") ||
              "application/octet-stream",
          },
        },
      });
      // Get the public URL of the uploaded file
      const file = bucket.file(filePath);
      await file.makePublic();
      const publicUrl = `https://storage.googleapis.com/${bucket.name}/${filePath}`;

      // Clean up the temporary file
      fs.unlinkSync(tempFilePath);

      await taleRef.update({
        picture: publicUrl,
        illustrations_state: "COMPLETED",
      });
    } catch (error: unknown) {
      await taleRef.update({
        illustrations_state: "ERROR",
      });
    }
  } else {
    await taleRef.update({
      picture: defaultPictureUrl.value(),
      illustrations_state: "COMPLETED",
    });
  }
};

const generateCharacterImageAction = async (
  characterId: string,
  uid: string,
  { name, description }: { name: string; description: string }
) => {
  // Example custom logic: Update a field in the user's document
  const characterRef = getFirestore()
    .collection("users")
    .doc(uid)
    .collection("main_characters")
    .doc(characterId);

  await characterRef.update({
    illustrations_state: "CHARACTER_IMAGE_GENERATION",
  });
  const imageUrl = await generateCoverImage(name, description);

  const bucket = storage.bucket(getStorage().bucket().name);
  const filePath = `tales/${uid}/${Date.now()}_character_image.jpg`;
  const tempFilePath = path.join(os.tmpdir(), `${Date.now()}_image.jpg`);

  try {
    // Fetch the image from the URL
    const response = await fetch(imageUrl);
    if (!response.ok) {
      throw new Error(`Failed to fetch image: ${response.statusText}`);
    }

    // Read the image as a Buffer
    const arrayBuffer = await response.arrayBuffer();
    const buffer = Buffer.from(arrayBuffer);

    // Write the buffer to a temporary file
    fs.writeFileSync(tempFilePath, buffer);

    // Upload the file to Firebase Storage
    await bucket.upload(tempFilePath, {
      destination: filePath,
      metadata: {
        metadata: {
          contentType:
            response.headers.get("content-type") || "application/octet-stream",
        },
      },
    });
    // Get the public URL of the uploaded file
    const file = bucket.file(filePath);
    await file.makePublic();
    const publicUrl = `https://storage.googleapis.com/${bucket.name}/${filePath}`;

    // Clean up the temporary file
    fs.unlinkSync(tempFilePath);

    await characterRef.update({
      picture: publicUrl,
      illustrations_state: "COMPLETED",
    });
  } catch (error: unknown) {
    await characterRef.update({
      illustrations_state: "ERROR",
    });
  }
};

const generateCoverImage = async (
  characterName: string,
  characterDescription: string,
  plot?: string
) => {
  const replicate = new Replicate({
    auth: replicateApiKey.value(),
  });
  const prompt = await getPrompt(characterName, characterDescription, plot);

  const output = (await replicate.run(replicateImageModelId.value(), {
    input: {
      prompt: prompt,
    },
  })) as unknown;

  //check if image is appropriate for kids

  return output as string;
};

export { generateCoverImageAction, generateCharacterImageAction };
