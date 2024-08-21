// ignore_for_file: avoid_redundant_argument_values
//
// Env variables.
// This file is used to store all the environment variables.
// Env vars should be set during the build process using --dart-define or
// --dart-define-from-file flags.
// For more details check `flutter build apk/ios/web --help`.
//
// Default values are set for local development.

const kIsProd = bool.fromEnvironment('taleai.isProd', defaultValue: false);
