# Tinytales

Frontend for Tinytales, app for Google Gemini API competition.

## Getting Started

Make sure you have at least Flutter `3.22.0`.

When you clone the repository you should do few things before you can start to hack:

1. Setup your own Firebase project based on the [official documentation](https://firebase.google.com/docs/flutter/setup?platform=android) and using out backend repository tinytales-backend.

2. Run below commands in the root of the project:

    ```shell
    # flutter setup
    flutter pub get
    dart run build_runner build -d
    ```

3. Try to run the app with `flutter run` command.

### Running tests and analysis

To run tests and analysis, you can use below commands:

```shell
./script/checks.sh
```

If you have problem with permissions run:

```shell
chmod +x ./script/checks.sh
```

### Google sign in on Android

To be able to sign in with Google on Android in debug mode (local build) you need to provide the SHA-1 of your signing certificate to Firebase. To get the SHA-1 of your debug certificate, you can use the following command:

```shell
keytool -list -v \
-alias androiddebugkey -keystore ~/.android/debug.keystore
```

The default password for the debug keystore is `android`.

The SHA-1 should be pasted in the Firebase console under the `project settings` -> `android app` -> `SHA certificate fingerprints` section.

For more information, see [official documentation](https://developers.google.com/android/guides/client-auth).

### Environment variables

To set up env vars you have to pass them to the `flutter run` or `flutter build` command. For example:

```shell
flutter run --dart-define=taleai.isProd=true
```

To find out which env vars are available, check the [env.dart](lib/env/env.dart) file.

### Web cache issue

We were facing an issue with the cache on the web - [issue](https://github.com/flutter/flutter/issues/149031). To fix it, we added a workaround in the [firebase.json](firebase.json) with headers to disable the cache based on this [comment](https://github.com/flutter/flutter/issues/149031#issuecomment-2249733901).

### Testing

#### Golden tests

To update golden tests, run:

```shell
flutter test --update-goldens
```

This command is going to update all golden files in the project and is what you should use when writing new tests.

To run golden tests, run:

```shell
flutter test
```

Same as all other tests.

##### VSCode Configuration

We also have special VSCode configuration for golden tests. You can run specific test directly from the editor by clicking `Golden` above the test (should be next to the `Run | Debug` buttons).

##### Updating Golden Tests in a PR

Once your tests are ready, create a PR. If you have updated an existing golden test or
added a new one, the CI will detect this and generate the necessary golden files
for you within the PR. This setup ensures that tests do not fail due to mismatched
golden files generated on different machines.

If you anticipate that the golden file will change due to code modifications
(rather than changes to the golden tests), remove or regenerate the golden file.
This way, the CI will recognize the change in the golden tests and generate new golden
files accordingly.
