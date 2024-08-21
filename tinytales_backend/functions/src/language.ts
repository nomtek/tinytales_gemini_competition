import { getFirestore } from "firebase-admin/firestore";

function getLanguageName(code: string, locale = "en") {
  const match = code.match(/^[a-z]{2,3}/i);
  const languageCode = match ? match[0] : locale;

  const displayNames = new Intl.DisplayNames([locale], { type: "language" });
  return displayNames.of(languageCode);
}
const getUserLanguage = async (userId: string) => {
  const userData = (
    await getFirestore().collection("users").doc(userId).get()
  ).data();
  const userLanguage: string = userData?.language || "en";
  //get user by id and get user property language
  return getLanguageName(userLanguage) || "english";
};

export { getUserLanguage };
