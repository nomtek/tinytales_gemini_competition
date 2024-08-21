import { parse } from "best-effort-json-parser";
import {
  GenerateContentResult,
  GoogleGenerativeAI,
  HarmBlockThreshold,
  HarmCategory,
} from "@google/generative-ai";
import { defineString } from "firebase-functions/params";
import { HttpsError } from "firebase-functions/v2/https";
import { z } from "zod";

const AUTOFILL_CHARACTER = (
  name: string,
  description: string,
  pastCharacters: string[]
) => `
You are a creative AI specializing in character design for children's stories. Based on the information provided by the user, generate a detailed description of the main character for a children's story. The character should be engaging, relatable, and suitable for children aged 4-8. Include details about the character's appearance, personality, and any special abilities or traits.

User Information:
- Name: ${name}
- Description: ${description}

Past Characters: ${JSON.stringify(pastCharacters)}

Please generate a detailed description of the main character based on the above information. The description should be concise, with a maximum of 3-4 sentences. Ensure the new character is unique and does not repeat any of the past characters.

If no suggestions are provided, create the character from scratch.

Use this JSON schema:
Character = {
  "name": "string",
  "description": "string"
}

Return a 'Character'.

Examples:
{
    "name": "Pip the Penguin",
    "description": "Pip is a small and curious penguin with bright blue feathers and a cheerful orange beak.  He loves exploring the icy landscape and making new friends – especially with the jellyfish who float by his home in the ocean."
  }


{
"description": "Bob is a bright yellow baby bulldozer with a wide, toothy grin. Though small, he has a very strong and sturdy frame with oversized wheels painted an electric blue. His favorite thing in the world (apart from helping with big projects) is being read stories; in particular, tales about  brave knights and fantastic creatures! Bob is always kind, confident, willing to help, and never lets little obstacles get in his way!",
"name": "Bob"
}

{
"name": "Zoja",
"description": "Zoja is a sprightly firefly with shimmering green wings and big, curious eyes. No matter what challenges she faces, her heart is overflowing with bravery.  Zoja  loves exploring the night sky with her friends, using  her special glow to light up the world around her, never backing down from darkness, she uses her bright light to share bravery  making friends throughout"
}

{
"name":"Robert",
"description": "Robert to jasnożółta i czerwona koparka z uśmiechniętą buźką. Jego duża łyżka z łatwością nabiera ziemię, a dwa wytrzymałe koła zawsze zapewniają mu równowagę i stabilność. Nawet ciężko pracująca maszyna do kopania nie może się doczekać nauki nowych sztuczek w piaskownicy! Czeka go o wiele więcej przygód!"
}

{
"name": "Sówka Olek",
"description":"Olek to ciekawa, mała sówka z dużymi, okrągłymi oczami i miękkimi, brązowymi piórami. Pomimo swoich niewielkich rozmiarów, jest nieustraszonym poszukiwaczem przygód, który zawsze stara się nauczyć czegoś nowego. Jedną z jego ulubionych rzeczy jest latanie po nocnym niebie i odkrywanie świata w świetle gwiazd i księżyca"
}

`;

const AUTOFILL_MORAL = `You are a creative writer specializing in children's literature.
 Generate a moral for a bedtime story. The moral should be clear, meaningful, and suitable for young children.
 If the provided suggestion violates appropriateness norms or is unsuitable for children, suggest a new moral that maintains the spirit of the input but is appropriate. If no suggestion is provided, create it from scratch.
Using this JSON schema: Motto = {"description": "string"} Return a 'Motto'

Examples:
 {
    "description": "Always listen to your heart, but also consider the advice of trusted adults."
  }

{
    "description": "It's okay to be different. Everyone has special talents and qualities that make them unique."
  }

    {
    "description": "Sharing your toys helps you make friends and have fun together."
  }

  {
  "description": "It's important to stand up to bullies, but always seek help from a trusted adult."
  }

  {
  "description":"Always tell the truth, because honesty builds trust."
  }
`;

const GET_PROPOSALS_FROM_TALE = (
  characterName: string,
  characterDescription: string | undefined,
  story: string
) => `
You are an imaginative and creative AI. Generate 3 unique kids' story proposals based on the following information provided by the user. Each story should be engaging, educational, and suitable for children aged 4-8. Include a brief description of the main characters, setting, and the central theme or lesson of each story.

User Information:
- Main character: ${characterName} - ${characterDescription} 
- Existing story for the universe: ${story}

Please generate 3 different story proposals based on the above information. Each proposal should be unique and imaginative but set in the same universe as the provided story. Use the same main characters, setting, and style to create new adventures that expand on the original narrative.

 Using this JSON schema: Proposal = {"description":str, "title":str, } Return a 'list[Proposal]'

 Examples:
[
 {
 "title":"Zoja's Dimmer Glow",
 "description":"Zoja, the brave firefly, discovers that her glow isn't as bright as it used to be. Feeling disheartened, she struggles to light the way for her friends on their nighttime adventures. With the encouragement of her friends and a little bit of magic from a wise old owl, Zoja learns that her light, while dimmer, can still bring joy to others. By focusing on the good and sharing her remaining light, Zoja realizes that true bravery lies in knowing your strengths and helping others in any way you can. This story teaches children the value of staying positive even when facing challenges and the power of sharing your strengths to help those around you."
},
 {
 "title":"Zoja and the Dewdrop Collection",
 "description":"Zoja and her friends are tasked with collecting shimmering dew drops from the tall blades of grass to fuel the magical glow of the moon. However, a grumpy caterpillar named Chester refuses to cooperate, believing the task is pointless. Zoja patiently explains how the moon's glow helps everyone in the garden; from the sleepy flowers to the hungry little beetles. Chester, touched by Zoja's kindness and the importance of the moon's light, decides to lend a helping hand, joining the team to collect the dew drops. 'Zoja and the Dewdrop Collection' celebrates cooperation and teamwork. It teaches children that uniting their efforts can lead to beautiful results and solve even the most challenging problems."
},
 {
 "title":"Zoja and Lily's Faded Spots",
 "description":"Zoja meets a shy little ladybug named Lily who can't fly because her spots are too faded. Lily feels different and is afraid to join the other ladybugs. With her bright, friendly glow, Zoja encourages Lily to overcome her fear and show everyone how unique and beautiful her faded spots are. Zoja explains that everyone is special in their way, and that true beauty comes from embracing our differences. This story encourages children to celebrate each other's uniqueness and reject prejudice, teaching them the importance of respect and inclusion."
}
]

[
{
"title":"Pip's Northern Lights Adventure",
"description":"Pip the Penguin longs to see the fabled Northern Lights. He hears stories from older penguins, but they say the journey is long and dangerous. Pip sets off anyway, determined to see this dazzling spectacle. He learns about the importance of perseverance and courage, and discovers that even the scariest challenges can be overcome with a little help from friends. This story highlights the importance of pushing your limits and the value of friendships. The story follows Pip's journey around the icy landscape where he meets new animal friends and discovers secrets about the Northern Lights. "
},
{
"title":"Pip's Pebble Mosaic",
"description":"Pip the Penguin loves collecting colorful pebbles from the beach. One day, he has a brilliant idea - he wants to create a giant mosaic for all his friends to admire. However, he realizes that taking too many pebbles could upset the delicate balance of the beach ecosystem. With the help of a wise old seagull, Pip learns the importance of respecting nature and using resources responsibly. He understands that true beauty lies in appreciating the natural world, and that even small actions can have a big impact."
},
{
"title":"Pip's Flying Dream",
"description":"Pip the Penguin dreams of flying, just like the albatrosses. He tries everything he can think of: flapping his wings, building a makeshift glider, even jumping from a snowy cliff! Pip encounters many setbacks and is tempted to give up. However, he ultimately learns that while he may not be able to fly like the albatrosses, he can achieve his own unique dreams through hard work and perseverance. The story encourages children to find their own path and embrace their individuality, learning that true success comes from pursuing what makes them joyful. The story is filled with fun, imaginative sequences as Pip explores various ways to fly, featuring humorous mishaps and supportive animal friends."
}
]

 
 `;

const GET_PROPOSALS_FROM_FREE_FORM = (freeForm: string) => `
You are an imaginative and creative AI. Generate 4 unique kids' story proposals based on the following information provided by the user. Each story should be engaging, educational, and suitable for children aged 4-8. 
Include a brief description of the main characters, setting, and the central theme or lesson of each story.

User Information:
- Desired themes or lessons: ${freeForm}

Please generate 3 different story proposals based on the above information. Each proposal should be unique and imaginative, suitable for young children. Use the provided moral, character name, and description to create the stories.
Use this JSON schema for each proposal:
Proposal = {
  "title": "string",
  "description": "string",
  "characterName": "string",
  "characterDescription": "string"
}

Return a list of 3 proposals in the following format: 
list[Proposal]

Example:
[
{
 "title":"Bob the Cat and the Rainbow Yarn",
 "description":"Bob the cat discovers a magical ball of yarn that changes colors when he plays with it.  He learns that imagination and creativity can turn ordinary things into something extraordinary, even if they're just playing with yarn.",
  "characterName":"Bob",
  "characterDescription":"A playful and curious cat who loves yarn and butterflies."
},
{
 "title":"The Butterfly Chase: A Garden Adventure",
 "description":"Bob the cat embarks on a grand adventure chasing butterflies through the garden. He learns about the importance of perseverance and the joy of exploring the natural world.",
  "characterName":"Bob",
  "characterDescription":"A playful and curious cat who loves yarn and butterflies."
},
{
 "title":"Bob's Yarnball Surprise",
 "description":"Bob the cat accidentally loses his favorite yarnball. He sets out to find it, learning about the importance of being responsible for his belongings.  Along the way, he finds a new friend, a little girl who helps him look for his lost treasure.",
  "characterName":"Bob",
  "characterDescription":"A playful and curious cat who loves yarn and butterflies."
},
]

`;

const GET_PROPOSALS = (
  characterName: string,
  characterDescription: string,
  moral: string,
  suggestions: string
) => `
You are an imaginative and creative AI. Generate 3 unique kids' story proposals based on the following information provided by 
the user. Each story should be engaging, educational, and suitable for children aged 4-8. 
Include a brief description of the main characters, setting, and the central theme or lesson of each story.

User Information:
- Main character: ${characterName} - ${characterDescription} 
- Desired themes or lessons: ${moral} / ${suggestions}

Please generate 3 dfferent story proposals based on the above information.
 Generate 3 different proposals for a bedtime story based on the following details. Each proposal should be unique and imaginative, suitable for young children. Use the provided moral, character name, and description to create the stories.
 Using this JSON schema: Proposal = {"description":str, "title":str, } Return a 'list[Proposal]'
 
  Examples:
[
 {
 "title":"Zoja's Dimmer Glow",
 "description":"Zoja, the brave firefly, discovers that her glow isn't as bright as it used to be. Feeling disheartened, she struggles to light the way for her friends on their nighttime adventures. With the encouragement of her friends and a little bit of magic from a wise old owl, Zoja learns that her light, while dimmer, can still bring joy to others. By focusing on the good and sharing her remaining light, Zoja realizes that true bravery lies in knowing your strengths and helping others in any way you can. This story teaches children the value of staying positive even when facing challenges and the power of sharing your strengths to help those around you."
},
 {
 "title":"Zoja and the Dewdrop Collection",
 "description":"Zoja and her friends are tasked with collecting shimmering dew drops from the tall blades of grass to fuel the magical glow of the moon. However, a grumpy caterpillar named Chester refuses to cooperate, believing the task is pointless. Zoja patiently explains how the moon's glow helps everyone in the garden; from the sleepy flowers to the hungry little beetles. Chester, touched by Zoja's kindness and the importance of the moon's light, decides to lend a helping hand, joining the team to collect the dew drops. 'Zoja and the Dewdrop Collection' celebrates cooperation and teamwork. It teaches children that uniting their efforts can lead to beautiful results and solve even the most challenging problems."
},
 {
 "title":"Zoja and Lily's Faded Spots",
 "description":"Zoja meets a shy little ladybug named Lily who can't fly because her spots are too faded. Lily feels different and is afraid to join the other ladybugs. With her bright, friendly glow, Zoja encourages Lily to overcome her fear and show everyone how unique and beautiful her faded spots are. Zoja explains that everyone is special in their way, and that true beauty comes from embracing our differences. This story encourages children to celebrate each other's uniqueness and reject prejudice, teaching them the importance of respect and inclusion."
}
]

[
{
"title":"Pip's Northern Lights Adventure",
"description":"Pip the Penguin longs to see the fabled Northern Lights. He hears stories from older penguins, but they say the journey is long and dangerous. Pip sets off anyway, determined to see this dazzling spectacle. He learns about the importance of perseverance and courage, and discovers that even the scariest challenges can be overcome with a little help from friends. This story highlights the importance of pushing your limits and the value of friendships. The story follows Pip's journey around the icy landscape where he meets new animal friends and discovers secrets about the Northern Lights. "
},
{
"title":"Pip's Pebble Mosaic",
"description":"Pip the Penguin loves collecting colorful pebbles from the beach. One day, he has a brilliant idea - he wants to create a giant mosaic for all his friends to admire. However, he realizes that taking too many pebbles could upset the delicate balance of the beach ecosystem. With the help of a wise old seagull, Pip learns the importance of respecting nature and using resources responsibly. He understands that true beauty lies in appreciating the natural world, and that even small actions can have a big impact."
},
{
"title":"Pip's Flying Dream",
"description":"Pip the Penguin dreams of flying, just like the albatrosses. He tries everything he can think of: flapping his wings, building a makeshift glider, even jumping from a snowy cliff! Pip encounters many setbacks and is tempted to give up. However, he ultimately learns that while he may not be able to fly like the albatrosses, he can achieve his own unique dreams through hard work and perseverance. The story encourages children to find their own path and embrace their individuality, learning that true success comes from pursuing what makes them joyful. The story is filled with fun, imaginative sequences as Pip explores various ways to fly, featuring humorous mishaps and supportive animal friends."
}
]
 `;

const GET_STORY = `You are a creative writer specializing in children's literature. Generate a bedtime story for a kid based on the following details. The story should be divided into pages, with each page containing a part of the story. Use the provided character name, character description, moral, and plot proposal to create the story.
 Using this JSON schema: Parts = {"text":str, "page":int,  } Return a 'list[Parts]


 '`;

const VALIDATE_MORAL = (moral: string, language: string) => `
 You are an AI responsible for validating whether the provided content description (moral, plot, or story content) is appropriate for children. The content should be positive, educational, and free from any harmful or inappropriate elements unsuitable for young children. Ignore the language used; focus only on the suitability of the content.
Your task is to check the user-provided content description, which is in ${language}, and determine if it is appropriate for children.

User-Provided Content Description:
- Content Description: ${moral}
 
If valid is true, the content is not harmful and is suitable for children. If valid is false, the content is harmful or not suitable for children.

Validation Status Enum:
- "Harmful": The content is harmful and not suitable for children.
- "Inappropriate": The content contains inappropriate elements but may not be overtly harmful.
- "Unsuitable": The content is not harmful or inappropriate but is not suitable for the target age group.
- "Needs Improvement": The content is vague or unspecific and needs improvement to be fully suitable. Obligatory: Provide a suggested improved version.
- "Suitable": The content is suitable for children but could be more engaging or detailed.
- "Excellent": The content is highly suitable and well-crafted for the target age group.

Return the validation result using the following JSON schema:
{
  "message": "string",
  "valid": "boolean",
  "validationStatus": "enum ('Harmful', 'Inappropriate', 'Unsuitable', 'Needs Improvement', 'Suitable', 'Excellent')",
  "suggestedVersion": {
    "content": "string (if validationStatus is 'Needs Improvement', in ${language}, without specific character information)"
  }
}

Message should be a short explanation, ideally one sentence, why the content is or is not suitable for children, and if applicable, provide a suggested improved version. The suggested improved version should be directly applicable as input without any introductory phrases or instructions and should not contain specific character information. Return a 'Validation' object.

Examples:
{
  "message": "The moral is too complex for young children to understand.",
  "valid": true,
  "validationStatus": "Needs Improvement",
  "suggestedVersion": {
    "content": "It's important to be kind to others and help those in need."
  }
}

{
  "message":"The moral is positive and suitable for children.",
  "valid": true,
  "validationStatus": "Needs Improvement",
  "suggestedVersion": {
    "content": "Bajka o małym chłopcu imieniem Wojtek, który pomagał swojej babci w ogrodzie i odkrył magiczne truskawki. Każda truskawka dawała mu inną supermoc! Jedna pozwalała mu skakać jak żaba, inna biegać szybciej niż wiatr! Jakie supermoce dałyby Wojtkowi pozostałe truskawki?"
}
}

{
  "message": "The moral is positive and suitable for children.",
  "valid": true,
  "validationStatus": "Excellent"
}

{
  "message": "The moral is positive but could be more engaging for children.",
  "valid": true,
  "validationStatus": "Suitable",
  "suggestedVersion": {
    "content": "It's important to be kind to others and help those in need. When we share with others, we make everyone happy."
  }
}

{
  "message": "The moral is inappropriate for young children.",
  "valid": false,
  "validationStatus": "Inappropriate"
}




`;

const VALIDATE_FREE_FORM = (content: string) => `
You are an AI responsible for validating whether the provided free-form content is appropriate for children aged 4-8. The content should be positive, educational, and free from any harmful or inappropriate elements unsuitable for young children. Ignore the language used; focus only on the suitability of the content.
Your task is to check the user-provided free-form content and determine if it is appropriate for generating children's content.

User-Provided Free-Form Content:
- Content: ${content}

If valid is true, the content is not harmful and is suitable for children. If valid is false, the content is harmful or not suitable for children.

Validation Status Enum:
- "Harmful": The content is harmful and not suitable for children.
- "Inappropriate": The content contains inappropriate elements but may not be overtly harmful.
- "Unsuitable": The content is not harmful or inappropriate but is not suitable for the target age group.
- "Needs Improvement": The content is vague or unspecific and needs improvement to be fully suitable. Provide a suggested improved version.
- "Suitable": The content is suitable for children but could be more engaging or detailed.
- "Excellent": The content is highly suitable and well-crafted for the target age group.

Return the validation result using the following JSON schema:
{
  "message": "string",
  "valid": "boolean",
  "validationStatus": "enum ('Harmful', 'Inappropriate', 'Unsuitable', 'Needs Improvement', 'Suitable', 'Excellent')",
  "suggestedVersion": {
    "content": "string (if validationStatus is 'Needs Improvement')"
  }
}

Message should be a short explanation, ideally one sentence, why the content is or is not suitable for children, and if applicable, provide a suggested improved version. Return a 'Validation' object.
Examples:
{
  "message": "The moral is too complex for young children to understand.",
  "valid": true,
  "validationStatus": "Needs Improvement",
  "suggestedVersion": {
    "content": "Zenek loves to eat pancakes! He thinks they're the best breakfast ever. What's your favorite breakfast food?"
  }
}

{
  "message": "The moral is positive and suitable for children.",
  "valid": true,
  "validationStatus": "Excellent"
}

{
  "message": "The moral is positive but could be more engaging for children.",
  "valid": true,
  "validationStatus": "Suitable",
  "suggestedVersion": {
    "content": "Helping others is a wonderful thing to do! It makes everyone feel good. What's something kind you've done for someone else?"
  }
}

{
  "message": "The moral is inappropriate for young children.",
  "valid": false,
  "validationStatus": "Inappropriate"
}




`;

const VALIDATE_CHARACTER = (name: string, description: string) => `
You are an AI responsible for validating whether a character description is appropriate for children aged 4-8. The character should be age-appropriate, free from any elements that could cause distress or fear, and should align with positive values suitable for young children. Ignore the language used; focus only on the suitability of the content.
Your task is to check the user-provided character name and description to determine if it is appropriate for children.

User-Provided Character Description:
- Character name: ${name}
- Character description: ${description}

If valid is true, the character is not harmful and is suitable for children. If valid is false, the character is harmful or not suitable for children.

Validation Status Enum:
- "Harmful": The character is harmful and not suitable for children.
- "Inappropriate": The character contains inappropriate elements but may not be overtly harmful.
- "Unsuitable": The character is not harmful or inappropriate but is not suitable for the target age group.
- "Needs Improvement": The character description is vague or unspecific and needs improvement to be fully suitable. Provide a suggested improved version.
- "Suitable": The character is suitable for children but could be more engaging or detailed.
- "Excellent": The character is highly suitable and well-crafted for the target age group.

Return the validation result using the following JSON schema:
{
 "message": "string",
 "valid": "boolean",
 "validationStatus": "enum ('Harmful', 'Inappropriate', 'Unsuitable', 'Needs Improvement', 'Suitable', 'Excellent')",
 "suggestedVersion": {
  "name": "string (if validationStatus is 'Needs Improvement')",
  "description": "string (if validationStatus is 'Needs Improvement')"
 }
}

Message should be a short explanation, ideally one sentence, why the character is or is not suitable for children, and if applicable, provide a suggested improved version. Return a 'Validation' object.
Examples:
{
 "message": "This character is highly suitable and well-crafted for young children.",
 "valid": true,
 "validationStatus": "Excellent",
 "suggestedVersion": {
  }
}

{
 "message": "The character is suitable for children.",
 "valid": true,
 "validationStatus": "Suitable",
 "suggestedVersion": {
   "name": "Pip the Penguin",
  "description": "Pip is a small and curious penguin with bright blue feathers and a cheerful orange beak. He loves exploring the icy landscape and making new friends – especially with the jellyfish who float by his home in the ocean."
  }
}

`;

const TRANSLATE_PAYLOAD = (language: string, payload: string) => `
You are a proficient and accurate AI translator. Your task is to translate all values in the provided JSON payload from their original language to ${language}. Do not translate the JSON keys, only the values. Ensure the translated content retains the same JSON structure as the original and is grammatically correct. Return only the new translated payload.
User-Provided JSON Payload:
${payload}

Translate all values in the JSON payload to ${language} and return the new payload.

Examples:

Original Payload: 
[{
    description: 'Penelopa and Klementyna decide to create a beautiful flower garden in their backyard. The story follows their adventures as they gather seeds and plan their garden. They learn about the different types of flowers, the importance of caring for plants, and the beauty of nature. The garden becomes a symbol of their creativity and friendship, reminding children that simple things like planting a garden can bring immense joy and teach valuable lessons. They also learn that hard work and dedication help make their dreams come true. The story touches upon the theme of growth, patience, nurturing, and celebrating the results of hard work.',
    title: "Penelopa's Colorful Garden"
  },
  {
    description: 'Penelopa and Klementyna discover a trail of crumbs leading to the forest! Curiosity piqued, they follow it, realizing someone has been stealing treats from their pantry. This leads them on an exciting adventure in which they encounter different woodland creatures, each with different personalities. Using their detective skills, the friends gather clues – bird droppings, a missing acorn – and follow the trail of evidence. They eventually encounter a shy squirrel who confesses to his thievery but reveals a sad story about a bird family who is struggling to find food. This story teaches about kindness, empathy, and finding unique solutions in different situations. They learn about recognizing need and how sharing and caring for the less fortunate can create positive outcomes for everyone around them.',
    title: 'The Mystery of the Missing Treats'
  },
  {
    description: "Penelopa is invited to a picnic with all the farm animals. However, she's worried because she doesn't have a gift to bring. Feeling disappointed, she goes to consult with Klementyna, who is known for her helpful advice. Together, they plan a special gift— Klementyna helps Penelopa collect beautiful wildflowers while Penelopa gathers her favorite berries to create a delicious fruit salad – showcasing their unique talents and working together. The picnic is a resounding success with Penelopa feeling proud to share her gift, reminding children of the value of expressing their love and appreciation through thoughtful gestures. This story teaches the importance of being resourceful, creative, and making considerate choices to show love and concern towards others.",
    title: "Penelopa's Big Day Out"
  }
]

Translated Payload in Polish:
[{
    description: 'Penelopa i Klementyna postanawiają stworzyć piękny ogród kwiatowy na swoim podwórku. Historia opowiada o ich przygodach podczas zbierania nasion i planowania ogrodu. Dowiadują się o różnych rodzajach kwiatów, o tym, jak ważne jest dbanie o rośliny i o pięknie natury. Ogród staje się symbolem ich kreatywności i przyjaźni, przypominając dzieciom, że proste rzeczy, takie jak sadzenie ogrodu, mogą przynieść ogromną radość i nauczyć cennych lekcji. Uczą się również, że ciężka praca i poświęcenie pomagają spełniać marzenia. Historia porusza temat rozwoju, cierpliwości, pielęgnacji i celebrowania rezultatów ciężkiej pracy.',
    title: 'Kolorowy ogród Penelopy'
  },
  {
    description: 'Penelopa i Klementyna odkrywają ślad okruchów prowadzący do lasu! Zaciekawione, idą za nim, zdając sobie sprawę, że ktoś kradnie smakołyki z ich spiżarni. To prowadzi je do ekscytującej przygody, w której spotykają różne leśne stworzenia, z których każde ma inną osobowość. Wykorzystując swoje umiejętności detektywistyczne, przyjaciółki zbierają wskazówki - ptasie odchody, brakujący żołądź - i podążają śladem dowodów. W końcu napotykają nieśmiałą wiewiórkę, która przyznaje się do kradzieży, ale wyjawia smutną historię o ptasiej rodzinie, która ma problemy ze znalezieniem pożywienia. Ta historia uczy o życzliwości, empatii i znajdowaniu unikalnych rozwiązań w różnych sytuacjach. Uczą się rozpoznawać potrzeby i tego, jak dzielenie się i troska o mniej szczęśliwych może przynieść pozytywne rezultaty dla wszystkich wokół.',
    title: 'Tajemnica Znikających Przysmaków'
  },
  {
    description: 'Penelopa zostaje zaproszona na piknik ze wszystkimi zwierzętami z farmy. Martwi się jednak, ponieważ nie ma prezentu do przyniesienia. Zrozpaczona idzie po radę do Klementyny, która znana jest ze swoich pomocnych rad. Razem planują specjalny prezent - Klementyna pomaga Penelopie zbierać piękne polne kwiaty, podczas gdy Penelopa zbiera swoje ulubione jagody, aby stworzyć pyszną sałatkę owocową - prezentując swoje wyjątkowe talenty i współpracując ze sobą. Piknik jest ogromnym sukcesem, a Penelopa jest dumna, że może podzielić się swoim prezentem, przypominając dzieciom o wartości wyrażania swojej miłości i uznania poprzez przemyślane gesty. Ta historia uczy, jak ważne jest bycie zaradnym, kreatywnym i dokonywanie przemyślanych wyborów, aby okazywać miłość i troskę innym.',
    title: 'Wielkie Wyjście Penelopy'
  }
]

Original Payload: 
[
  {
    description: "A small turtle named Shelly lives on a high hilltop. When she wants to play with her friends in the pond below, she can't climb down the steep slopes. Luckily, she meets a friendly rabbit who offers to carry her to the pond. Shelly is happily surprised by the rabbit's kindness and learns that even a small act of helping can make a big difference to someone in need!",
    title: "The Little Turtle Who Couldn't Reach",
    characterName: 'Shelly',
    characterDescription: 'A sweet and determined little turtle who wants to play with her friends in the pond.'
  },
  {
    description: "It's a dreary rainy day, and everyone is staying inside. A little pig named Penelope is sad because she can't go out to play. Her friend, a cheerful yellow duck, comes over with a big umbrella and offers to help her build a cozy fort inside! They have fun creating their perfect shelter, proving that even on a rainy day, friendship and kindness can make it a happy one.",
    title: 'The Rainy Day Surprise',
    characterName: 'Penelope',
    characterDescription: 'A sweet and playful little pig who loves playing outside.'
  },
  {
    description: "A beautiful butterfly named Flutter is separated from her friends during a windy day. She gets lost and can't find her way back to the flower patch. Luckily, a kind-hearted ladybug named Dot sees her and helps her navigate through the tall grass back to her friends. Flutter is grateful for Dot's help and learns that even in a large and confusing world, kindness can help anyone find their way home.",
    title: 'The Lost Butterfly',
    characterName: 'Flutter',
    characterDescription: 'A lost and cheerful butterfly who wants to be reunited with her friends.'
  }
]
Translated Payload in Polish:
[
  {
    description: 'Mały żółw o imieniu Shelly mieszka na wysokim wzgórzu. Kiedy chce pobawić się ze swoimi przyjaciółmi w stawie poniżej, nie może zejść po stromych zboczach. Na szczęście spotyka przyjaznego królika, który oferuje jej, że ją tam zaniesie. Shelly jest mile zaskoczona dobrocią królika i dowiaduje się, że nawet mały gest pomocy może wiele zmienić dla kogoś w potrzebie!',
    title: 'Mały żółw, który nie mógł dosięgnąć',
    characterName: 'Shelly',
    characterDescription: 'Słodki i zdeterminowany mały żółw, który chce bawić się ze swoimi przyjaciółmi w stawie.'
  },
  {
    description: 'Jest ponury, deszczowy dzień i wszyscy siedzą w środku. Mała świnka o imieniu Penelope jest smutna, ponieważ nie może wyjść się pobawić. Jej przyjaciółka, wesoła żółta kaczka, przychodzi z dużym parasolem i oferuje jej pomoc w budowie przytulnego fortu w środku! Świetnie się bawią, tworząc swoje idealne schronienie, udowadniając, że nawet w deszczowy dzień przyjaźń i życzliwość mogą uczynić go szczęśliwym.',
    title: 'Deszczowa niespodzianka',
    characterName: 'Penelope',
    characterDescription: 'Słodka i wesoła mała świnka, która uwielbia bawić się na dworze.'
  },
  {
    description: 'Piękny motyl o imieniu Flutter zostaje oddzielony od swoich przyjaciół podczas wietrznego dnia. Gubi się i nie może znaleźć drogi powrotnej do kwietnej łąki. Na szczęście dobroduszna biedronka o imieniu Dot widzi ją i pomaga jej przedostać się przez wysoką trawę z powrotem do przyjaciół. Flutter jest wdzięczna Dot za pomoc i dowiaduje się, że nawet w dużym i zagmatwanym świecie życzliwość może pomóc każdemu znaleźć drogę do domu.',
    title: 'Zagubiony motyl',
    characterName: 'Flutter',
    characterDescription: 'Zagubiony i wesoły motyl, który chce się połączyć ze swoimi przyjaciółmi.'
  }
]
`;

const apiKey = defineString("GOOGLE_API_KEY");

function findAndParseJsonLikeText(text: string) {
  const pattern = /{[^{}]*}|{(?:[^{}]*|{[^{}]*})*}/g;
  const jsonLikeTexts = Array.from(text.matchAll(pattern), (m) => m[0]);

  return jsonLikeTexts.map((jsonText) => parse(jsonText));
}

const AutoFillForm = z.object({
  description: z.string(),
});

const FreeFormProposalsForm = z.array(
  z.object({
    title: z.string(),
    description: z.string(),
    characterName: z.string(),
    characterDescription: z.string(),
  })
);

const ProposalsForm = z.array(
  z.object({
    description: z.string(),
    title: z.string(),
  })
);

const AutoFillCharacterForm = z.object({
  name: z.string(),
  description: z.string(),
});

function getModel({
  maxOutputTokens = 500,
  temperature = 0,
  topP = 0,
  topK = 0,
  candidateCount = 1,
  model = "gemini-1.5-flash",
}) {
  const genAI = new GoogleGenerativeAI(apiKey.value());

  return genAI.getGenerativeModel({
    model: model,
    generationConfig: {
      temperature: temperature,
      maxOutputTokens: maxOutputTokens,
      topP: topP,
      topK: topK,
      candidateCount: candidateCount,
    },
    safetySettings: [
      {
        category: HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT,
        threshold: HarmBlockThreshold.BLOCK_LOW_AND_ABOVE,
      },
      {
        category: HarmCategory.HARM_CATEGORY_HARASSMENT,
        threshold: HarmBlockThreshold.BLOCK_LOW_AND_ABOVE,
      },
      {
        category: HarmCategory.HARM_CATEGORY_HATE_SPEECH,
        threshold: HarmBlockThreshold.BLOCK_LOW_AND_ABOVE,
      },
      {
        category: HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT,
        threshold: HarmBlockThreshold.BLOCK_LOW_AND_ABOVE,
      },
    ],
  });
}

const parseResult = (resp: GenerateContentResult) => {
  if (
    resp.response.candidates &&
    resp.response.candidates[0].finishReason === "SAFETY"
  ) {
    return [
      {
        valid: false,
        message: "The generated content is not safe for children.",
      },
    ];
  } else if ((resp.response.candidates?.length ?? 0) > 0) {
    return findAndParseJsonLikeText(
      resp.response.candidates?.[0].content.parts[0].text ?? ""
    );
  } else {
    return null;
  }
};

const autoFillMoral = async (description: string, language: string) => {
  const generativeModel = getModel({
    maxOutputTokens: 8192,
    model: "gemini-1.5-flash",
    temperature: 1.2,
    topP: 1.0,
    topK: 50,
  });

  const resp = await generativeModel.generateContent({
    contents: [
      {
        role: "user",
        parts: [
          { text: AUTOFILL_MORAL },
          { text: "User input: " + description },
        ],
      },
    ],
  });
  const result = (parseResult(resp) || [])[0];
  const translatedResult = await translateContent(language, result);
  return AutoFillForm.parse(translatedResult);
};

const autoFillCharacter = async (
  characterName: string,
  characterDescription: string,
  language: string,
  userCharacters: string[]
) => {
  const generativeModel = getModel({
    maxOutputTokens: 4000,
    temperature: 2,
    topP: 1.0,
    topK: 50,
    candidateCount: 1,
    model: "gemini-1.5-flash",
  });

  const resp = await generativeModel.generateContent({
    contents: [
      {
        role: "user",
        parts: [
          {
            text: AUTOFILL_CHARACTER(
              characterName,
              characterDescription,
              userCharacters
            ),
          },
        ],
      },
    ],
  });

  const result = (parseResult(resp) || [])[0];
  const translatedResult = await translateContent(language, result);
  return AutoFillCharacterForm.parse(translatedResult);
};

const generateProposals = async (
  moral: string,
  characterName: string,
  characterDescription: string,
  suggestions: string[] = [],
  language: string
) => {
  const generativeModel = getModel({
    maxOutputTokens: 8192,
    temperature: 1.2,
    topP: 1,
    topK: 50,
    candidateCount: 1,
    model: "gemini-1.5-flash",
  });

  const resp = await generativeModel.generateContent({
    contents: [
      {
        role: "user",
        parts: [
          {
            text: GET_PROPOSALS(
              characterName,
              characterDescription,
              moral,
              suggestions.join(" ,")
            ),
          },
        ],
      },
    ],
  });

  const result = parseResult(resp) || [];
  const translatedResult = (await translateContent(language, result)).map(
    (item) => ({
      description: item.description,
      title: item.title,
    })
  );

  return ProposalsForm.parse(translatedResult);
};

const translateContent = async <T>(
  language: string,
  payload: T,
  usePremiumModel = false
) => {
  const generativeModel = getModel({
    maxOutputTokens: 8192,
    temperature: 0,
    candidateCount: 1,
    model: usePremiumModel ? "gemini-1.5-pro" : "gemini-1.5-flash",
  });
  //if langauge is english, no need to translate
  if (language.toLowerCase() === "english") {
    return payload;
  }
  const isPayloadArray = Array.isArray(payload);

  const resp = await generativeModel.generateContent({
    contents: [
      {
        role: "user",
        parts: [
          {
            text: TRANSLATE_PAYLOAD(language, JSON.stringify(payload)),
          },
        ],
      },
    ],
  });

  const result = parseResult(resp) || [];
  return (isPayloadArray ? result : result[0]) as T;
};

const parseStoryLength = (storyLength: string) => {
  switch (storyLength) {
    case "short":
      return "5-7 pages. Perfect for kids under 3 years old. ";
    case "long":
      return "12-20 pages. Perfect for children over 5 years old. ";
    case "medium":
    default:
      return "8-12 pages. Perfect for children between 3 and 5 years old.";
  }
};

const generateStory = async (
  moral: string,
  characterName: string,
  characterDescription: string,
  plot: string,
  suggestions: string[] = [],
  storyLength: string,
  language: string
) => {
  const generativeModel = getModel({
    maxOutputTokens: 8192,
    temperature: 1.2,
    topP: 1,
    topK: 50,
    candidateCount: 1,
    model: "gemini-1.5-flash",
  });

  const resp = await generativeModel.generateContent({
    contents: [
      {
        role: "user",
        parts: [
          { text: GET_STORY },
          {
            text:
              "User input: Character name:" +
              characterName +
              " \n\n Character description: " +
              characterDescription +
              "\n\n Moral: " +
              moral +
              "\n\n Plot:" +
              plot +
              "\n\n Suggestions: " +
              suggestions.join(", ") +
              "\n\n Story length: Story length should contains" +
              parseStoryLength(storyLength),
          },
        ],
      },
    ],
  });

  const result = (parseResult(resp) || []).map((item, index) => ({
    text: item.text,
    index: index,
    // page: item.page,
  }));
  //translate if needed

  return await translateContent(language, result, true);
};

const validateFreeForm = async (text: string) => {
  const generativeModel = getModel({
    topK: 50,
    temperature: 1,
    model: "gemini-1.5-pro",
  });

  const resp = await generativeModel.generateContent({
    contents: [
      {
        role: "user",
        parts: [{ text: VALIDATE_FREE_FORM(text) }],
      },
    ],
  });
  return (parseResult(resp) || [])[0];
};

const validateMoral = async (moral: string, language: string) => {
  const generativeModel = getModel({
    topK: 50,
    temperature: 1,
    model: "gemini-1.5-pro",
  });
  //moral or suggestions cant be empty
  if (!moral) {
    throw new HttpsError("invalid-argument", "Missing required fields.");
  }

  const resp = await generativeModel.generateContent({
    contents: [
      {
        role: "user",
        parts: [{ text: VALIDATE_MORAL(moral, language) }],
      },
    ],
  });
  return (parseResult(resp) || [])[0];
};

const validateCharacter = async (
  characterName: string,
  characterDescription: string
) => {
  const generativeModel = getModel({
    topK: 50,
    temperature: 1,
    model: "gemini-1.5-pro",
  });

  const resp = await generativeModel.generateContent({
    contents: [
      {
        role: "user",
        parts: [
          { text: VALIDATE_CHARACTER(characterName, characterDescription) },
        ],
      },
    ],
  });
  return (parseResult(resp) || [])[0];
};

const generateProposalsFromTale = async (
  taleDescription: string,
  characterName: string,
  characterDescription: string | undefined,
  language: string
) => {
  const generativeModel = getModel({
    maxOutputTokens: 8192,
    temperature: 1.2,
    topP: 1.0,
    topK: 50,
    candidateCount: 1,
  });

  const resp = await generativeModel.generateContent({
    contents: [
      {
        role: "user",
        parts: [
          {
            text: GET_PROPOSALS_FROM_TALE(
              characterName,
              characterDescription,
              taleDescription
            ),
          },
        ],
      },
    ],
  });

  const result = (parseResult(resp) || []).map((item) => ({
    description: item.description,
    title: item.title,
  }));

  //translate if needed
  const translatedResult = await translateContent(language, result, true);
  return ProposalsForm.parse(translatedResult);
};

const generateProposalsFromFreeForm = async (
  text: string,
  language: string
) => {
  const generativeModel = getModel({
    maxOutputTokens: 8192,
    temperature: 1.2,
    topP: 1,
    topK: 50,
    candidateCount: 1,
  });

  const resp = await generativeModel.generateContent({
    contents: [
      {
        role: "user",
        parts: [
          { text: GET_PROPOSALS_FROM_FREE_FORM(text) },
          {
            text: "The story description - User input:" + text,
          },
        ],
      },
    ],
  });

  const result = (parseResult(resp) || []).map((item) => ({
    description: item.description,
    title: item.title,
    characterName: item.characterName,
    characterDescription: item.characterDescription,
  }));

  //translate if needed
  const translatedResult = await translateContent(language, result, true);
  return FreeFormProposalsForm.parse(translatedResult);
};

export {
  autoFillMoral,
  autoFillCharacter,
  generateProposals,
  generateStory,
  validateCharacter,
  validateMoral,
  generateProposalsFromFreeForm,
  validateFreeForm,
  translateContent,
  generateProposalsFromTale,
};
