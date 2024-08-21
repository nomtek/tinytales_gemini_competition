import { ElevenLabsClient } from "elevenlabs";
import { getFirestore } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import { defineString } from "firebase-functions/params";
import { HttpsError } from "firebase-functions/v2/https";
import { createWriteStream, unlinkSync } from "fs";
import { Storage } from "@google-cloud/storage";

import os = require("os");
import path = require("path");

const storage = new Storage();

const elevenLabsKey = defineString("ELEVENLABS_API_KEY");
const voiceIdKey = defineString("ELEVEN_LABS_VOICE_ID");

const generateAudio = async (text: string, uid: string) => {
  const elevenlabs = new ElevenLabsClient({
    apiKey: elevenLabsKey.value(),
  });

  const genAudio = (text: string) =>
    new Promise<string>(async (resolve, reject) => {
      try {
        const audio = await elevenlabs.generate(
          {
            voice: voiceIdKey.value(),
            text: text,
            model_id: "eleven_multilingual_v2",
          },
          {
            timeoutInSeconds: 240,
          }
        );
        const tempFilePath = path.join(os.tmpdir(), `${Date.now()}_image.mp3`);

        const fileStream = createWriteStream(tempFilePath);

        audio.pipe(fileStream);

        fileStream.on("finish", () => resolve(tempFilePath));
        fileStream.on("error", reject);
      } catch (error) {
        reject(error);
      }
    });

  try {
    const tempFilePath = await genAudio(text);

    const bucket = storage.bucket(getStorage().bucket().name);
    const filePath = `tales/${uid}/${Date.now()}_audio.mp3`;

    // Upload the file to Firebase Storage
    await bucket.upload(tempFilePath, {
      destination: filePath,
      metadata: {
        metadata: {
          contentType: "application/octet-stream",
        },
      },
    });
    // Get the public URL of the uploaded file
    const file = bucket.file(filePath);
    await file.makePublic();
    const publicUrl = `https://storage.googleapis.com/${bucket.name}/${filePath}`;

    // Clean up the temporary file
    unlinkSync(tempFilePath);

    return publicUrl;
  } catch (error) {
    console.error("Error uploading audio:", error);
    throw error;
  }
};

const generateAudioForTaleAction = async (uid?: string, taleid?: string) => {
  //check if the user is authenticated and tale exists
  if (!uid || !taleid) {
    throw new HttpsError("invalid-argument", "Missing required fields.");
  }

  //get the tale from firestore
  const taleRef = getFirestore()
    .collection("users")
    .doc(uid)
    .collection("tales")
    .doc(taleid);

  const taleDoc = await taleRef.get();
  const taleData = taleDoc.data();
  if (!taleDoc.exists || !taleData) {
    throw new HttpsError("not-found", "Tale not found.");
  }
  const text = taleData.full_text;

  try {
    if (text) {
      await taleRef.update({ audio_state: "AUDIO_GENERATION" });

      const audioUrl = await generateAudio(text, uid);
      if (!audioUrl) {
        throw new HttpsError("internal", "Failed to generate audio.");
      }
      await taleRef.update({ audio: audioUrl, audio_state: "COMPLETED" });
      return audioUrl;
    } else {
      throw new HttpsError(
        "internal",
        "Failed to generate audio. Text is empty."
      );
    }
  } catch (error) {
    await taleRef.update({ audio_state: "ERROR" });
    throw error;
  }
};

export { generateAudioForTaleAction, generateAudio };
