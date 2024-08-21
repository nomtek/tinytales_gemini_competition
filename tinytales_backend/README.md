# Tinytales Backend

This repository contains the backend code for Tinytales, a project developed as part of the Google Gemini API competition. The backend is built using Firebase Cloud Functions.

## Getting Started

Before you can start working with the Tinytales backend, make sure you have the necessary tools and dependencies installed.

### Prerequisites

- **Node.js**: Ensure you have Node.js installed (v14 or later).
- **Firebase CLI**: Install the Firebase CLI if you haven't already. You can install it globally with npm:
  ```shell
  npm install -g firebase-tools
  ```
- **Firebase Project**: Set up a Firebase project. You can either create a new project or use an existing one. Follow the [Firebase setup guide](https://firebase.google.com/docs/flutter/setup) for more details.

### Project Setup

1. **Clone the repository**:

   ```shell
   git clone https://github.com/nomtek/tinytales_gemini_competition.git
   cd tinytales_backend
   ```

2. **Install dependencies**:

   Run the following command to install the necessary npm packages:

   ```shell
   npm install
   ```

3. **Firebase Configuration**:

   Make sure you are logged in to Firebase CLI and have initialized the project:

   ```shell
   firebase login
   firebase use --add
   ```

   Select the Firebase project you want to use for this backend.

4. **Environment Variables**:

   The project relies on several environment variables that must be configured for it to work correctly. These variables are stored in a `.env.local` file. Before deploying or running the project, you need to update the `.env` file with these values:

   Copy `.env.local` to `.env`:

   ```shell
   cp .env.local .env
   ```

   Then, open the `.env` file and update the following variables with your specific keys and IDs:

   ```plaintext
   GOOGLE_API_KEY=your_google_api_key
   REPLICATE_TOKEN=your_replicate_token
   ELEVENLABS_API_KEY=your_elevenlabs_api_key
   ELEVEN_LABS_VOICE_ID=your_eleven_labs_voice_id
   PROJECT_ID=your_firebase_project_id
   DEFAULT_PICTURE_URL=your_default_picture_url
   REPLICATE_IMAGE_MODEL_ID=your_replicate_image_model_id
   ```

   - `GOOGLE_API_KEY`: API key for Google Gemini.
   - `REPLICATE_TOKEN`: Token for the Replicate API.
   - `ELEVENLABS_API_KEY`: API key for Eleven Labs (used for audio generation).
   - `ELEVEN_LABS_VOICE_ID`: Voice ID for Eleven Labs.
   - `PROJECT_ID`: Firebase project ID (used for URL path generation, particularly for images).
   - `DEFAULT_PICTURE_URL`: URL for the default picture.
   - `REPLICATE_IMAGE_MODEL_ID`: Model ID for the Replicate image generation.

5. **Deploying Cloud Functions**:

   Once everything is set up, you can deploy the functions to Firebase:

   ```shell
   firebase deploy --only functions
   ```
