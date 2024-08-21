import { createCharacterAction } from "../features/tales/actions";
import firebaseFunctionsTest from "firebase-functions-test";

const test = firebaseFunctionsTest();

jest.mock("firebase-admin/firestore", () => {
  const mFirestore = {
    collection: jest.fn().mockReturnThis(),
    doc: jest.fn().mockReturnThis(),
    set: jest.fn().mockResolvedValue(undefined),
    batch: jest.fn().mockReturnThis(),
    commit: jest.fn().mockResolvedValue(undefined),
  };
  return { getFirestore: jest.fn(() => mFirestore) };
});

describe("createCharacterAction", () => {
  afterAll(() => {
    test.cleanup();
  });

  it("should create a character successfully", async () => {
    const result = await createCharacterAction(
      "Test Name",
      "Test Description",
      "userId123"
    );
    expect(result).toHaveProperty("characterId");
  });

  it("should throw an error if required fields are missing", async () => {
    await expect(
      createCharacterAction("", "Test Description", "userId123")
    ).rejects.toThrow("Missing required fields.");
  });
});
