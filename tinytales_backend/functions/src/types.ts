interface MainCharacter {
  create_date: Date; // Date/DateTime (mandatory)
  description?: string; // String (optional)
  name: string; // String (mandatory)
  picture?: string; // String (optional)
  update_date?: Date; // Date/DateTime (optional)
  user_description?: string; // String (optional)
}

type TaleTextState =
  | "INPUT_COLLECTION"
  | "TALE_GENERATION"
  | "TALE_REVIEW"
  | "COMPLETED"
  | "ERROR";

type TaleIllustrationsState =
  | "CHARACTER_IMAGE_GENERATION"
  | "CHARACTER_IMAGE_REVIEW"
  | "PAGE_ILUSTRATION_GENERATION"
  | "PAGE_ILUSTRATION_REVIEW"
  | "COMPLETED"
  | "ERROR";

type TaleAudioState =
  | "NO AUDIO"
  | "AUDIO_GENERATION"
  | "AUDIO_REVIEW"
  | "COMPLETED"
  | "ERROR";

enum ValidationStatus {
  Harmful = "Harmful",
  Inappropriate = "Inappropriate",
  Unsuitable = "Unsuitable",
  NeedsImprovement = "Needs Improvement",
  Suitable = "Suitable",
  Excellent = "Excellent",
}
export function isValidStatus(validationStatus: string): boolean {
  const validStatuses = ["Excellent", "Needs Improvement", "Suitable"];
  return validStatuses.includes(validationStatus);
}

export interface LifeValue {
  name: string;
  description: string;
  order: number;
}

export function getValidationStatusString(validationStatus: string): string {
  switch (validationStatus) {
    case ValidationStatus.Harmful:
      return ValidationStatus.Inappropriate;
    case ValidationStatus.Inappropriate:
      return ValidationStatus.Inappropriate;
    case ValidationStatus.Unsuitable:
      return ValidationStatus.Inappropriate;
    case ValidationStatus.NeedsImprovement:
      return ValidationStatus.NeedsImprovement;
    case ValidationStatus.Suitable:
      return ValidationStatus.NeedsImprovement;
    case ValidationStatus.Excellent:
      return ValidationStatus.Excellent;
    default:
      return ValidationStatus.Inappropriate;
  }
}
interface Tale {
  create_date: Date; // Date/DateTime (mandatory)
  main_character_name?: string; // String (optional)
  main_character_description?: string; // String (optional)
  overview?: string; // String (optional) - short description of tale
  picture?: string; // String (optional) - URL to picture
  title: string; // String (mandatory)
  update_date?: Date; // Date/DateTime (optional)
  text_state: TaleTextState;
  illustrations_state?: TaleIllustrationsState;
  audio_state?: TaleAudioState;
  suggestions: string[]; // List<String> (mandatory) - List of suggestions
  full_text?: string; // String (optional) - Full text of tale
  deleted: boolean; // Boolean (mandatory) - Whether the tale is deleted
  storyLength?: string;
}

interface Part {
  audio?: string; // String (optional) - URL to audio file
  picture?: string; // String (optional) - URL to picture file
  text: string; // String (mandatory)
  index: number;
}

interface User {
  name: string;
  main_characters: MainCharacter[];
  tales: Tale[];
  language?: string;
}

interface Proposal {
  plot: string; // String (mandatory) - The plot of the proposal
  title: string;
  create_date: Date; // Date/DateTime (mandatory)
  selected: boolean; // Boolean (mandatory) - Whether the proposal is selected
}

interface Users {
  [key: string]: User;
}
export { MainCharacter, Tale, Part, Users, User, Proposal };
